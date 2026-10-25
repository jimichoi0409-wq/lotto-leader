// 추첨일 알림: 복권마다 따로 켜고, 추첨 3시간 전에 휴대폰 알림을 보냅니다.
// 알림 시각은 복권 현지 시간대(GameConfig.timezone)로 잡으므로 서머타임이 바뀌어도
// 추첨 시각과의 간격이 유지되고, 휴대폰의 시간대와도 상관없습니다.

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../games/game_config.dart';

/// 추첨 몇 분 전에 알릴지
const alarmLeadMinutes = 180;

const _prefsKey = 'drawAlarms';
const _weekdayCodes = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

/// 현지 시간 기준 매주 반복되는 알림 시각 (weekday: 1=월 … 7=일)
class WeeklySlot {
  final int weekday;
  final int hour;
  final int minute;

  const WeeklySlot(this.weekday, this.hour, this.minute);

  @override
  bool operator ==(Object other) =>
      other is WeeklySlot &&
      other.weekday == weekday &&
      other.hour == hour &&
      other.minute == minute;

  @override
  int get hashCode => Object.hash(weekday, hour, minute);

  @override
  String toString() => 'WeeklySlot($weekday $hour:$minute)';
}

/// 추첨 요일·시각에서 [leadMinutes] 만큼 앞당긴 알림 시각들.
/// 새벽 추첨이라 전날로 넘어가면 요일도 하루 당깁니다.
List<WeeklySlot> alarmSlots(
  GameConfig game, {
  int leadMinutes = alarmLeadMinutes,
}) {
  final slots = <WeeklySlot>[];
  for (final code in game.drawDays) {
    final day = _weekdayCodes.indexOf(code) + 1;
    if (day == 0) continue;
    var minutes = game.drawHour * 60 + game.drawMinute - leadMinutes;
    var weekday = day;
    while (minutes < 0) {
      minutes += 24 * 60;
      weekday = weekday == 1 ? 7 : weekday - 1;
    }
    slots.add(WeeklySlot(weekday, minutes ~/ 60, minutes % 60));
  }
  return slots;
}

/// [slot] 이 [from] 이후 처음 돌아오는 시각 (slot 과 from 은 같은 시간대)
tz.TZDateTime nextOccurrence(WeeklySlot slot, tz.TZDateTime from) {
  final loc = from.location;
  for (var add = 0; add <= 7; add++) {
    final d = DateTime(from.year, from.month, from.day + add);
    if (d.weekday != slot.weekday) continue;
    final at = tz.TZDateTime(
      loc,
      d.year,
      d.month,
      d.day,
      slot.hour,
      slot.minute,
    );
    if (at.isAfter(from)) return at;
  }
  // 같은 요일인데 이미 지난 경우 → 다음 주
  final d = DateTime(from.year, from.month, from.day + 7);
  return tz.TZDateTime(loc, d.year, d.month, d.day, slot.hour, slot.minute);
}

/// 복권 id 별로 겹치지 않는 알림 id (복권 순서가 바뀌어도 그대로 유지)
int alarmId(String gameId, int slotIndex) {
  var h = 0;
  for (final c in gameId.codeUnits) {
    h = (h * 31 + c) % 100000;
  }
  return h * 10 + slotIndex;
}

class DrawAlarm {
  DrawAlarm._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  /// 휴대폰 알림을 쓸 수 있는 환경인지 (웹·데스크톱은 미지원)
  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static Future<Set<String>> enabledGames() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_prefsKey) ?? const []).toSet();
  }

  static Future<void> _saveEnabled(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, ids.toList()..sort());
  }

  static Future<bool> _init() async {
    if (!supported) return false;
    if (_ready) return true;
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (r) {
        final id = r.payload;
        if (id != null && id.isNotEmpty) onOpenGame?.call(id);
      },
    );
    _ready = true;
    return true;
  }

  /// 앱이 켜져 있을 때 알림을 누르면 그 복권 id 로 불립니다.
  static void Function(String gameId)? onOpenGame;

  /// 알림을 눌러 앱이 새로 실행됐다면 그 복권 id
  static Future<String?> launchGameId() async {
    if (!await _init()) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    final id = details?.notificationResponse?.payload;
    return id == null || id.isEmpty ? null : id;
  }

  /// 알림 권한 요청. 거부되면 false.
  static Future<bool> _requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: false,
            sound: true,
          ) ??
          false;
    }
    return false;
  }

  static NotificationDetails _details(String channelName) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          'draw_alarm',
          channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      );

  static Future<void> _schedule(
    GameConfig game, {
    required String title,
    required String body,
    required String channelName,
  }) async {
    final loc = tz.getLocation(game.timezone);
    final now = tz.TZDateTime.now(loc);
    final slots = alarmSlots(game);
    for (var i = 0; i < slots.length; i++) {
      await _plugin.zonedSchedule(
        id: alarmId(game.id, i),
        scheduledDate: nextOccurrence(slots[i], now),
        notificationDetails: _details(channelName),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
        payload: game.id,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static Future<void> _cancel(String gameId) async {
    for (var i = 0; i < 7; i++) {
      await _plugin.cancel(id: alarmId(gameId, i));
    }
  }

  /// 알림 켜기/끄기. 켤 때 권한이 거부되거나 미지원 환경이면 false 를 돌려주고 저장하지 않습니다.
  static Future<bool> setEnabled(
    GameConfig game,
    bool on, {
    required String title,
    required String body,
    required String channelName,
  }) async {
    final ids = await enabledGames();
    if (!await _init()) return false;
    if (on) {
      if (!await _requestPermission()) return false;
      await _cancel(game.id);
      await _schedule(game, title: title, body: body, channelName: channelName);
      ids.add(game.id);
    } else {
      await _cancel(game.id);
      ids.remove(game.id);
    }
    await _saveEnabled(ids);
    return true;
  }

  /// 앱 시작·언어 변경 때 켜 둔 알림을 현재 언어 문구로 다시 등록합니다.
  static Future<void> rescheduleAll(
    List<GameConfig> games, {
    required String Function(GameConfig) title,
    required String Function(GameConfig) body,
    required String channelName,
  }) async {
    final ids = await enabledGames();
    if (!await _init() || ids.isEmpty) return;
    for (final g in games.where((g) => ids.contains(g.id))) {
      await _cancel(g.id);
      await _schedule(
        g,
        title: title(g),
        body: body(g),
        channelName: channelName,
      );
    }
  }

  /// 탈퇴 시 모든 알림 해제
  static Future<void> clearAll() async {
    if (await _init()) await _plugin.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
