// 기록 백업·복원: 가입 정보, 추출 기록, 직접 입력한 당첨번호, 복권별 필터를 파일 하나로 내보내고 다시 불러옵니다.
// 서버 없이 기기에만 저장하므로 휴대폰을 바꿀 때 이 파일로 옮깁니다.
// 언어·알림 설정은 새 기기에서 다시 고르도록 백업하지 않습니다(알림은 권한을 새로 받아야 함).

import 'dart:convert';

import '../games/draw_record.dart';
import '../games/game_config.dart';
import 'filter_store.dart';
import 'manual_draws.dart';
import 'user_store.dart';

const backupAppTag = 'lotto_leader';
const backupVersion = 1;

/// 백업 파일 최대 크기 (기록 300건이어도 수백 KB 수준)
const backupMaxBytes = 5 * 1024 * 1024;

class BackupData {
  final UserProfile? profile;
  final List<HistoryEntry> history;
  final Map<String, List<DrawRecord>> manualDraws;
  final Map<String, SavedFilters> filters;

  const BackupData({
    this.profile,
    this.history = const [],
    this.manualDraws = const {},
    this.filters = const {},
  });

  int get manualCount =>
      manualDraws.values.fold(0, (sum, list) => sum + list.length);
}

String encodeBackup(BackupData d, {DateTime? now}) =>
    const JsonEncoder.withIndent(' ').convert({
      'app': backupAppTag,
      'version': backupVersion,
      'createdAt': (now ?? DateTime.now()).toIso8601String(),
      'profile': d.profile?.toJson(),
      'history': [for (final e in d.history) e.toJson()],
      'manualDraws': {
        for (final e in d.manualDraws.entries)
          if (e.value.isNotEmpty) e.key: [for (final r in e.value) r.toJson()],
      },
      'filters': {
        for (final e in d.filters.entries)
          if (!e.value.isEmpty) e.key: e.value.toJson(),
      },
    });

class BackupFormatException implements Exception {
  final String message;
  const BackupFormatException(this.message);

  @override
  String toString() => 'BackupFormatException: $message';
}

bool _inRange(List<int> nums, NumberPool pool) =>
    nums.length == pool.count &&
    nums.toSet().length == nums.length &&
    nums.every((n) => n >= 1 && n <= pool.max);

/// 백업 파일을 읽습니다. 이 앱 백업이 아니거나 형식이 깨졌으면 [BackupFormatException].
/// 모르는 복권, 번호 범위가 맞지 않는 항목은 조용히 건너뜁니다.
BackupData decodeBackup(String text, List<GameConfig> games) {
  final Object? root;
  try {
    root = jsonDecode(text);
  } on FormatException {
    throw const BackupFormatException('not json');
  }
  if (root is! Map<String, dynamic> || root['app'] != backupAppTag) {
    throw const BackupFormatException('not a Lotto Leader backup');
  }
  final version = root['version'];
  if (version is! int || version > backupVersion) {
    throw const BackupFormatException('unsupported version');
  }
  final byId = {for (final g in games) g.id: g};

  UserProfile? profile;
  final p = root['profile'];
  if (p is Map<String, dynamic>) {
    try {
      final parsed = UserProfile.fromJson(p);
      if (UserProfile.validNickname(parsed.nickname)) profile = parsed;
    } catch (_) {}
  }

  final history = <HistoryEntry>[];
  for (final j in (root['history'] as List?) ?? const []) {
    try {
      final e = HistoryEntry.fromJson(j as Map<String, dynamic>);
      final g = byId[e.gameId];
      if (g == null || e.tickets.isEmpty) continue;
      final ok = e.tickets.every(
        (t) =>
            _inRange(t.main, g.main) &&
            (g.hasPlayerBonus ? _inRange(t.bonus, g.bonus) : t.bonus.isEmpty),
      );
      if (ok) history.add(e);
    } catch (_) {}
  }

  final manual = <String, List<DrawRecord>>{};
  final m = root['manualDraws'];
  if (m is Map<String, dynamic>) {
    for (final entry in m.entries) {
      final g = byId[entry.key];
      if (g == null || entry.value is! List) continue;
      final list = <DrawRecord>[];
      for (final j in entry.value as List) {
        try {
          final d = DrawRecord.fromJson(
            j as Map<String, dynamic>,
            manual: true,
          );
          if (DateTime.tryParse(d.date) != null &&
              _inRange(d.main, g.main) &&
              _inRange(d.bonus, g.bonus)) {
            list.add(d);
          }
        } catch (_) {}
      }
      if (list.isNotEmpty) manual[g.id] = list;
    }
  }

  final filters = <String, SavedFilters>{};
  final f = root['filters'];
  if (f is Map<String, dynamic>) {
    for (final entry in f.entries) {
      if (!byId.containsKey(entry.key)) continue;
      try {
        filters[entry.key] = SavedFilters.fromJson(
          entry.value as Map<String, dynamic>,
        );
      } catch (_) {}
    }
  }

  return BackupData(
    profile: profile,
    history: history,
    manualDraws: manual,
    filters: filters,
  );
}

