// 기존 앱(6/45 전용)의 조합 계산 엔진 원본. 앱에서는 lib/engine/combination_engine.dart 로 대체했고,
// 새 엔진이 같은 결과를 내는지 비교하는 기준(회귀 테스트)으로만 보관합니다. 수정하지 마세요.

import 'dart:math';

// =========================================================================
// 814만 개 로또 조합 계산 엔진
//
// mode = count
//   조건 적용 후 남은 조합 수만 계산합니다.
//
// mode = extract
//   조건 적용 후 남은 전체 조합 안에서 사용자가 입력한 개수만큼 직접 추출합니다.
// =========================================================================
Map<String, dynamic> calculateLottoCombinations(Map<String, dynamic> p) {
  final List<List<int>> pastWinners = (p['pastWinners'] as List)
      .map((e) => List<int>.from(e))
      .toList();

  final Set<int> incSet = Set<int>.from(p['inc'] as List);
  final Set<int> excSet = Set<int>.from(p['exc'] as List);

  final String mode = p['mode'] as String? ?? 'count';
  final int targetExtractCount = p['targetExtractCount'] as int? ?? 0;

  final bool exc1st = p['exc1st'] as bool;
  final bool exc2nd3rd = p['exc2nd3rd'] as bool;
  final bool exc4thSeq = p['exc4thSeq'] as bool;
  final bool exc5thSeq = p['exc5thSeq'] as bool;
  final bool exc3Consec = p['exc3Consec'] as bool;
  final bool excSkip1 = p['excSkip1'] as bool;
  final bool excSkip2 = p['excSkip2'] as bool;
  final bool excSkip3 = p['excSkip3'] as bool;
  final bool exc2Pairs = p['exc2Pairs'] as bool;
  final bool exc10Range = p['exc10Range'] as bool;
  final bool excAllOdd = p['excAllOdd'] as bool;
  final bool excAllEven = p['excAllEven'] as bool;
  final bool excOE1 = p['excOE1'] as bool;
  final bool excOE2 = p['excOE2'] as bool;
  final bool excOE3 = p['excOE3'] as bool;
  final bool excOE4 = p['excOE4'] as bool;
  final bool excOE5 = p['excOE5'] as bool;
  final bool excSameLastDigit3 = p['excSameLastDigit3'] as bool;
  final bool excTripleMultiple = p['excTripleMultiple'] as bool;

  final Set<int> w6 = <int>{};
  final Set<int> w5 = <int>{};
  final Set<int> w4 = <int>{};
  final Set<int> w3c = <int>{};

  int enc6(int a, int b, int c, int d, int e, int f) =>
      a | (b << 6) | (c << 12) | (d << 18) | (e << 24) | (f << 30);

  int enc5(int a, int b, int c, int d, int e) =>
      a | (b << 6) | (c << 12) | (d << 18) | (e << 24);

  int enc4(int a, int b, int c, int d) => a | (b << 6) | (c << 12) | (d << 18);

  int enc3(int a, int b, int c) => a | (b << 6) | (c << 12);

  for (int i = 0; i < pastWinners.length; i++) {
    final w = pastWinners[i];
    if (w.length < 6) continue;

    if (exc1st) {
      w6.add(enc6(w[0], w[1], w[2], w[3], w[4], w[5]));
    }

    if (exc2nd3rd) {
      w5.add(enc5(w[1], w[2], w[3], w[4], w[5]));
      w5.add(enc5(w[0], w[2], w[3], w[4], w[5]));
      w5.add(enc5(w[0], w[1], w[3], w[4], w[5]));
      w5.add(enc5(w[0], w[1], w[2], w[4], w[5]));
      w5.add(enc5(w[0], w[1], w[2], w[3], w[5]));
      w5.add(enc5(w[0], w[1], w[2], w[3], w[4]));
    }

    if (exc4thSeq && i < 100) {
      for (int a = 0; a < 3; a++) {
        for (int b = a + 1; b < 4; b++) {
          for (int c = b + 1; c < 5; c++) {
            for (int d = c + 1; d < 6; d++) {
              w4.add(enc4(w[a], w[b], w[c], w[d]));
            }
          }
        }
      }
    }

    if (exc5thSeq) {
      w3c.add(enc3(w[0], w[1], w[2]));
      w3c.add(enc3(w[1], w[2], w[3]));
      w3c.add(enc3(w[2], w[3], w[4]));
      w3c.add(enc3(w[3], w[4], w[5]));
    }
  }

  bool includeNumbersPass(int n1, int n2, int n3, int n4, int n5, int n6) {
    if (incSet.isEmpty) return true;

    for (final v in incSet) {
      if (v != n1 && v != n2 && v != n3 && v != n4 && v != n5 && v != n6) {
        return false;
      }
    }

    return true;
  }

  bool hasSameLastDigit3(List<int> nums) {
    final counts = List<int>.filled(10, 0);
    for (final n in nums) {
      counts[n % 10]++;
    }
    return counts.any((v) => v >= 3);
  }

  bool hasTripleMultiplePattern(Set<int> nums) {
    for (int base = 2; base <= 22; base++) {
      final maxMultiplier = 45 ~/ base;
      for (int m = 1; m <= maxMultiplier - 2; m++) {
        if (nums.contains(base * m) &&
            nums.contains(base * (m + 1)) &&
            nums.contains(base * (m + 2))) {
          return true;
        }
      }
    }
    return false;
  }

  int count = 0;
  final int safeExtractCount = targetExtractCount < 0 ? 0 : targetExtractCount;
  final List<List<int>> results = <List<int>>[];
  final Random rand = Random();

  for (int n1 = 1; n1 <= 40; n1++) {
    if (excSet.contains(n1)) continue;

    for (int n2 = n1 + 1; n2 <= 41; n2++) {
      if (excSet.contains(n2)) continue;

      for (int n3 = n2 + 1; n3 <= 42; n3++) {
        if (excSet.contains(n3)) continue;

        for (int n4 = n3 + 1; n4 <= 43; n4++) {
          if (excSet.contains(n4)) continue;

          for (int n5 = n4 + 1; n5 <= 44; n5++) {
            if (excSet.contains(n5)) continue;

            for (int n6 = n5 + 1; n6 <= 45; n6++) {
              if (excSet.contains(n6)) continue;

              if (!includeNumbersPass(n1, n2, n3, n4, n5, n6)) {
                continue;
              }

              if (exc3Consec &&
                  ((n2 - n1 == 1 && n3 - n2 == 1) ||
                      (n3 - n2 == 1 && n4 - n3 == 1) ||
                      (n4 - n3 == 1 && n5 - n4 == 1) ||
                      (n5 - n4 == 1 && n6 - n5 == 1))) {
                continue;
              }

              if (excSkip1 &&
                  ((n2 - n1 == 2 && n3 - n2 == 2) ||
                      (n3 - n2 == 2 && n4 - n3 == 2) ||
                      (n4 - n3 == 2 && n5 - n4 == 2) ||
                      (n5 - n4 == 2 && n6 - n5 == 2))) {
                continue;
              }

              if (excSkip2 &&
                  ((n2 - n1 == 3 && n3 - n2 == 3) ||
                      (n3 - n2 == 3 && n4 - n3 == 3) ||
                      (n4 - n3 == 3 && n5 - n4 == 3) ||
                      (n5 - n4 == 3 && n6 - n5 == 3))) {
                continue;
              }

              if (excSkip3 &&
                  ((n2 - n1 == 4 && n3 - n2 == 4) ||
                      (n3 - n2 == 4 && n4 - n3 == 4) ||
                      (n4 - n3 == 4 && n5 - n4 == 4) ||
                      (n5 - n4 == 4 && n6 - n5 == 4))) {
                continue;
              }

              if (exc2Pairs) {
                int pairCount = 0;
                if (n2 - n1 == 1) pairCount++;
                if (n3 - n2 == 1) pairCount++;
                if (n4 - n3 == 1) pairCount++;
                if (n5 - n4 == 1) pairCount++;
                if (n6 - n5 == 1) pairCount++;
                if (pairCount >= 2) continue;
              }

              if (exc10Range && (n6 - n1) <= 9) {
                continue;
              }

              final int o1 = n1 % 2;
              final int o2 = n2 % 2;
              final int o3 = n3 % 2;
              final int o4 = n4 % 2;
              final int o5 = n5 % 2;
              final int o6 = n6 % 2;
              final int odd = o1 + o2 + o3 + o4 + o5 + o6;

              if (excAllOdd && odd == 6) continue;
              if (excAllEven && odd == 0) continue;

              if (excOE1 &&
                  ((o1 == 1 &&
                          o2 == 0 &&
                          o3 == 1 &&
                          o4 == 0 &&
                          o5 == 1 &&
                          o6 == 0) ||
                      (o1 == 0 &&
                          o2 == 1 &&
                          o3 == 0 &&
                          o4 == 1 &&
                          o5 == 0 &&
                          o6 == 1))) {
                continue;
              }

              if (excOE2 &&
                  ((o1 == 0 &&
                          o2 == 0 &&
                          o3 == 1 &&
                          o4 == 1 &&
                          o5 == 0 &&
                          o6 == 0) ||
                      (o1 == 1 &&
                          o2 == 1 &&
                          o3 == 0 &&
                          o4 == 0 &&
                          o5 == 1 &&
                          o6 == 1))) {
                continue;
              }

              if (excOE3 &&
                  ((o1 == 0 &&
                          o2 == 0 &&
                          o3 == 0 &&
                          o4 == 0 &&
                          o5 == 0 &&
                          o6 == 1) ||
                      (o1 == 1 &&
                          o2 == 1 &&
                          o3 == 1 &&
                          o4 == 1 &&
                          o5 == 1 &&
                          o6 == 0))) {
                continue;
              }

              if (excOE4 &&
                  ((o1 == 0 &&
                          o2 == 0 &&
                          o3 == 0 &&
                          o4 == 0 &&
                          o5 == 1 &&
                          o6 == 1) ||
                      (o1 == 1 &&
                          o2 == 1 &&
                          o3 == 1 &&
                          o4 == 1 &&
                          o5 == 0 &&
                          o6 == 0))) {
                continue;
              }

              if (excOE5 &&
                  ((o1 == 0 &&
                          o2 == 0 &&
                          o3 == 0 &&
                          o4 == 1 &&
                          o5 == 1 &&
                          o6 == 1) ||
                      (o1 == 1 &&
                          o2 == 1 &&
                          o3 == 1 &&
                          o4 == 0 &&
                          o5 == 0 &&
                          o6 == 0))) {
                continue;
              }

              final candidate = <int>[n1, n2, n3, n4, n5, n6];

              if (excSameLastDigit3 && hasSameLastDigit3(candidate)) {
                continue;
              }

              if (excTripleMultiple &&
                  hasTripleMultiplePattern(candidate.toSet())) {
                continue;
              }

              if (exc1st && w6.contains(enc6(n1, n2, n3, n4, n5, n6))) {
                continue;
              }

              if (exc2nd3rd &&
                  (w5.contains(enc5(n1, n2, n3, n4, n5)) ||
                      w5.contains(enc5(n1, n2, n3, n4, n6)) ||
                      w5.contains(enc5(n1, n2, n3, n5, n6)) ||
                      w5.contains(enc5(n1, n2, n4, n5, n6)) ||
                      w5.contains(enc5(n1, n3, n4, n5, n6)) ||
                      w5.contains(enc5(n2, n3, n4, n5, n6)))) {
                continue;
              }

              if (exc4thSeq &&
                  w4.isNotEmpty &&
                  (w4.contains(enc4(n1, n2, n3, n4)) ||
                      w4.contains(enc4(n1, n2, n3, n5)) ||
                      w4.contains(enc4(n1, n2, n3, n6)) ||
                      w4.contains(enc4(n1, n2, n4, n5)) ||
                      w4.contains(enc4(n1, n2, n4, n6)) ||
                      w4.contains(enc4(n1, n2, n5, n6)) ||
                      w4.contains(enc4(n1, n3, n4, n5)) ||
                      w4.contains(enc4(n1, n3, n4, n6)) ||
                      w4.contains(enc4(n1, n3, n5, n6)) ||
                      w4.contains(enc4(n1, n4, n5, n6)) ||
                      w4.contains(enc4(n2, n3, n4, n5)) ||
                      w4.contains(enc4(n2, n3, n4, n6)) ||
                      w4.contains(enc4(n2, n3, n5, n6)) ||
                      w4.contains(enc4(n2, n4, n5, n6)) ||
                      w4.contains(enc4(n3, n4, n5, n6)))) {
                continue;
              }

              if (exc5thSeq &&
                  ((n2 - n1 == 1 &&
                          n3 - n2 == 1 &&
                          w3c.contains(enc3(n1, n2, n3))) ||
                      (n3 - n2 == 1 &&
                          n4 - n3 == 1 &&
                          w3c.contains(enc3(n2, n3, n4))) ||
                      (n4 - n3 == 1 &&
                          n5 - n4 == 1 &&
                          w3c.contains(enc3(n3, n4, n5))) ||
                      (n5 - n4 == 1 &&
                          n6 - n5 == 1 &&
                          w3c.contains(enc3(n4, n5, n6))))) {
                continue;
              }

              count++;

              if (mode == 'extract' && safeExtractCount > 0) {
                if (results.length < safeExtractCount) {
                  results.add(candidate);
                } else {
                  final int r = rand.nextInt(count);
                  if (r < safeExtractCount) {
                    results[r] = candidate;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  if (mode == 'extract') {
    results.shuffle(rand);
  }

  return {'count': count, 'results': results};
}
