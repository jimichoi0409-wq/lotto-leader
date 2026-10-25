import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/filter_store.dart';
import 'package:lotto_app/data/number_stats.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('번호 통계', () {
    // 최신순
    const draws = [
      DrawRecord(3, '2026-01-17', [1, 2, 3], [1]),
      DrawRecord(2, '2026-01-10', [1, 4, 5], [2]),
      DrawRecord(1, '2026-01-03', [1, 2, 6], [2]),
    ];

    test('출현 횟수와 마지막 출현 후 지난 회차', () {
      final s = numberStats(draws, max: 7);
      expect(s.length, 7);
      expect(s[0].count, 3); // 1
      expect(s[0].gap, 0);
      expect(s[1].count, 2); // 2
      expect(s[3].gap, 1); // 4 → 1회 전
      expect(s[5].gap, 2); // 6 → 2회 전
      expect(s[6].count, 0); // 7 → 안 나옴
      expect(s[6].gap, isNull);
    });

    test('최근 N회만', () {
      final s = numberStats(draws, max: 7, window: 1);
      expect([for (final x in s) x.count], [1, 1, 1, 0, 0, 0, 0]);
      // 기간보다 많이 요청하면 전체
      expect(numberStats(draws, max: 7, window: 99)[0].count, 3);
    });

    test('보조 번호', () {
      final s = numberStats(draws, max: 3, bonus: true);
      expect([for (final x in s) x.count], [1, 2, 0]);
    });

    test('정렬', () {
      final s = numberStats(draws, max: 7);
      expect(sortStats(s, StatsSort.most).first.number, 1);
      expect(sortStats(s, StatsSort.least).first.number, 7);
      // 안 나온 번호(7) → 가장 오래된 6 순
      expect(sortStats(s, StatsSort.gap).take(2).map((x) => x.number), [7, 6]);
      expect(sortStats(s, StatsSort.number).first.number, 1);
    });

    test('홀수 개수 분포', () {
      expect(oddCountDistribution(draws), {2: 2, 1: 1});
    });
  });

  group('복권별 필터 저장', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('저장 후 그대로 읽힘, 복권끼리 섞이지 않음', () async {
      const f = SavedFilters(
        flags: {'exc1st', 'excAllOdd'},
        include: ['7', '', '12'],
        bonusExclude: ['3'],
        recentDraws: '50',
        mostFrequent: [1, 2, 3, 4, 5, 6],
      );
      await FilterStore.save('kr645', f);
      final back = await FilterStore.load('kr645');
      expect(back!.flags, {'exc1st', 'excAllOdd'});
      expect(back.include, ['7', '', '12']);
      expect(back.bonusExclude, ['3']);
      expect(back.recentDraws, '50');
      expect(back.mostFrequent, [1, 2, 3, 4, 5, 6]);
      expect(await FilterStore.load('powerball'), isNull);
    });

    test('빈 설정을 저장하거나 지우면 남지 않음', () async {
      await FilterStore.save('kr645', const SavedFilters(flags: {'exc1st'}));
      await FilterStore.save('kr645', const SavedFilters(include: ['', '']));
      expect(await FilterStore.load('kr645'), isNull);
      await FilterStore.save('ca649', const SavedFilters(recentDraws: '10'));
      await FilterStore.clear('ca649');
      expect(await FilterStore.load('ca649'), isNull);
    });
  });
}
