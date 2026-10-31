// =========================================================================
// 범용 로또 조합 계산 엔진
//
// 복권 규칙(GameConfig)과 필터(FilterOptions)를 받아
//   mode = count   : 조건을 통과한 메인 번호 조합 수를 셉니다.
//   mode = extract : 통과한 조합 중 요청한 개수를 고르게 무작위 추출합니다.
//
// 메인 번호 조합을 모두 훑어 보는 방식이라 결과가 정확합니다.
// 6/45 는 814만, 파워볼 1,124만, 메가밀리언 1,210만 개로 isolate 에서 처리 가능한 규모입니다.
// compute() 로 isolate 에서 실행할 수 있게 최상위 함수 runEngine 을 제공합니다.
// =========================================================================

import 'dart:math';
import 'dart:typed_data';

import '../games/game_config.dart';
import 'filter_options.dart';

enum EngineMode { count, extract }

class EngineRequest {
  final GameConfig game;
  final FilterOptions filters;

  /// 과거 당첨 메인 번호 (오름차순 정렬). 최신 회차가 앞에 와야 합니다(최근 N회 필터용).
  final List<List<int>> pastWinners;

  /// 과거 보조 번호 (오름차순, 최신 회차가 앞). 보조 번호 "최근 N회" 필터용
  final List<List<int>> pastBonus;
  final EngineMode mode;
  final int extractCount;

  /// 테스트에서 결과를 고정할 때만 지정
  final int? seed;

  const EngineRequest({
    required this.game,
    required this.filters,
    required this.pastWinners,
    this.pastBonus = const [],
    this.mode = EngineMode.count,
    this.extractCount = 0,
    this.seed,
  });
}

class Ticket {
  final List<int> main;
  final List<int> bonus;

  const Ticket(this.main, this.bonus);

  @override
  String toString() => bonus.isEmpty
      ? main.join(', ')
      : '${main.join(', ')} + ${bonus.join(', ')}';
}

class EngineResult {
  /// 필터를 통과한 메인 번호 조합 수
  final int mainCount;

  /// 고를 수 있는 보조 번호 조합 수 (보조 번호를 고르지 않는 복권은 1)
  final int bonusCount;
  final List<Ticket> tickets;

  const EngineResult(this.mainCount, this.bonusCount, this.tickets);

  /// 남은 전체 조합 수 = 메인 × 보조
  int get total => mainCount * bonusCount;
}

/// 메인 조합을 전부 훑는 최대 규모. 이를 넘는 복권(예: 6/90)은 표본 추정 모드가 필요합니다.
const int maxEnumeratedCombinations = 20000000;

/// 번호 하나당 7비트(최대 127)로 묶어 Set 키로 씁니다.
const int _bits = 7;

