// 새 범용 엔진이 한국 6/45 에서 기존 엔진(main.dart 의 calculateLottoCombinations)과
// 정확히 같은 조합 수를 내는지 실제 당첨번호(assets/lotto.csv)로 확인합니다.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/engine/filter_options.dart';
import 'package:lotto_app/games/game_config.dart';
import 'support/legacy_engine_645.dart';

const _allFlags = [
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
];

Map<String, dynamic> legacyParams(
  List<List<int>> winners, {
  Set<String> on = const {},
  List<int> inc = const [],
  List<int> exc = const [],
}) => {
  'pastWinners': winners,
  'inc': inc,
  'exc': exc,
  'mode': 'count',
  'targetExtractCount': 0,
  for (final flag in _allFlags) flag: on.contains(flag),
};

void main() {
  final games = parseGames(
    jsonDecode(File('assets/games/games.json').readAsStringSync()),
  );
  final kr645 = games.firstWhere((g) => g.id == 'kr645');

  // 최신 회차가 앞 (앱이 회차 DESC 로 넘기는 것과 동일)
  final winners = File('assets/lotto.csv')
      .readAsLinesSync()
      .skip(1)
      .where((l) => l.trim().isNotEmpty)
      .map((l) => l.split(',').sublist(2, 8).map(int.parse).toList()..sort())
      .toList();

  final cases = <String, Map<String, dynamic>>{
    '필터 없음': legacyParams(winners),
    '전체 필터': legacyParams(winners, on: _allFlags.toSet()),
    '과거 당첨번호 필터 4종': legacyParams(
      winners,
      on: {'exc1st', 'exc2nd3rd', 'exc4thSeq', 'exc5thSeq'},
    ),
    '패턴 필터 + 포함/제외 번호': legacyParams(
      winners,
      on: {
        'exc3Consec',
        'excSkip2',
        'exc2Pairs',
        'exc10Range',
        'excOE2',
        'excOE5',
      },
      inc: [7],
      exc: [1, 2, 3, 44],
    ),
    '홀짝·끝수·배수': legacyParams(
      winners,
      on: {
        'excAllOdd',
        'excAllEven',
        'excOE1',
        'excOE3',
        'excOE4',
        'excSameLastDigit3',
        'excTripleMultiple',
      },
    ),
  };

  test('당첨번호 데이터 로드', () {
    expect(winners.length, greaterThanOrEqualTo(1237));
  });

  for (final entry in cases.entries) {
    test('6/45 결과 일치: ${entry.key}', () {
      final legacy = calculateLottoCombinations(entry.value)['count'] as int;
      final generic = runEngine(
        EngineRequest(
          game: kr645,
          filters: filterOptionsFromLegacy(entry.value),
          pastWinners: winners,
        ),
      );
      expect(generic.mainCount, legacy);
      expect(generic.total, legacy, reason: '6/45 는 보조 번호를 고르지 않음');
    }, timeout: const Timeout(Duration(minutes: 3)));
  }
}
