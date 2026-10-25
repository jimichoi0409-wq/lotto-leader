// 필터 조건. 기존 6/45 전용 19개 필터를 복권 규칙(GameConfig)에 맞춰 일반화한 것입니다.
//
// 기존 필터 → 일반화
//   역대 1등 번호 제외            → excPastFullMatch   (메인 번호 전체 일치)
//   역대 2/3등 패턴 제외          → excPastMinus1      (메인 개수 − 1 개 일치)
//   역대 4등 조합 제외 (최근 100회) → excPastMinus2Recent (메인 개수 − 2 개 일치, 최근 N회)
//   역대 5등 중 연속 조합 제외     → excPastConsecTriple
//   10구간 내 올인 제외            → excNarrowRange (+ narrowRangeMax, 번호 범위에 비례)
//   홀짝 배열 패턴 5종             → excludedParityMasks (자리별 홀짝 비트마스크)
//   나머지(3연속, 건너뛰기, 2쌍 연속, 전부 홀/짝, 같은 끝수, 3연속 배수)는 그대로
//
// 해외 복권용 추가 필터 (2026-10-20)
//   excSumOutside    번호 합계가 평균 ± 2표준편차 밖 (약 5%)
//   excAllBirthday   모두 31 이하 (생일 번호 → 1등 당첨금을 나눌 위험)
//   excAllLowOrHigh  전부 앞쪽 절반 또는 전부 뒤쪽 절반
//   excSameDecade4   같은 10번대에 4개 이상
//   excRepeatLast2   직전 회차 메인 번호 2개 이상 포함
//   보조 번호: bonusExcRecent(최근 N회), bonusExcConsec(연속 쌍), bonusExcSameParity(둘 다 홀/짝)

import 'dart:math' as math;

import '../games/game_config.dart';

class FilterOptions {
  // 메인 번호 포함·제외
  final Set<int> include;
  final Set<int> exclude;

  // 사용자가 고르는 보조 번호 포함·제외 (파워볼, 럭키스타 등)
  final Set<int> bonusInclude;
  final Set<int> bonusExclude;

  final bool excPastFullMatch;
  final bool excPastMinus1;
  final bool excPastMinus2Recent;

  /// null 이면 복권에 맞춰 자동: 번호 6개 복권은 100회, 5개 복권은 20회
  /// (5개 복권에서 100회를 쓰면 유로밀리언 기준 약 38% 가 제외돼 너무 많음)
  final int? recentDrawsForMinus2;
  final bool excPastConsecTriple;

  final bool exc3Consec;
  final bool excSkip1;
  final bool excSkip2;
  final bool excSkip3;
  final bool exc2Pairs;

  final bool excNarrowRange;

  /// (최대 번호 − 최소 번호) 가 이 값 이하이면 제외. null 이면 번호 범위에 비례해 자동 계산.
  final int? narrowRangeMax;

  final bool excAllOdd;
  final bool excAllEven;

  /// 제외할 홀짝 배열. 비트 i = 정렬된 i 번째 번호가 홀수(1)인지.
  final Set<int> excludedParityMasks;

  final bool excSameLastDigit3;
  final bool excTripleMultiple;

  // ---- 해외 복권용 추가 ----
  final bool excSumOutside;
  final bool excAllBirthday;
  final bool excAllLowOrHigh;
  final bool excSameDecade4;
  final bool excRepeatLast2;

  // ---- 보조 번호 (사용자가 고르는 복권만) ----
  final bool bonusExcRecent;
  final bool bonusExcConsec;
  final bool bonusExcSameParity;

  const FilterOptions({
    this.include = const {},
    this.exclude = const {},
    this.bonusInclude = const {},
    this.bonusExclude = const {},
    this.excPastFullMatch = false,
    this.excPastMinus1 = false,
    this.excPastMinus2Recent = false,
    this.recentDrawsForMinus2,
    this.excPastConsecTriple = false,
    this.exc3Consec = false,
    this.excSkip1 = false,
    this.excSkip2 = false,
    this.excSkip3 = false,
    this.exc2Pairs = false,
    this.excNarrowRange = false,
    this.narrowRangeMax,
    this.excAllOdd = false,
    this.excAllEven = false,
    this.excludedParityMasks = const {},
    this.excSameLastDigit3 = false,
    this.excTripleMultiple = false,
    this.excSumOutside = false,
    this.excAllBirthday = false,
    this.excAllLowOrHigh = false,
    this.excSameDecade4 = false,
    this.excRepeatLast2 = false,
    this.bonusExcRecent = false,
    this.bonusExcConsec = false,
    this.bonusExcSameParity = false,
  });