EngineResult runEngine(EngineRequest req) {
  final game = req.game;
  final f = req.filters;
  final k = game.main.count;
  final maxN = game.main.max;

  final allowed = <int>[
    for (int n = 1; n <= maxN; n++)
      if (!f.exclude.contains(n)) n,
  ];
  final m = allowed.length;

  final bonusOptions = _bonusOptions(game, f, req.pastBonus);
  final bonusCount = game.hasPlayerBonus ? bonusOptions.length : 1;
  if (m < k ||
      bonusCount == 0 ||
      f.include.difference(allowed.toSet()).isNotEmpty) {
    return EngineResult(0, bonusCount, const []);
  }
  if (combinations(m, k) > maxEnumeratedCombinations) {
    throw UnsupportedError(
      '${game.id}: 조합 수가 너무 많아 전수 계산을 할 수 없습니다 (표본 추정 모드 필요).',
    );
  }

  // ---- 과거 당첨번호 키 집합 ----
  final full = <int>{};
  final minus1 = <int>{};
  final minus2 = <int>{};
  final consecTriples = <int>{};
  for (int i = 0; i < req.pastWinners.length; i++) {
    final w = req.pastWinners[i];
    if (w.length != k) continue;
    if (f.excPastFullMatch) full.add(_encSkip(w, -1, -1));
    if (f.excPastMinus1) {
      for (int a = 0; a < k; a++) {
        minus1.add(_encSkip(w, a, -1));
      }
    }
    if (f.excPastMinus2Recent && i < f.recentMinus2For(game)) {
      for (int a = 0; a < k; a++) {
        for (int b = a + 1; b < k; b++) {
          minus2.add(_encSkip(w, a, b));
        }
      }
    }
    if (f.excPastConsecTriple) {
      for (int a = 0; a + 2 < k; a++) {
        consecTriples.add(_enc3(w[a], w[a + 1], w[a + 2]));
      }
    }
  }

  // ---- 3연속 배수 (예: 3·6·9) 목록: 가장 작은 수 → (가운데, 가장 큰 수) ----
  final triplesBySmallest = List<List<int>>.generate(maxN + 1, (_) => <int>[]);
  if (f.excTripleMultiple) {
    for (int base = 2; base <= maxN ~/ 2; base++) {
      final maxMultiplier = maxN ~/ base;
      for (int mul = 1; mul <= maxMultiplier - 2; mul++) {
        triplesBySmallest[base * mul]
          ..add(base * (mul + 1))
          ..add(base * (mul + 2));
      }
    }
  }

  final narrowMax = f.narrowRangeFor(game);
  final sumRange = sumRangeFor(game);
  final lowMax = lowHalfMax(game);
  final lastDraw = Uint8List(maxN + 1);
  if (f.excRepeatLast2 && req.pastWinners.isNotEmpty) {
    final w = req.pastWinners.first;
    if (w.length == k) {
      for (final n in w) {
        if (n >= 1 && n <= maxN) lastDraw[n] = 1;
      }
    }
  }
  final decade = Int8List(maxN ~/ 10 + 1);
  final includeList = f.include.toList();
  final allOddMask = (1 << k) - 1;

  final c = Int32List(k);
  final present = Uint8List(maxN + 1);
  final lastDigit = Int8List(10);

  bool passes() {
    for (final v in includeList) {
      bool found = false;
      for (int i = 0; i < k; i++) {
        if (c[i] == v) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }

    int ones = 0;
    for (int i = 0; i + 1 < k; i++) {
      final d1 = c[i + 1] - c[i];
      if (d1 == 1) ones++;
      if (i + 2 < k) {
        final d2 = c[i + 2] - c[i + 1];
        if (d1 == d2) {
          if (f.exc3Consec && d1 == 1) return false;
          if (f.excSkip1 && d1 == 2) return false;
          if (f.excSkip2 && d1 == 3) return false;
          if (f.excSkip3 && d1 == 4) return false;
        }
      }
    }
    if (f.exc2Pairs && ones >= 2) return false;
    if (f.excDouble3Consec &&
        k == 6 &&
        c[1] - c[0] == 1 &&
        c[2] - c[1] == 1 &&
        c[4] - c[3] == 1 &&
        c[5] - c[4] == 1) {
      return false;
    }

    if (f.excNarrowRange && c[k - 1] - c[0] <= narrowMax) return false;

    int mask = 0;
    for (int i = 0; i < k; i++) {
      if (c[i].isOdd) mask |= 1 << i;
    }
    if (f.excAllOdd && mask == allOddMask) return false;
    if (f.excAllEven && mask == 0) return false;
    if (f.excludedParityMasks.contains(mask)) return false;

    if (f.excSameLastDigit3) {
      lastDigit.fillRange(0, 10, 0);
      for (int i = 0; i < k; i++) {
        if (++lastDigit[c[i] % 10] >= 3) return false;
      }
    }

    if (f.excTripleMultiple) {
      for (int i = 0; i < k; i++) {
        present[c[i]] = 1;
      }
      bool hit = false;
      for (int i = 0; i < k && !hit; i++) {
        final t = triplesBySmallest[c[i]];
        for (int j = 0; j < t.length; j += 2) {
          if (present[t[j]] == 1 && present[t[j + 1]] == 1) {
            hit = true;
            break;
          }
        }
      }
      for (int i = 0; i < k; i++) {
        present[c[i]] = 0;
      }
      if (hit) return false;
    }

    if (f.excSumOutside) {
      int sum = 0;
      for (int i = 0; i < k; i++) {
        sum += c[i];
      }
      if (sum < sumRange.low || sum > sumRange.high) return false;
    }
    if (f.excAllBirthday && c[k - 1] <= 31) return false;
    if (f.excAllLowOrHigh && (c[k - 1] <= lowMax || c[0] > lowMax)) {
      return false;
    }
    if (f.excSameDecade4) {
      decade.fillRange(0, decade.length, 0);
      for (int i = 0; i < k; i++) {
        if (++decade[c[i] ~/ 10] >= 4) return false;
      }
    }
    if (f.excRepeatLast2) {
      int again = 0;
      for (int i = 0; i < k; i++) {
        again += lastDraw[c[i]];
      }
      if (again >= 2) return false;
    }

    if (f.excPastFullMatch && full.contains(_encSkip(c, -1, -1))) return false;

    if (f.excPastMinus1) {
      for (int a = 0; a < k; a++) {
        if (minus1.contains(_encSkip(c, a, -1))) return false;
      }
    }

    if (f.excPastMinus2Recent && minus2.isNotEmpty) {
      for (int a = 0; a < k; a++) {
        for (int b = a + 1; b < k; b++) {
          if (minus2.contains(_encSkip(c, a, b))) return false;
        }
      }
    }

    if (f.excPastConsecTriple) {
      for (int i = 0; i + 2 < k; i++) {
        if (c[i + 1] - c[i] == 1 &&
            c[i + 2] - c[i + 1] == 1 &&
            consecTriples.contains(_enc3(c[i], c[i + 1], c[i + 2]))) {
          return false;
        }
      }
    }

    return true;
  }

  // ---- 메인 조합 전수 탐색 + 저수지 표본 추출 ----
  final rand = req.seed == null ? Random() : Random(req.seed);
  final extract = req.mode == EngineMode.extract && req.extractCount > 0;
  final picked = <List<int>>[];
  int count = 0;

  final idx = List<int>.generate(k, (i) => i);
  while (true) {
    for (int i = 0; i < k; i++) {
      c[i] = allowed[idx[i]];
    }

    if (passes()) {
      count++;
      if (extract) {
        if (picked.length < req.extractCount) {
          picked.add(List<int>.of(c));
        } else {
          final r = rand.nextInt(count);
          if (r < req.extractCount) picked[r] = List<int>.of(c);
        }
      }
    }

    int i = k - 1;
    while (i >= 0 && idx[i] == m - k + i) {
      i--;
    }
    if (i < 0) break;
    idx[i]++;
    for (int j = i + 1; j < k; j++) {
      idx[j] = idx[j - 1] + 1;
    }
  }

  picked.shuffle(rand);
  final tickets = [
    for (final main in picked)
      Ticket(
        main,
        game.hasPlayerBonus
            ? bonusOptions[rand.nextInt(bonusOptions.length)]
            : const [],
      ),
  ];
  return EngineResult(count, bonusCount, tickets);
}

/// 사용자가 고를 수 있는 보조 번호 조합 목록 (보조 번호가 없는 복권은 빈 목록).
/// 보조 번호 풀이 작아(최대 C(12,2)=66, 26) 전부 나열해 필터를 적용합니다.
List<List<int>> _bonusOptions(
  GameConfig game,
  FilterOptions f,
  List<List<int>> pastBonus,
) {
  if (!game.hasPlayerBonus) return const [];
  final k = game.bonus.count;
  final pool = <int>[
    for (int n = 1; n <= game.bonus.max; n++)
      if (!f.bonusExclude.contains(n)) n,
  ];

  // 최근 N회 기준: 1개 복권은 번호 자체, 2개 이상은 같은 조합
  final recentNumbers = <int>{};
  final recentSets = <String>{};
  if (f.bonusExcRecent) {
    final n = recentBonusDrawsFor(game);
    for (final b in pastBonus.take(n)) {
      if (b.length != k) continue;
      if (k == 1) {
        recentNumbers.add(b.first);
      } else {
        recentSets.add(([...b]..sort()).join(','));
      }
    }
  }

  final out = <List<int>>[];
  final idx = List<int>.generate(k, (i) => i);
  if (pool.length < k) return out;
  while (true) {
    final c = [for (final i in idx) pool[i]];
    bool ok = f.bonusInclude.every(c.contains);
    if (ok && f.bonusExcRecent) {
      if (k == 1) {
        ok = !recentNumbers.contains(c.first);
      } else {
        ok = !recentSets.contains(c.join(','));
      }
    }
    if (ok && k >= 2 && f.bonusExcConsec) {
      for (int i = 0; i + 1 < k; i++) {
        if (c[i + 1] - c[i] == 1) ok = false;
      }
    }
    if (ok && k >= 2 && f.bonusExcSameParity) {
      final odd = c.where((n) => n.isOdd).length;
      if (odd == 0 || odd == k) ok = false;
    }
    if (ok) out.add(c);

    int i = k - 1;
    while (i >= 0 && idx[i] == pool.length - k + i) {
      i--;
    }
    if (i < 0) break;
    idx[i]++;
    for (int j = i + 1; j < k; j++) {
      idx[j] = idx[j - 1] + 1;
    }
  }
  return out;
}

int _encSkip(List<int> nums, int skipA, int skipB) {
  int key = 0;
  for (int i = 0; i < nums.length; i++) {
    if (i == skipA || i == skipB) continue;
    key = (key << _bits) | nums[i];
  }
  return key;
}

int _enc3(int a, int b, int c) => (((a << _bits) | b) << _bits) | c;
