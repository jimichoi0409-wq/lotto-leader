import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/backup.dart';
import 'package:lotto_app/data/filter_store.dart';
import 'package:lotto_app/data/manual_draws.dart';
import 'package:lotto_app/data/user_store.dart';
import 'package:lotto_app/engine/combination_engine.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:lotto_app/games/game_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final games = parseGames(
    jsonDecode(File('assets/games/games.json').readAsStringSync())
        as Map<String, dynamic>,
  );

  HistoryEntry entry(int id, String game, Ticket t, DateTime at) =>
      HistoryEntry(id: id, gameId: game, createdAt: at, tickets: [t]);

  final sample = BackupData(
    profile: UserProfile('로또왕', DateTime(2026, 1, 2)),
    history: [
      entry(
        2,
        'powerball',
        const Ticket([1, 2, 3, 4, 5], [6]),
        DateTime(2026, 3, 1),
      ),
      entry(
        1,
        'kr645',
        const Ticket([1, 2, 3, 4, 5, 6], []),
        DateTime(2026, 2, 1),
      ),
    ],
    manualDraws: {
      'kr645': [
        const DrawRecord(1246, '2026-10-17', [1, 2, 3, 4, 5, 6], [7]),
      ],
    },
    filters: {
      'kr645': const SavedFilters(flags: {'exc1st'}, recentDraws: '30'),
    },
  );

  test('내보낸 파일을 그대로 다시 읽음', () {
    final back = decodeBackup(encodeBackup(sample), games);
    expect(back.profile!.nickname, '로또왕');
    expect(back.profile!.createdAt, DateTime(2026, 1, 2));
    expect(back.history.map((e) => e.id), [2, 1]);
    expect(back.history.first.tickets.first.bonus, [6]);
    expect(back.manualDraws['kr645']!.single.no, 1246);
    expect(back.manualDraws['kr645']!.single.manual, isTrue);
    expect(back.filters['kr645']!.flags, {'exc1st'});
    expect(back.filters['kr645']!.recentDraws, '30');
  });

  test('다른 파일·손상된 파일은 거부', () {
    expect(
      () => decodeBackup('not json', games),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => decodeBackup('{"app":"other","version":1}', games),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => decodeBackup('{"app":"lotto_leader","version":99}', games),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => decodeBackup('[1,2,3]', games),
      throwsA(isA<BackupFormatException>()),
    );
  });

  test('모르는 복권·범위를 벗어난 번호는 건너뜀', () {
    final raw = jsonDecode(encodeBackup(sample)) as Map<String, dynamic>;
    (raw['history'] as List).addAll([
      // 6/45 에 46
      entry(
        3,
        'kr645',
        const Ticket([1, 2, 3, 4, 5, 46], []),
        DateTime(2026, 4, 1),
      ).toJson(),
      // 중복 번호
      entry(
        4,
        'kr645',
        const Ticket([1, 1, 3, 4, 5, 6], []),
        DateTime(2026, 4, 1),
      ).toJson(),
      // 파워볼인데 보조 번호 없음
      entry(
        5,
        'powerball',
        const Ticket([1, 2, 3, 4, 5], []),
        DateTime(2026, 4, 1),
      ).toJson(),
      entry(
        6,
        'unknown',
        const Ticket([1, 2, 3], []),
        DateTime(2026, 4, 1),
      ).toJson(),
    ]);
    (raw['manualDraws'] as Map)['kr645'].add({
      'no': 1,
      'date': 'bad',
      'main': [1, 2, 3, 4, 5, 6],
      'bonus': [7],
    });
    raw['profile'] = {'nickname': 'x', 'createdAt': '2026-01-01'};
    final back = decodeBackup(jsonEncode(raw), games);
    expect(back.history.map((e) => e.id), [2, 1]);
    expect(back.manualDraws['kr645']!.length, 1);
    expect(back.profile, isNull); // 닉네임 규칙(2~12자) 위반
  });

  test('합치기: 중복 없이, 지금 기기 직접 입력분 우선', () {
    final current = BackupData(
      profile: UserProfile('새폰', DateTime(2026, 10, 18)),
      history: [
        entry(
          1,
          'kr645',
          const Ticket([1, 2, 3, 4, 5, 6], []),
          DateTime(2026, 2, 1),
        ),
        entry(
          9,
          'kr645',
          const Ticket([7, 8, 9, 10, 11, 12], []),
          DateTime(2026, 10, 18),
        ),
      ],
      manualDraws: {
        'kr645': [
          const DrawRecord(1246, '2026-10-17', [11, 12, 13, 14, 15, 16], [17]),
        ],
      },
    );
    final m = mergeBackup(current, sample);
    expect(m.profile!.nickname, '로또왕');
    expect(m.history.map((e) => e.id), [9, 2, 1]);
    expect(m.manualDraws['kr645']!.single.main.first, 11);
    expect(m.filters['kr645']!.recentDraws, '30');
  });

  test('기기에 저장 → 복원 결과 건수', () async {
    SharedPreferences.setMockInitialValues({});
    await UserStore.saveProfile(UserProfile('새폰', DateTime(2026, 10, 18)));
    final summary = await BackupStore.restore(sample, games);
    expect(summary.historyAdded, 2);
    expect(summary.manualAdded, 1);
    expect((await UserStore.profile())!.nickname, '로또왕');
    expect((await UserStore.history()).length, 2);
    expect((await ManualDrawStore.load('kr645')).single.no, 1246);
    expect((await FilterStore.load('kr645'))!.flags, {'exc1st'});

    // 같은 파일을 두 번 불러와도 늘어나지 않음
    final again = await BackupStore.restore(sample, games);
    expect(again.historyAdded, 0);
    expect(again.manualAdded, 0);
    expect((await UserStore.history()).length, 2);
  });
}
