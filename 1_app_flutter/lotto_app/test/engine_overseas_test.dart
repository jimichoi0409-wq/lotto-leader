// 해외 복권 5종 규칙과 범용 엔진 검증

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/engine/filter_options.dart';
import 'package:lotto_app/games/game_config.dart';

/// 엔진과 독립적으로 작성한 단순 참조 구현 (작은 복권으로 교차 검증용)
bool referencePasses(
  List<int> c,
  FilterOptions f,
  GameConfig g,
  List<List<int>> past,
) {
  final k = c.length;
  final s = c.toSet();
  if (!s.containsAll(f.include) || s.any(f.exclude.contains)) return false;
  bool run(int gap) => [
    for (int i = 0; i + 2 < k; i++)
      c[i + 1] - c[i] == gap && c[i + 2] - c[i + 1] == gap,
  ].any((x) => x);
  if (f.exc3Consec && run(1)) return false;
  if (f.excSkip1 && run(2)) return false;
  if (f.excSkip2 && run(3)) return false;
  if (f.excSkip3 && run(4)) return false;
  final ones = [
    for (int i = 0; i + 1 < k; i++) c[i + 1] - c[i],
  ].where((d) => d == 1).length;
  if (f.exc2Pairs && ones >= 2) return false;
  if (f.excNarrowRange && c.last - c.first <= f.narrowRangeFor(g)) {
    return false;
  }
  final odd = c.where((n) => n.isOdd).length;
  if (f.excAllOdd && odd == k) return false;
  if (f.excAllEven && odd == 0) return false;
  if (f.excludedParityMasks.contains(
    parityMask([for (final n in c) n.isOdd ? 1 : 0]),
  )) {
    return false;
  }
  if (f.excSameLastDigit3) {
    final counts = <int, int>{};
    for (final n in c) {
      counts[n % 10] = (counts[n % 10] ?? 0) + 1;
    }
    if (counts.values.any((v) => v >= 3)) return false;
  }
  if (f.excTripleMultiple) {
    for (int b = 2; b <= g.main.max ~/ 2; b++) {
      for (int m = 1; b * (m + 2) <= g.main.max; m++) {
        if (s.containsAll({b * m, b * (m + 1), b * (m + 2)})) return false;
      }
    }
  }
  for (int i = 0; i < past.length; i++) {
    final hits = past[i].toSet().intersection(s).length;
    if (f.excPastFullMatch && hits == k) return false;
    if (f.excPastMinus1 && hits >= k - 1) return false;
    if (f.excPastMinus2Recent && i < f.recentMinus2For(g) && hits >= k - 2) {
      return false;
    }
  }
  if (f.excPastConsecTriple) {
    for (int i = 0; i + 2 < k; i++) {
      if (c[i + 1] - c[i] == 1 && c[i + 2] - c[i + 1] == 1) {
        final t = {c[i], c[i + 1], c[i + 2]};
        if (past.any((w) => w.toSet().containsAll(t))) return false;
      }
    }
  }
  return true;
}