  int recentMinus2For(GameConfig game) =>
      recentDrawsForMinus2 ?? (game.main.count <= 5 ? 20 : 100);

  /// 6/45 기준 9 를 번호 범위에 비례시킨 값 (45 → 9, 49 → 10, 50 → 10, 69 → 14, 70 → 14)
  int narrowRangeFor(GameConfig game) =>
      narrowRangeMax ?? (9 * game.main.max / 45).round();
}

/// 번호 합계 허용 범위 (평균 ± 2표준편차, 비복원 추출 기준). 범위 밖이면 제외.
/// 파워볼 89~261, 유로 66~189, 6/49 84~216, 6/45 78~198
({int low, int high}) sumRangeFor(GameConfig game) {
  final k = game.main.count;
  final n = game.main.max;
  final mean = k * (n + 1) / 2;
  final variance = k * (n * n - 1) / 12 * (n - k) / (n - 1);
  final sd = math.sqrt(variance);
  return (low: (mean - 2 * sd).round(), high: (mean + 2 * sd).round());
}

/// 낮은 번호 구간의 끝 (1 ~ 이 값이 "낮은 번호")
int lowHalfMax(GameConfig game) => game.main.max ~/ 2;

/// 보조 번호 "최근 N회" 기준: 1개 복권은 번호 3회, 2개 복권은 같은 쌍 20회
int recentBonusDrawsFor(GameConfig game) => game.bonus.count == 1 ? 3 : 20;

/// 홀짝 배열을 비트마스크로. 예: parityMask([1,0,1,0,1,0]) = 홀짝홀짝홀짝
int parityMask(List<int> oddFlags) {
  int m = 0;
  for (int i = 0; i < oddFlags.length; i++) {
    if (oddFlags[i] == 1) m |= 1 << i;
  }
  return m;
}

/// 기존 앱의 홀짝 패턴 5종 (6개 번호 전용). 각 패턴은 서로 뒤집은 쌍으로 제외됩니다.
const List<List<List<int>>> legacyParityPatterns645 = [
  [
    [1, 0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1],
  ], // excOE1
  [
    [0, 0, 1, 1, 0, 0],
    [1, 1, 0, 0, 1, 1],
  ], // excOE2
  [
    [0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 0],
  ], // excOE3
  [
    [0, 0, 0, 0, 1, 1],
    [1, 1, 1, 1, 0, 0],
  ], // excOE4
  [
    [0, 0, 0, 1, 1, 1],
    [1, 1, 1, 0, 0, 0],
  ], // excOE5
];

/// 기존 앱의 파라미터 맵(calculateLottoCombinations 입력)을 FilterOptions 로 변환
FilterOptions filterOptionsFromLegacy(Map<String, dynamic> p) {
  final masks = <int>{};
  for (int i = 0; i < legacyParityPatterns645.length; i++) {
    if (p['excOE${i + 1}'] == true) {
      for (final pattern in legacyParityPatterns645[i]) {
        masks.add(parityMask(pattern));
      }
    }
  }
  return FilterOptions(
    include: Set<int>.from(p['inc'] as List),
    exclude: Set<int>.from(p['exc'] as List),
    bonusInclude: Set<int>.from(p['bonusInc'] as List? ?? const []),
    bonusExclude: Set<int>.from(p['bonusExc'] as List? ?? const []),
    excPastFullMatch: p['exc1st'] as bool,
    excPastMinus1: p['exc2nd3rd'] as bool,
    excPastMinus2Recent: p['exc4thSeq'] as bool,
    excPastConsecTriple: p['exc5thSeq'] as bool,
    exc3Consec: p['exc3Consec'] as bool,
    excSkip1: p['excSkip1'] as bool,
    excSkip2: p['excSkip2'] as bool,
    excSkip3: p['excSkip3'] as bool,
    exc2Pairs: p['exc2Pairs'] as bool,
    excNarrowRange: p['exc10Range'] as bool,
    excAllOdd: p['excAllOdd'] as bool,
    excAllEven: p['excAllEven'] as bool,
    excludedParityMasks: masks,
    excSameLastDigit3: p['excSameLastDigit3'] as bool,
    excTripleMultiple: p['excTripleMultiple'] as bool,
    excSumOutside: p['excSum'] == true,
    excAllBirthday: p['excBirthday'] == true,
    excAllLowOrHigh: p['excLowHigh'] == true,
    excSameDecade4: p['excDecade4'] == true,
    excRepeatLast2: p['excRepeatLast'] == true,
    bonusExcRecent: p['bonusExcRecent'] == true,
    bonusExcConsec: p['bonusExcConsec'] == true,
    bonusExcSameParity: p['bonusExcParity'] == true,
  );
}
