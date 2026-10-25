// 해외 복권용 추가 필터 검증: 단순 참조 구현과 엔진 결과 비교

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/engine/filter_options.dart';
import 'package:lotto_app/games/game_config.dart';

GameConfig virtualGame({int bonusCount = 2, int bonusMax = 8}) =>
    GameConfig.fromJson({
      'id': 'test535',
      'name': {'en': 'Test'},
      'country': 'XX',
      'main': {'count': 5, 'max': 35},
      'bonus': {
        'count': bonusCount,
        'max': bonusMax,
        'playerPicks': true,
        'label': {'en': 'Star'},
      },
      'drawDays': ['SAT'],
      'timezone': 'UTC',
      'ruleSince': null,
    });

bool refMain(List<int> c, FilterOptions f, GameConfig g, List<List<int>> past) {
  final sum = c.reduce((a, b) => a + b);
  final r = sumRangeFor(g);
  if (f.excSumOutside && (sum < r.low || sum > r.high)) return false;
  if (f.excAllBirthday && c.every((n) => n <= 31)) return false;
  final low = lowHalfMax(g);
  if (f.excAllLowOrHigh &&
      (c.every((n) => n <= low) || c.every((n) => n > low))) {
    return false;
  }
  if (f.excSameDecade4) {
    final cnt = <int, int>{};
    for (final n in c) {
      cnt[n ~/ 10] = (cnt[n ~/ 10] ?? 0) + 1;
    }
    if (cnt.values.any((v) => v >= 4)) return false;
  }
  if (f.excRepeatLast2 &&
      past.isNotEmpty &&
      c.where(past.first.contains).length >= 2) {
    return false;
  }
  return true;
}

bool refBonus(List<int> b, FilterOptions f, GameConfig g, List<List<int>> pb) {
  if (b.any(f.bonusExclude.contains)) return false;
  if (!f.bonusInclude.every(b.contains)) return false;
  if (f.bonusExcRecent) {
    final recent = pb.take(recentBonusDrawsFor(g));
    if (g.bonus.count == 1) {
      if (recent.any((r) => r.contains(b.first))) return false;
    } else if (recent.any((r) => r.join(',') == b.join(','))) {
      return false;
    }
  }
  if (b.length >= 2 && f.bonusExcConsec) {
    for (int i = 0; i + 1 < b.length; i++) {
      if (b[i + 1] - b[i] == 1) return false;
    }
  }
  if (b.length >= 2 && f.bonusExcSameParity) {
    final odd = b.where((n) => n.isOdd).length;
    if (odd == 0 || odd == b.length) return false;
  }
  return true;
}

List<List<int>> allCombos(int max, int k) {
  final out = <List<int>>[];
  void walk(List<int> c, int start) {
    if (c.length == k) {
      out.add(c);
      return;
    }
    for (int n = start; n <= max; n++) {
      walk([...c, n], n + 1);
    }
  }

  walk([], 1);
  return out;
}

List<List<int>> randomDraws(Random rand, int count, int k, int max) =>
    List.generate(count, (_) {
      final s = <int>{};
      while (s.length < k) {
        s.add(rand.nextInt(max) + 1);
      }
      return s.toList()..sort();
    });

void main() {
  final games = {
    for (final g in parseGames(
      jsonDecode(File('assets/games/games.json').readAsStringSync()),
    ))
      g.id: g,
  };

  test('합계 범위 기준값', () {
    final pb = sumRangeFor(games['powerball']!);
    expect([pb.low, pb.high], [89, 261]);
    final em = sumRangeFor(games['euromillions']!);
    expect([em.low, em.high], [66, 189]);
    final ca = sumRangeFor(games['ca649']!);
    expect([ca.low, ca.high], [84, 216]);
  });

  test('번호 5개 복권은 "과거 3개 일치" 기준이 최근 20회, 6개 복권은 100회', () {
    const f = FilterOptions();
    expect(f.recentMinus2For(games['euromillions']!), 20);
    expect(f.recentMinus2For(games['powerball']!), 20);
    expect(f.recentMinus2For(games['kr645']!), 100);
    expect(f.recentMinus2For(games['ca649']!), 100);
    expect(
      const FilterOptions(
        recentDrawsForMinus2: 30,
      ).recentMinus2For(games['powerball']!),
      30,
    );
  });

  test('메인 번호 추가 필터: 참조 구현과 결과 일치 (5/35 가상 복권)', () {
    final g = virtualGame();
    final past = randomDraws(Random(7), 40, 5, 35);
    final sets = [
      const FilterOptions(excSumOutside: true),
      const FilterOptions(excAllBirthday: true),
      const FilterOptions(excAllLowOrHigh: true),
      const FilterOptions(excSameDecade4: true),
      const FilterOptions(excRepeatLast2: true),
      const FilterOptions(
        excSumOutside: true,
        excAllBirthday: true,
        excAllLowOrHigh: true,
        excSameDecade4: true,
        excRepeatLast2: true,
      ),
    ];
    final mains = allCombos(35, 5);
    for (final f in sets) {
      final expected = mains.where((c) => refMain(c, f, g, past)).length;
      final r = runEngine(
        EngineRequest(game: g, filters: f, pastWinners: past),
      );
      expect(r.mainCount, expected);
      expect(expected, lessThan(mains.length), reason: '필터가 실제로 걸러야 함');
    }
  });

  test('보조 번호 필터: 개수와 추출 결과가 참조 구현과 일치', () {
    for (final g in [virtualGame(), virtualGame(bonusCount: 1, bonusMax: 10)]) {
      final pb = randomDraws(Random(3), 30, g.bonus.count, g.bonus.max);
      final sets = [
        const FilterOptions(bonusExcRecent: true),
        const FilterOptions(bonusExcConsec: true),
        const FilterOptions(bonusExcSameParity: true),
        const FilterOptions(
          bonusExcRecent: true,
          bonusExcConsec: true,
          bonusExcSameParity: true,
          bonusExclude: {8},
        ),
      ];
      final bonuses = allCombos(g.bonus.max, g.bonus.count);
      for (final f in sets) {
        final allowed = bonuses.where((b) => refBonus(b, f, g, pb)).toList();
        final r = runEngine(
          EngineRequest(
            game: g,
            filters: f,
            pastWinners: const [],
            pastBonus: pb,
            mode: EngineMode.extract,
            extractCount: 30,
            seed: 1,
          ),
        );
        expect(r.bonusCount, allowed.length, reason: '${g.bonus.count}개');
        final ok = {for (final b in allowed) b.join(',')};
        for (final t in r.tickets) {
          expect(ok, contains(t.bonus.join(',')));
        }
      }
    }
  });

  test('필터를 켜지 않으면 기존 결과와 동일 (파워볼 보조 번호 26개)', () {
    final r = runEngine(
      EngineRequest(
        game: games['powerball']!,
        filters: const FilterOptions(include: {1, 2, 3}),
        pastWinners: const [],
      ),
    );
    expect(r.bonusCount, 26);
    expect(r.mainCount, 66 * 65 ~/ 2);
  });
}
