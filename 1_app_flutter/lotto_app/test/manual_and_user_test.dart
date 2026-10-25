// 당첨번호 직접 입력·가입 정보·이용 기록 저장 테스트

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/manual_draws.dart';
import 'package:lotto_app/data/user_store.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:lotto_app/games/game_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final games = {
    for (final g in parseGames(
      jsonDecode(File('assets/games/games.json').readAsStringSync()),
    ))
      g.id: g,
  };
  final kr = games['kr645']!;
  final pb = games['powerball']!;
  // 시나리오 고정: 실제 데이터가 계속 늘어나도 "1245회(2026-10-10)까지 있음" 기준으로 시험
  final official = parseKoreanCsv(
    File('assets/lotto.csv').readAsStringSync(),
  ).where((d) => d.no <= 1245).toList(); // 최신이 앞

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('합치기', () {
    test('직접 입력분이 공식 데이터 뒤 최신 회차로 붙음', () {
      final manual = [
        DrawRecord(
          official.first.no + 1,
          '2026-10-17',
          [1, 2, 3, 4, 5, 6],
          [7],
          manual: true,
        ),
      ];
      final merged = mergeDraws(official, manual);
      expect(merged.length, official.length + 1);
      expect(merged.first.manual, isTrue);
    });

    test('같은 날짜는 공식 데이터가 우선', () {
      final manual = [
        DrawRecord(
          official.first.no,
          official.first.date,
          [1, 2, 3, 4, 5, 6],
          [7],
          manual: true,
        ),
      ];
      final merged = mergeDraws(official, manual);
      expect(merged.length, official.length);
      expect(merged.first.manual, isFalse);
      expect(merged.first.main, official.first.main);
    });
  });

  group('직접 입력 검증', () {
    final today = DateTime(2026, 10, 18); // 일요일
    DrawRecord d(int no, String date, List<int> main, List<int> bonus) =>
        DrawRecord(no, date, main, bonus);

    test('정상 입력 (한국 1246회, 2026-10-17 토)', () {
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-17', [3, 11, 19, 27, 35, 43], [8]),
          official,
          today,
        ),
        isNull,
      );
    });
    test('번호 개수·범위·중복 오류', () {
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-17', [1, 2, 3, 4, 5], [8]),
          official,
          today,
        ),
        ManualDrawError.mainNumbers,
      );
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-17', [1, 2, 3, 4, 5, 46], [8]),
          official,
          today,
        ),
        ManualDrawError.mainNumbers,
      );
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-17', [1, 1, 3, 4, 5, 6], [8]),
          official,
          today,
        ),
        ManualDrawError.mainNumbers,
      );
    });
    test('보너스가 당첨번호와 겹치면 오류 (한국)', () {
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-17', [1, 2, 3, 4, 5, 6], [6]),
          official,
          today,
        ),
        ManualDrawError.bonusOverlap,
      );
    });
    test('파워볼은 보조 번호가 겹쳐도 됨, 범위는 1~26', () {
      expect(
        validateManualDraw(
          pb,
          d(2000, '2026-10-17', [1, 2, 3, 4, 5], [5]),
          const [],
          today,
        ),
        isNull,
      );
      expect(
        validateManualDraw(
          pb,
          d(2000, '2026-10-17', [1, 2, 3, 4, 5], [27]),
          const [],
          today,
        ),
        ManualDrawError.bonusNumbers,
      );
    });
    test('미래·추첨 요일 아님·규칙 시작 전 날짜는 오류', () {
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-24', [1, 2, 3, 4, 5, 6], [7]),
          official,
          today,
        ),
        ManualDrawError.date,
      );
      expect(
        validateManualDraw(
          kr,
          d(1246, '2026-10-16', [1, 2, 3, 4, 5, 6], [7]),
          official,
          today,
        ),
        ManualDrawError.date,
      );
      expect(
        validateManualDraw(
          pb,
          d(1, '2015-10-03', [1, 2, 3, 4, 5], [1]),
          const [],
          today,
        ),
        ManualDrawError.date,
      );
    });
    test('이미 있는 날짜·한국 회차는 오류', () {
      expect(
        validateManualDraw(
          kr,
          d(1246, official.first.date, [1, 2, 3, 4, 5, 6], [7]),
          official,
          today,
        ),
        ManualDrawError.exists,
      );
      expect(
        validateManualDraw(
          kr,
          d(official.first.no, '2026-10-17', [1, 2, 3, 4, 5, 6], [7]),
          official,
          today,
        ),
        ManualDrawError.exists,
      );
    });
  });

  test('다음 입력 회차·추첨일 제안', () {
    expect(nextDrawNo(official), official.first.no + 1);
    // 마지막 기록 2026-10-10(토) → 다음 토요일 2026-10-17
    expect(
      suggestedDrawDate(kr, official, DateTime(2026, 10, 18)),
      DateTime(2026, 10, 17),
    );
    // 파워볼(월·수·토), 기록 없음, 오늘 화요일 → 어제 월요일
    expect(
      suggestedDrawDate(pb, const [], DateTime(2026, 10, 20)),
      DateTime(2026, 10, 19),
    );
  });

  test('직접 입력 저장·불러오기·공식 데이터로 정리', () async {
    final m = DrawRecord(1246, '2026-10-17', [3, 11, 19, 27, 35, 43], [8]);
    await ManualDrawStore.save('kr645', [m]);
    final loaded = await ManualDrawStore.load('kr645');
    expect(loaded.single.manual, isTrue);
    expect(loaded.single.main, m.main);

    final newOfficial = [
      DrawRecord(1246, '2026-10-17', [4, 5, 6, 7, 8, 9], [10]),
      ...official,
    ];
    expect(await ManualDrawStore.prune('kr645', newOfficial), isEmpty);
    expect(await ManualDrawStore.load('kr645'), isEmpty);
  });

  group('가입·기록', () {
    test('닉네임 규칙 2~12자', () {
      expect(UserProfile.validNickname(' a '), isFalse);
      expect(UserProfile.validNickname('로또'), isTrue);
      expect(UserProfile.validNickname('가나다라마바사아자차카타'), isTrue);
      expect(UserProfile.validNickname('가나다라마바사아자차카타파'), isFalse);
    });

    test('가입 정보 저장 후 탈퇴하면 삭제', () async {
      expect(await UserStore.profile(), isNull);
      await UserStore.saveProfile(UserProfile('대장', DateTime(2026, 10, 18)));
      expect((await UserStore.profile())!.nickname, '대장');
      await UserStore.addHistory(
        HistoryEntry(
          id: 1,
          gameId: 'kr645',
          createdAt: DateTime.now(),
          tickets: const [],
        ),
      );
      await UserStore.deleteAccount();
      expect(await UserStore.profile(), isNull);
      expect(await UserStore.history(), isEmpty);
    });

    test('기록은 최신순, 개별 삭제, 최대 개수 유지', () async {
      for (var i = 0; i < UserStore.maxHistory + 5; i++) {
        await UserStore.addHistory(
          HistoryEntry(
            id: i,
            gameId: 'powerball',
            createdAt: DateTime(2026, 1, 1).add(Duration(minutes: i)),
            tickets: [
              Ticket([1, 2, 3, 4, 5], [i % 26 + 1]),
            ],
            filterCount: 3,
          ),
        );
      }
      var list = await UserStore.history();
      expect(list.length, UserStore.maxHistory);
      expect(list.first.id, UserStore.maxHistory + 4);
      expect(list.first.tickets.single.bonus, [
        (UserStore.maxHistory + 4) % 26 + 1,
      ]);
      await UserStore.removeHistory(list.first.id);
      list = await UserStore.history();
      expect(list.first.id, UserStore.maxHistory + 3);
    });
  });
}