/// 기존 기록에 백업을 합칩니다.
/// - 가입 정보: 백업에 있으면 백업 것으로 (원래 닉네임·가입일 복구)
/// - 추출 기록: 같은 id 는 하나만, 최신순, 최대 [UserStore.maxHistory] 건
/// - 직접 입력 당첨번호: 같은 날짜가 이미 있으면 지금 기기 것을 유지
/// - 필터: 백업 것으로
BackupData mergeBackup(BackupData current, BackupData backup) {
  final ids = {for (final e in current.history) e.id};
  final history = [
    ...current.history,
    for (final e in backup.history)
      if (ids.add(e.id)) e,
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  final manual = <String, List<DrawRecord>>{
    for (final e in current.manualDraws.entries) e.key: [...e.value],
  };
  for (final e in backup.manualDraws.entries) {
    final list = manual.putIfAbsent(e.key, () => []);
    final dates = {for (final d in list) d.date};
    for (final d in e.value) {
      if (dates.add(d.date)) list.add(d);
    }
    list.sort((a, b) => b.date.compareTo(a.date));
  }

  return BackupData(
    profile: backup.profile ?? current.profile,
    history: history.take(UserStore.maxHistory).toList(),
    manualDraws: manual,
    filters: {...current.filters, ...backup.filters},
  );
}

/// 복원 결과 (화면 안내용)
class RestoreSummary {
  final int historyAdded;
  final int manualAdded;

  const RestoreSummary(this.historyAdded, this.manualAdded);
}

class BackupStore {
  BackupStore._();

  static Future<BackupData> collect(List<GameConfig> games) async {
    final manual = <String, List<DrawRecord>>{};
    final filters = <String, SavedFilters>{};
    for (final g in games) {
      manual[g.id] = await ManualDrawStore.load(g.id);
      final f = await FilterStore.load(g.id);
      if (f != null) filters[g.id] = f;
    }
    return BackupData(
      profile: await UserStore.profile(),
      history: await UserStore.history(),
      manualDraws: manual,
      filters: filters,
    );
  }

  static Future<RestoreSummary> restore(
    BackupData backup,
    List<GameConfig> games,
  ) async {
    final current = await collect(games);
    final merged = mergeBackup(current, backup);
    if (merged.profile != null) await UserStore.saveProfile(merged.profile!);
    await UserStore.replaceHistory(merged.history);
    for (final g in games) {
      final list = merged.manualDraws[g.id] ?? const [];
      if (list.length != (current.manualDraws[g.id] ?? const []).length) {
        await ManualDrawStore.save(g.id, list);
      }
      final f = merged.filters[g.id];
      if (f != null) await FilterStore.save(g.id, f);
    }
    return RestoreSummary(
      merged.history.length - current.history.length,
      merged.manualCount - current.manualCount,
    );
  }
}
