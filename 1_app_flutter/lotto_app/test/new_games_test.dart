// 일본 로토6 · 아이리시 로또 · 베트남 메가 6/45 규칙 검증

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
  final ie = games['ie_lotto']!;
  final vn = games['vn_mega645']!;

  test('9개 복권, 모든 이름이 7개 언어', () {
    expect(games.length, 9);
    for (final g in games.values) {
      for (final lang in ['ko', 'en', 'es', 'fr', 'de', 'ja', 'vi']) {
        expect(g.name[lang], isNotNull, reason: '${g.id} $lang');
      }
      if (g.bonus.count > 0) {
        for (final lang in ['ja', 'vi']) {
          expect(g.bonus.label[lang], isNotNull, reason: '${g.id} $lang');
        }
      }
    }
  });

  test('1등 확률', () {
    expect(jp.jackpotOddsDenominator, 6096454);
    expect(ie.jackpotOddsDenominator, 10737573);
    expect(vn.jackpotOddsDenominator, 8145060);
  });

  test('추첨일 알림: 현지 시각 3시간 전', () {
    expect(alarmSlots(jp), [
      const WeeklySlot(1, 15, 45),
      const WeeklySlot(4, 15, 45),
    ]);
    expect(alarmSlots(ie).map((s) => s.hour), [17, 17]);
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

  test('아이리시 로또 등수 (4+보너스, 3+보너스 포함 7단계)', () {
    const d = DrawRecord(1, '2026-10-21', [1, 2, 3, 4, 5, 6], [7]);
    int rank(List<int> n) => checkTicket(ie, Ticket(n, const []), d).rank;
    expect(rank([1, 2, 3, 4, 7, 47]), 4);
    expect(rank([1, 2, 3, 4, 46, 47]), 5);
    expect(rank([1, 2, 3, 7, 46, 47]), 6);
    expect(rank([1, 2, 3, 45, 46, 47]), 7);
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
