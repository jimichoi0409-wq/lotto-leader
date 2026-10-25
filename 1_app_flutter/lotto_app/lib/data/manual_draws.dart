// 당첨번호 직접 입력 (자동 갱신이 안 될 때를 대비)
//
// - 직접 입력한 회차는 기기에만 저장되고(SharedPreferences), 공식 데이터와 합쳐서 보여 줍니다.
// - 같은 날짜(회차)의 공식 데이터가 들어오면 공식 데이터가 우선하고, 직접 입력분은 정리됩니다.
// - 자동 갱신 검증(draw_validation.dart)에는 공식 데이터만 쓰므로, 잘못 입력해도 갱신을 막지 않습니다.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../games/draw_record.dart';
import '../games/game_config.dart';

enum ManualDrawError {
  round,
  mainNumbers,
  bonusNumbers,
  bonusOverlap,
  date,
  exists,
}

const _weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

String _iso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// 공식 + 직접 입력 → 최신 회차가 앞. 같은 날짜는 공식이 우선합니다.
List<DrawRecord> mergeDraws(
  List<DrawRecord> official,
  List<DrawRecord> manual,
) {
  if (manual.isEmpty) return official;
  final officialDates = {for (final d in official) d.date};
  final extra = [
    for (final d in manual)
      if (!officialDates.contains(d.date)) d,
  ];
  if (extra.isEmpty) return official;
  return [...official, ...extra]..sort((a, b) => b.date.compareTo(a.date));
}

/// 다음에 입력할 회차 번호 (한국은 공식 회차, 해외는 일련번호)
int nextDrawNo(List<DrawRecord> draws) => draws.isEmpty
    ? 1
    : draws.map((d) => d.no).reduce((a, b) => a > b ? a : b) + 1;

/// 아직 기록되지 않은 가장 최근 추첨일 (마지막 기록 다음 추첨일, 오늘 이후면 오늘 이전 마지막 추첨일)
DateTime suggestedDrawDate(
  GameConfig game,
  List<DrawRecord> draws,
  DateTime today,
) {
  final day = DateTime(today.year, today.month, today.day);
  bool isDrawDay(DateTime d) =>
      game.drawDays.contains(_weekdays[d.weekday - 1]);

  if (draws.isNotEmpty) {
    final last = DateTime.tryParse(draws.first.date);
    if (last != null) {
      for (
        var d = last.add(const Duration(days: 1));
        !d.isAfter(day);
        d = d.add(const Duration(days: 1))
      ) {
        if (isDrawDay(d)) return d;
      }
    }
  }
  for (var d = day; ; d = d.subtract(const Duration(days: 1))) {
    if (isDrawDay(d)) return d;
  }
}

/// 직접 입력값 검사. 문제가 없으면 null.
ManualDrawError? validateManualDraw(
  GameConfig game,
  DrawRecord d,
  List<DrawRecord> existing,
  DateTime today,
) {
  if (d.no < 1) return ManualDrawError.round;

  bool valid(List<int> nums, int count, int max) =>
      nums.length == count &&
      nums.toSet().length == count &&
      nums.every((n) => n >= 1 && n <= max);
  if (!valid(d.main, game.main.count, game.main.max)) {
    return ManualDrawError.mainNumbers;
  }
  if (!valid(d.bonus, game.bonus.count, game.bonus.max)) {
    return ManualDrawError.bonusNumbers;
  }
  if (!game.bonus.playerPicks && d.bonus.any(d.main.contains)) {
    return ManualDrawError.bonusOverlap;
  }

  final date = DateTime.tryParse(d.date);
  final day = DateTime(today.year, today.month, today.day);
  if (date == null ||
      date.isAfter(day) ||
      (game.ruleSince != null && date.isBefore(game.ruleSince!)) ||
      !game.drawDays.contains(_weekdays[date.weekday - 1])) {
    return ManualDrawError.date;
  }

  final sameNoMatters = game.id == 'kr645'; // 한국은 회차가 공식 번호
  if (existing.any(
    (e) => e.date == d.date || (sameNoMatters && e.no == d.no),
  )) {
    return ManualDrawError.exists;
  }
  return null;
}

class ManualDrawStore {
  ManualDrawStore._();

  static String _key(String gameId) => 'manualDraws.$gameId';

  static Future<List<DrawRecord>> load(String gameId) async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(
        _key(gameId),
      );
      if (raw == null) return const [];
      final list = [
        for (final j in jsonDecode(raw) as List)
          DrawRecord.fromJson(j as Map<String, dynamic>, manual: true),
      ]..sort((a, b) => b.date.compareTo(a.date));
      return list;
    } catch (_) {
      return const [];
    }
  }

  static Future<void> save(String gameId, List<DrawRecord> draws) async {
    final prefs = await SharedPreferences.getInstance();
    if (draws.isEmpty) {
      await prefs.remove(_key(gameId));
    } else {
      await prefs.setString(
        _key(gameId),
        jsonEncode([for (final d in draws) d.toJson()]),
      );
    }
  }

  /// 공식 데이터에 이미 들어온 날짜의 직접 입력분을 지우고, 남은 목록을 돌려줍니다.
  static Future<List<DrawRecord>> prune(
    String gameId,
    List<DrawRecord> official,
  ) async {
    final manual = await load(gameId);
    final officialDates = {for (final d in official) d.date};
    final kept = [
      for (final d in manual)
        if (!officialDates.contains(d.date)) d,
    ];
    if (kept.length != manual.length) await save(gameId, kept);
    return kept;
  }

  static String isoDate(DateTime d) => _iso(d);
}
