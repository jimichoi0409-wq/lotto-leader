// 복권별 필터 설정 저장: 복권을 바꾸거나 앱을 다시 열어도 마지막 설정이 그대로 남습니다.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedFilters {
  /// 체크한 필터 (키는 filterOptionsFromLegacy 와 같은 이름)
  final Set<String> flags;

  /// 입력칸 원문 (빈 칸 포함, 칸 순서 유지)
  final List<String> include;
  final List<String> exclude;
  final List<String> bonusInclude;
  final List<String> bonusExclude;
  final String recentDraws;
  final String extractCount;

  /// "조회"로 구한 최다·최저 추첨 번호
  final List<int> mostFrequent;
  final List<int> leastFrequent;

  const SavedFilters({
    this.flags = const {},
    this.include = const [],
    this.exclude = const [],
    this.bonusInclude = const [],
    this.bonusExclude = const [],
    this.recentDraws = '',
    this.extractCount = '',
    this.mostFrequent = const [],
    this.leastFrequent = const [],
  });

  bool get isEmpty =>
      flags.isEmpty &&
      [
        ...include,
        ...exclude,
        ...bonusInclude,
        ...bonusExclude,
      ].every((s) => s.trim().isEmpty) &&
      recentDraws.isEmpty &&
      extractCount.isEmpty &&
      mostFrequent.isEmpty &&
      leastFrequent.isEmpty;

  Map<String, dynamic> toJson() => {
    'flags': flags.toList()..sort(),
    'include': include,
    'exclude': exclude,
    'bonusInclude': bonusInclude,
    'bonusExclude': bonusExclude,
    'recentDraws': recentDraws,
    'extractCount': extractCount,
    'mostFrequent': mostFrequent,
    'leastFrequent': leastFrequent,
  };

  factory SavedFilters.fromJson(Map<String, dynamic> j) {
    List<String> strs(String k) => [
      for (final v in (j[k] as List? ?? const [])) '$v',
    ];
    List<int> ints(String k) => [
      for (final v in (j[k] as List? ?? const []))
        if (v is int) v,
    ];
    return SavedFilters(
      flags: strs('flags').toSet(),
      include: strs('include'),
      exclude: strs('exclude'),
      bonusInclude: strs('bonusInclude'),
      bonusExclude: strs('bonusExclude'),
      recentDraws: (j['recentDraws'] ?? '') as String,
      extractCount: (j['extractCount'] ?? '') as String,
      mostFrequent: ints('mostFrequent'),
      leastFrequent: ints('leastFrequent'),
    );
  }
}

class FilterStore {
  FilterStore._();

  static String _key(String gameId) => 'filters.$gameId';

  static Future<SavedFilters?> load(String gameId) async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(
        _key(gameId),
      );
      if (raw == null) return null;
      return SavedFilters.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('필터 설정 읽기 실패: $e');
      return null;
    }
  }

  static Future<void> save(String gameId, SavedFilters f) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (f.isEmpty) {
        await prefs.remove(_key(gameId));
      } else {
        await prefs.setString(_key(gameId), jsonEncode(f.toJson()));
      }
    } catch (e) {
      debugPrint('필터 설정 저장 실패: $e');
    }
  }

  static Future<void> clear(String gameId) async {
    try {
      await (await SharedPreferences.getInstance()).remove(_key(gameId));
    } catch (e) {
      debugPrint('필터 설정 삭제 실패: $e');
    }
  }
}
