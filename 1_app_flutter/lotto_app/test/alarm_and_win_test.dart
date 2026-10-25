import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/draw_alarm.dart';
import 'package:lotto_app/data/win_check.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:lotto_app/games/game_config.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  final games = {
    for (final g in parseGames(
      jsonDecode(File('assets/games/games.json').readAsStringSync())
          as Map<String, dynamic>,
    ))
      g.id: g,
  };
  final kr = games['kr645']!;
  final pb = games['powerball']!;
  final em = games['euromillions']!;
  final ca = games['ca649']!;

  setUpAll(tzdata.initializeTimeZones);

  group('games.json', () {
    test('모든 복권에 추첨 시각과 등수 표가 있다', () {
      for (final g in games.values) {
        expect(g.prizeTiers, isNotEmpty, reason: g.id);
        expect(g.drawHour, inInclusiveRange(0, 23));
        expect(tz.getLocation(g.timezone), isNotNull);
        // 1등은 메인 전부 일치
        expect(g.prizeTiers.first.main, g.main.count, reason: g.id);
      }
      expect(kr.drawHour, 20);
      expect(kr.drawMinute, 35);
      expect(pb.prizeTiers.length, 9);
      expect(em.prizeTiers.length, 13);
    });
  });

  group('추첨일 알림', () {
    test('추첨 3시간 전 같은 요일', () {
      expect(alarmSlots(kr), [const WeeklySlot(6, 17, 35)]);
      expect(alarmSlots(pb), [
        const WeeklySlot(1, 19, 59),
        const WeeklySlot(3, 19, 59),
        const WeeklySlot(6, 19, 59),
      ]);
    });

    test('자정 넘어가면 전날 요일', () {
      expect(alarmSlots(kr, leadMinutes: 21 * 60), [
        const WeeklySlot(5, 23, 35),
      ]);
    });

    test('다음 알림 시각은 현지 시간대 기준, 서머타임 반영', () {
      final ny = tz.getLocation('America/New_York');
      // 2026-03-07 (토) 정오 → 같은 날 19:59 EST
      final sat = nextOccurrence(
        const WeeklySlot(6, 19, 59),
        tz.TZDateTime(ny, 2026, 3, 7, 12),
      );
      expect(
        [sat.year, sat.month, sat.day, sat.hour, sat.minute],
        [2026, 3, 7, 19, 59],
      );
      expect(sat.timeZoneOffset, const Duration(hours: -5));
      // 다음 월요일(3/9)은 서머타임(EDT) — 현지 19:59 유지
      final mon = nextOccurrence(const WeeklySlot(1, 19, 59), sat);
      expect([mon.month, mon.day, mon.hour], [3, 9, 19]);
      expect(mon.timeZoneOffset, const Duration(hours: -4));
      // 이미 지난 시각이면 다음 주
      final next = nextOccurrence(
        const WeeklySlot(6, 19, 59),
        tz.TZDateTime(ny, 2026, 3, 7, 20),
      );
      expect([next.month, next.day], [3, 14]);
    });

    test('알림 id 는 복권·요일별로 겹치지 않는다', () {
      final ids = {
        for (final g in games.values)
          for (var i = 0; i < 7; i++) alarmId(g.id, i),
      };
      expect(ids.length, games.length * 7);
    });
  });

  group('당첨 확인', () {
    const krDraw = DrawRecord(1200, '2025-12-06', [1, 2, 3, 4, 5, 6], [7]);

    test('한국 6/45 등수', () {
      int rank(List<int> n) =>
          checkTicket(kr, Ticket(n, const []), krDraw).rank;
      expect(rank([1, 2, 3, 4, 5, 6]), 1);
      expect(rank([1, 2, 3, 4, 5, 7]), 2);
      expect(rank([1, 2, 3, 4, 5, 40]), 3);
      expect(rank([1, 2, 3, 4, 7, 40]), 4);
      expect(rank([1, 2, 3, 7, 40, 41]), 5);
      expect(rank([1, 2, 7, 40, 41, 42]), 0);
      final r = checkTicket(kr, const Ticket([1, 2, 3, 4, 5, 7], []), krDraw);
      expect(r.mainHits, {1, 2, 3, 4, 5});
      expect(r.bonusHits, {7});
    });

    test('파워볼: 파워볼만 맞아도 9등', () {
      const d = DrawRecord(1, '2026-01-03', [10, 20, 30, 40, 50], [5]);
      int rank(List<int> m, int b) => checkTicket(pb, Ticket(m, [b]), d).rank;
      expect(rank([10, 20, 30, 40, 50], 5), 1);
      expect(rank([10, 20, 30, 40, 50], 6), 2);
      expect(rank([1, 2, 3, 4, 9], 5), 9);
      expect(rank([10, 2, 3, 4, 9], 6), 0);
      expect(rank([10, 20, 30, 4, 9], 6), 6);
    });

    test('유로밀리언: 4+0 은 7등, 2+0 은 13등', () {
      const d = DrawRecord(1, '2026-01-02', [1, 2, 3, 4, 5], [1, 2]);
      int rank(List<int> m, List<int> b) =>
          checkTicket(em, Ticket(m, b), d).rank;
      expect(rank([1, 2, 3, 4, 50], [8, 9]), 7);
      expect(rank([1, 2, 30, 40, 50], [8, 9]), 13);
      expect(rank([1, 2, 3, 4, 5], [1, 2]), 1);
    });

    test('캐나다 6/49: 2개 + 보너스', () {
      const d = DrawRecord(1, '2026-01-03', [1, 2, 3, 4, 5, 6], [9]);
      int rank(List<int> n) => checkTicket(ca, Ticket(n, const []), d).rank;
      expect(rank([1, 2, 9, 40, 41, 42]), 6);
      expect(rank([1, 2, 30, 40, 41, 42]), 7);
      expect(rank([1, 30, 9, 40, 41, 42]), 0);
    });

    test('추출 후 처음 열린 추첨과 비교', () {
      const draws = [
        DrawRecord(3, '2025-12-13', [1, 2, 3, 4, 5, 6], [7]),
        krDraw, // 12-06 (토)
        DrawRecord(1, '2025-11-29', [1, 2, 3, 4, 5, 6], [7]),
      ];
      // 수요일에 뽑으면 그 주 토요일
      expect(firstDrawAfter(kr, draws, DateTime(2025, 12, 3, 10))!.no, 1200);
      // 추첨일 추첨 전이면 그날
      expect(firstDrawAfter(kr, draws, DateTime(2025, 12, 6, 19))!.no, 1200);
      // 추첨일 추첨 후면 다음 주
      expect(firstDrawAfter(kr, draws, DateTime(2025, 12, 6, 21))!.no, 3);
      // 아직 결과 없음
      expect(firstDrawAfter(kr, draws, DateTime(2025, 12, 14)), isNull);

      final e = checkEntry(
        kr,
        const [
          Ticket([1, 2, 3, 40, 41, 42], []),
          Ticket([1, 2, 3, 4, 41, 42], []),
        ],
        DateTime(2025, 12, 3),
        draws,
      );
      expect(e.draw!.no, 1200);
      expect(e.tickets.map((t) => t.rank), [5, 4]);
      expect(e.bestRank, 4);
      expect(
        checkEntry(kr, const [], DateTime(2026, 1, 1), draws).draw,
        isNull,
      );
    });
  });
}
