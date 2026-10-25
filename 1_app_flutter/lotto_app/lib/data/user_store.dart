// 간단 가입 정보와 이용 기록 (기기에만 저장)
//
// 지금은 서버 없이 기기 안(SharedPreferences)에 저장합니다.
// 나중에 Firebase 등 서버 계정을 붙일 때는 이 파일의 저장·불러오기만 바꾸면 됩니다.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../engine/combination_engine.dart' show Ticket;

class UserProfile {
  final String nickname;
  final DateTime createdAt;

  const UserProfile(this.nickname, this.createdAt);

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    j['nickname'] as String,
    DateTime.parse(j['createdAt'] as String),
  );

  /// 닉네임 규칙: 앞뒤 공백 제외 2~12자
  static bool validNickname(String s) {
    final n = s.trim().runes.length;
    return n >= 2 && n <= 12;
  }
}

/// 번호 추출 한 번의 기록
class HistoryEntry {
  final int id; // 만든 시각(ms) — 고유 키
  final String gameId;
  final DateTime createdAt;
  final List<Ticket> tickets;
  final int filterCount;
  final List<int> include;
  final List<int> exclude;

  const HistoryEntry({
    required this.id,
    required this.gameId,
    required this.createdAt,
    required this.tickets,
    this.filterCount = 0,
    this.include = const [],
    this.exclude = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'gameId': gameId,
    'createdAt': createdAt.toIso8601String(),
    'tickets': [
      for (final t in tickets) {'main': t.main, 'bonus': t.bonus},
    ],
    'filterCount': filterCount,
    'include': include,
    'exclude': exclude,
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
    id: j['id'] as int,
    gameId: j['gameId'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    tickets: [
      for (final t in j['tickets'] as List)
        Ticket(
          List<int>.from((t as Map)['main'] as List),
          List<int>.from(t['bonus'] as List),
        ),
    ],
    filterCount: j['filterCount'] as int? ?? 0,
    include: List<int>.from(j['include'] as List? ?? const []),
    exclude: List<int>.from(j['exclude'] as List? ?? const []),
  );
}

class UserStore {
  UserStore._();

  static const _profileKey = 'userProfile';
  static const _historyKey = 'extractHistory';

  /// 오래된 기록부터 지워 최대 개수를 유지 (기기 저장 공간 보호)
  static const int maxHistory = 300;

  static Future<UserProfile?> profile() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(
        _profileKey,
      );
      return raw == null
          ? null
          : UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveProfile(UserProfile p) async =>
      (await SharedPreferences.getInstance()).setString(
        _profileKey,
        jsonEncode(p.toJson()),
      );

  static Future<List<HistoryEntry>> history() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(
        _historyKey,
      );
      if (raw == null) return [];
      return [
        for (final j in jsonDecode(raw) as List)
          HistoryEntry.fromJson(j as Map<String, dynamic>),
      ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveHistory(List<HistoryEntry> list) async =>
      (await SharedPreferences.getInstance()).setString(
        _historyKey,
        jsonEncode([for (final e in list) e.toJson()]),
      );

  static Future<void> addHistory(HistoryEntry e) async {
    final list = await history();
    list.insert(0, e);
    await _saveHistory(list.take(maxHistory).toList());
  }

  /// 백업 복원용: 기록 전체를 바꿉니다 (최신순 정렬·최대 개수 유지)
  static Future<void> replaceHistory(List<HistoryEntry> list) async {
    final sorted = [...list]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _saveHistory(sorted.take(maxHistory).toList());
  }

  static Future<void> removeHistory(int id) async {
    final list = await history();
    await _saveHistory(list.where((e) => e.id != id).toList());
  }

  static Future<void> clearHistory() async =>
      (await SharedPreferences.getInstance()).remove(_historyKey);

  /// 탈퇴: 가입 정보와 추출 기록 삭제 (언어·당첨번호 직접 입력분은 남김)
  static Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_historyKey);
  }
}