void main() {
  final games = {
    for (final g in parseGames(
      jsonDecode(File('assets/games/games.json').readAsStringSync()),
    ))
      g.id: g,
  };

  test('복권 6종 정의와 1등 확률', () {
    expect(
      games.keys,
      containsAll([
        'kr645',
        'powerball',
        'megamillions',
        'ca649',
        'euromillions',
        'eurojackpot',
      ]),
    );
    expect(games['kr645']!.jackpotOddsDenominator, 8145060);
    expect(games['powerball']!.jackpotOddsDenominator, 292201338);
    expect(games['megamillions']!.jackpotOddsDenominator, 290472336);
    expect(games['ca649']!.jackpotOddsDenominator, 13983816);
    expect(games['euromillions']!.jackpotOddsDenominator, 139838160);
    expect(games['eurojackpot']!.jackpotOddsDenominator, 139838160);
  });

  test('좁은 구간 기준값이 번호 범위에 비례', () {
    const f = FilterOptions();
    expect(f.narrowRangeFor(games['kr645']!), 9);
    expect(f.narrowRangeFor(games['ca649']!), 10);
    expect(f.narrowRangeFor(games['euromillions']!), 10);
    expect(f.narrowRangeFor(games['powerball']!), 14);
    expect(f.narrowRangeFor(games['megamillions']!), 14);
  });

  for (final id in [
    'powerball',
    'megamillions',
    'ca649',
    'euromillions',
    'eurojackpot',
  ]) {
    test(
      '$id: 필터 없으면 전체 조합 수 = 1등 확률 분모',
      () {
        final g = games[id]!;
        final r = runEngine(
          EngineRequest(
            game: g,
            filters: const FilterOptions(),
            pastWinners: const [],
          ),
        );
        expect(r.mainCount, combinations(g.main.max, g.main.count));
        expect(r.total, g.jackpotOddsDenominator);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  }

  test(
    '보조 번호 포함·제외 개수 (유로밀리언 럭키스타 2/12)',
    () {
      final g = games['euromillions']!;
      int bonus(FilterOptions f) => runEngine(
        EngineRequest(
          game: g,
          filters: f,
          pastWinners: const [],
          mode: EngineMode.count,
        ),
      ).bonusCount;
      expect(bonus(const FilterOptions()), 66);
      expect(bonus(const FilterOptions(bonusExclude: {1, 2})), 45);
      expect(bonus(const FilterOptions(bonusInclude: {5})), 11);
      expect(bonus(const FilterOptions(bonusInclude: {5, 9})), 1);
      expect(
        bonus(const FilterOptions(bonusInclude: {5}, bonusExclude: {5})),
        0,
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('작은 가상 복권(5/24 + 보조 1/6)에서 참조 구현과 결과 일치', () {
    final g = GameConfig.fromJson({
      'id': 'test524',
      'name': {'en': 'Test'},
      'country': 'XX',
      'main': {'count': 5, 'max': 24},
      'bonus': {
        'count': 1,
        'max': 6,
        'playerPicks': true,
        'label': {'en': 'B'},
      },
      'drawDays': ['SAT'],
      'timezone': 'UTC',
      'ruleSince': null,
    });
    final rand = Random(42);
    final past = List.generate(150, (_) {
      final s = <int>{};
      while (s.length < 5) {
        s.add(rand.nextInt(24) + 1);
      }
      return s.toList()..sort();
    });
    final filterSets = <FilterOptions>[
      const FilterOptions(),
      FilterOptions(
        excPastFullMatch: true,
        excPastMinus1: true,
        excPastMinus2Recent: true,
        recentDrawsForMinus2: 30,
        excPastConsecTriple: true,
      ),
      FilterOptions(
        include: const {7},
        exclude: const {1, 24},
        exc3Consec: true,
        excSkip1: true,
        excSkip2: true,
        excSkip3: true,
        exc2Pairs: true,
        excNarrowRange: true,
        excAllOdd: true,
        excAllEven: true,
        excludedParityMasks: {
          parityMask([1, 0, 1, 0, 1]),
          parityMask([0, 0, 0, 1, 1]),
        },
        excSameLastDigit3: true,
        excTripleMultiple: true,
      ),
    ];

    for (final f in filterSets) {
      int expected = 0;
      void walk(List<int> c, int start) {
        if (c.length == 5) {
          if (referencePasses(c, f, g, past)) expected++;
          return;
        }
        for (int n = start; n <= 24; n++) {
          walk([...c, n], n + 1);
        }
      }

      walk([], 1);
      final r = runEngine(
        EngineRequest(game: g, filters: f, pastWinners: past),
      );
      expect(r.mainCount, expected);
      expect(r.total, expected * 6);
    }
  });

  test('번호 추출: 규칙·필터를 지키는 티켓 생성 (파워볼)', () {
    final g = games['powerball']!;
    const f = FilterOptions(
      include: {7},
      exclude: {13, 69},
      bonusExclude: {1, 2, 3},
      exc3Consec: true,
      excNarrowRange: true,
    );
    final r = runEngine(
      EngineRequest(
        game: g,
        filters: f,
        pastWinners: const [],
        mode: EngineMode.extract,
        extractCount: 30,
        seed: 1,
      ),
    );
    expect(r.tickets.length, 30);
    expect(r.bonusCount, 23);
    for (final t in r.tickets) {
      expect(t.main.length, 5);
      expect(t.main.toSet().length, 5);
      expect(t.main, orderedEquals([...t.main]..sort()));
      expect(t.main.every((n) => n >= 1 && n <= 69), isTrue);
      expect(t.main, contains(7));
      expect(t.main.any((n) => n == 13 || n == 69), isFalse);
      expect(referencePasses(t.main, f, g, const []), isTrue);
      expect(t.bonus.length, 1);
      expect(t.bonus.single, inInclusiveRange(4, 26));
    }
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('유로잭팟 추출: 보조 번호 2개는 서로 다르고 오름차순', () {
    final r = runEngine(
      EngineRequest(
        game: games['eurojackpot']!,
        filters: const FilterOptions(bonusInclude: {12}),
        pastWinners: const [],
        mode: EngineMode.extract,
        extractCount: 10,
        seed: 2,
      ),
    );
    for (final t in r.tickets) {
      expect(t.bonus.length, 2);
      expect(t.bonus.toSet().length, 2);
      expect(t.bonus, contains(12));
      expect(t.bonus.first < t.bonus.last, isTrue);
    }
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('화면 입력(보조 번호 포함·제외)이 엔진 필터로 전달됨', () {
    final f = filterOptionsFromLegacy({
      'inc': <int>[],
      'exc': <int>[],
      'bonusInc': [7],
      'bonusExc': [1, 2, 3],
      for (final k in [
        'exc1st',
        'exc2nd3rd',
        'exc4thSeq',
        'exc5thSeq',
        'exc3Consec',
        'excSkip1',
        'excSkip2',
        'excSkip3',
        'exc2Pairs',
        'exc10Range',
        'excAllOdd',
        'excAllEven',
        'excOE1',
        'excOE2',
        'excOE3',
        'excOE4',
        'excOE5',
        'excSameLastDigit3',
        'excTripleMultiple',
      ])
        k: false,
    });
    expect(f.bonusInclude, {7});
    expect(f.bonusExclude, {1, 2, 3});

    final r = runEngine(
      EngineRequest(
        game: games['powerball']!,
        filters: f,
        pastWinners: const [],
        mode: EngineMode.extract,
        extractCount: 5,
        seed: 3,
      ),
    );
    expect(r.bonusCount, 1, reason: '파워볼 1개를 7로 고정');
    expect(r.tickets.every((t) => t.bonus.single == 7), isTrue);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
