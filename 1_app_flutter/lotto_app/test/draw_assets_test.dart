// 앱에 내장한 해외 당첨번호(assets/draws)가 복권 규칙과 맞는지 확인합니다.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:lotto_app/games/game_config.dart';

void main() {
  final games = parseGames(
    jsonDecode(File('assets/games/games.json').readAsStringSync()),
  );

  for (final g in games.where((g) => g.id != 'kr645')) {
    final file = File('assets/draws/${g.id}.csv');
    test('${g.id} 내장 당첨번호', () {
      if (!file.existsSync()) {
        markTestSkipped('${g.id}: 당첨번호 데이터 준비 중');
        return;
      }
      final draws = parseDrawCsv(file.readAsStringSync());
      expect(draws, isNotEmpty);
      expect(
        draws.first.date.compareTo(draws.last.date),
        greaterThan(0),
        reason: '최신 회차가 앞',
      );
      if (g.ruleSince != null) {
        expect(DateTime.parse(draws.last.date).isBefore(g.ruleSince!), isFalse);
      }
      for (final d in draws) {
        expect(d.main.length, g.main.count);
        expect(d.main.toSet().length, g.main.count);
        expect(d.main.every((n) => n >= 1 && n <= g.main.max), isTrue);
        expect(d.bonus.length, g.bonus.count);
        expect(d.bonus.every((n) => n >= 1 && n <= g.bonus.max), isTrue);
      }
    });
  }
}
