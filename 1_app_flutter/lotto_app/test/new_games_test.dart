// 일본 로토6·로또7 · 프랑스 로또 · 브라질 메가세나 · 베트남 메가 6/45 규칙 검증

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/draw_alarm.dart';
import 'package:lotto_app/data/draw_validation.dart';
import 'package:lotto_app/data/manual_draws.dart';
import 'package:lotto_app/data/win_check.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/engine/filter_options.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:lotto_app/games/game_config.dart';

void main() {
  final games = {
    for (final g in parseGames(
      jsonDecode(File('assets/games/games.json').readAsStringSync())
          as Map<String, dynamic>,
    ))
      g.id: g,
  };
  final jp = games['jp_loto6']!;
  final jp7 = games['jp_loto7']!;
  final fr = games['fr_loto']!;
  final br = games['br_megasena']!;
  final vn = games['vn_mega645']!;

  test('11개 복권, 모든 이름이 8개 언어', () {
    expect(games.length, 11);
    expect(games.containsKey('ie_lotto'), isFalse);
    for (final g in games.values) {
      for (final lang in ['ko', 'en', 'es', 'fr', 'de', 'ja', 'vi', 'pt']) {
        expect(g.name[lang], isNotNull, reason: '${g.id} $lang');
      }
      if (g.bonus.count > 0) {
        for (final lang in ['ja', 'vi', 'pt']) {
          expect(g.bonus.label[lang], isNotNull, reason: '${g.id} $lang');
        }
      }
    }
  });

  test('1등 확률', () {
    expect(jp.jackpotOddsDenominator, 6096454);
    expect(jp7.jackpotOddsDenominator, 10295472);
    expect(fr.jackpotOddsDenominator, 19068840);
    expect(br.jackpotOddsDenominator, 50063860);
    expect(vn.jackpotOddsDenominator, 8145060);
  });

  test('추첨일 알림: 현지 시각 3시간 전', () {
    expect(alarmSlots(jp), [
      const WeeklySlot(1, 15, 45),
      const WeeklySlot(4, 15, 45),
    ]);
    expect(alarmSlots(jp7), [const WeeklySlot(5, 15, 45)]);
    expect(alarmSlots(fr), [
      const WeeklySlot(1, 17, 20),
      const WeeklySlot(3, 17, 20),
      const WeeklySlot(6, 17, 20),
    ]);
    // 메가세나: 화·목 21:00, 일요일만 11:00
    expect(alarmSlots(br), [
      const WeeklySlot(2, 18, 0),
      const WeeklySlot(4, 18, 0),
      const WeeklySlot(7, 8, 0),
    ]);
    expect(alarmSlots(vn).map((s) => s.weekday), [3, 5, 7]);
  });

  test('로토6 등수 (2등 = 5개 + 보너스)', () {
    const d = DrawRecord(1, '2026-10-22', [1, 2, 3, 4, 5, 6], [7]);
    int rank(List<int> n) => checkTicket(jp, Ticket(n, const []), d).rank;
    expect(rank([1, 2, 3, 4, 5, 6]), 1);
    expect(rank([1, 2, 3, 4, 5, 7]), 2);
    expect(rank([1, 2, 3, 4, 5, 43]), 3);
    expect(rank([1, 2, 3, 4, 42, 43]), 4);
    expect(rank([1, 2, 3, 41, 42, 43]), 5);
    expect(rank([1, 2, 40, 41, 42, 43]), 0);
  });

  test('로또7 등수 (6등 = 3개 + 보너스 1~2개)', () {
    const d = DrawRecord(1, '2026-10-30', [1, 2, 3, 4, 5, 6, 7], [8, 9]);
    int rank(List<int> n) => checkTicket(jp7, Ticket(n, const []), d).rank;
    expect(rank([1, 2, 3, 4, 5, 6, 7]), 1);
    expect(rank([1, 2, 3, 4, 5, 6, 8]), 2);
    expect(rank([1, 2, 3, 4, 5, 6, 37]), 3);
    expect(rank([1, 2, 3, 4, 5, 36, 37]), 4);
    expect(rank([1, 2, 3, 4, 35, 36, 37]), 5);
    expect(rank([1, 2, 3, 8, 35, 36, 37]), 6);
    expect(rank([1, 2, 3, 8, 9, 36, 37]), 6);
    expect(rank([1, 2, 3, 34, 35, 36, 37]), 0);
  });

  test('프랑스 로또 등수 (9등 = 0~1개 + 행운번호)', () {
    const d = DrawRecord(1, '2026-11-02', [1, 2, 3, 4, 5], [9]);
    int rank(List<int> n, int chance) =>
        checkTicket(fr, Ticket(n, [chance]), d).rank;
    expect(rank([1, 2, 3, 4, 5], 9), 1);
    expect(rank([1, 2, 3, 4, 5], 1), 2);
    expect(rank([1, 2, 40, 41, 42], 9), 7);
    expect(rank([1, 2, 40, 41, 42], 1), 8);
    expect(rank([1, 40, 41, 42, 43], 9), 9);
    expect(rank([40, 41, 42, 43, 44], 9), 9);
    expect(rank([1, 40, 41, 42, 43], 1), 0);
    expect(fr.hasPlayerBonus, isTrue);
  });

  test('메가세나: 보너스 없음, 3단계, 특별 추첨일도 직접 입력 가능', () {
    const d = DrawRecord(1, '2026-11-01', [1, 2, 3, 4, 5, 6], []);
    int rank(List<int> n) => checkTicket(br, Ticket(n, const []), d).rank;
    expect(rank([1, 2, 3, 4, 5, 6]), 1);
    expect(rank([1, 2, 3, 4, 5, 60]), 2);
    expect(rank([1, 2, 3, 4, 59, 60]), 3);
    expect(rank([1, 2, 3, 58, 59, 60]), 0);

    // 2026-11-04 는 수요일(정규 추첨일 아님)이지만 특별 추첨이 있으므로 허용
    final ok = validateManualDraw(
      br,
      const DrawRecord(1, '2026-11-04', [1, 2, 3, 4, 5, 6], []),
      const [],
      DateTime(2026, 11, 5),
    );
    expect(ok, isNull);
    // 정규 요일만 있는 복권은 그대로 거부
    final bad = validateManualDraw(
      jp,
      const DrawRecord(1, '2026-11-04', [1, 2, 3, 4, 5, 6], [7]),
      const [],
      DateTime(2026, 11, 5),
    );
    expect(bad, ManualDrawError.date);
  });

  test('메가세나 전체 조합(5,006만) 계산 시간', () {
    final sw = Stopwatch()..start();
    final r = runEngine(
      EngineRequest(
        game: br,
        filters: const FilterOptions(),
        pastWinners: const [],
        mode: EngineMode.extract,
        extractCount: 5,
        seed: 1,
      ),
    );
    sw.stop();
    // ignore: avoid_print
    print('메가세나 전체 조합 ${r.total} / ${sw.elapsedMilliseconds}ms');
    expect(r.total, 50063860);
    expect(r.tickets.length, 5);
  });

  test('베트남 메가 6/45: 보너스 번호 없음', () {
    const d = DrawRecord(1, '2026-10-23', [1, 2, 3, 4, 5, 6], []);
    int rank(List<int> n) => checkTicket(vn, Ticket(n, const []), d).rank;
    expect(rank([1, 2, 3, 4, 5, 45]), 2);
    expect(rank([1, 2, 3, 45, 44, 43]..sort()), 4);
    expect(vn.hasPlayerBonus, isFalse);

    // 엔진: 보조 번호 없이 메인 조합만
    final r = runEngine(
      EngineRequest(
        game: vn,
        filters: const FilterOptions(include: {1, 2, 3, 4, 5}),
        pastWinners: const [],
        mode: EngineMode.extract,
        extractCount: 3,
        seed: 1,
      ),
    );
    expect(r.mainCount, 40);
    expect(r.total, 40);
    expect(r.tickets.every((t) => t.bonus.isEmpty), isTrue);

    // 직접 입력: 보너스 없이 저장 가능, 보너스를 넣으면 오류
    final ok = validateManualDraw(
      vn,
      const DrawRecord(1, '2026-10-23', [1, 2, 3, 4, 5, 6], []),
      const [],
      DateTime(2026, 10, 25),
    );
    expect(ok, isNull);
    final bad = validateManualDraw(
      vn,
      const DrawRecord(1, '2026-10-23', [1, 2, 3, 4, 5, 6], [7]),
      const [],
      DateTime(2026, 10, 25),
    );
    expect(bad, ManualDrawError.bonusNumbers);

    // 서버 데이터 검증: 보너스 열이 비어 있는 CSV
    const csv = 'draw_no,draw_date,main,bonus\n1,2026-10-23,1 2 3 4 5 6,\n';
    expect(validateRemoteDraws(vn, csv, const [])!.single.bonus, isEmpty);
  });
}
