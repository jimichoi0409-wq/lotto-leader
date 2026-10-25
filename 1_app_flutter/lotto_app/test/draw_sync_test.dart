// 자동 갱신으로 받은 당첨번호 검증 규칙 테스트 (실제 배포 파일 docs/draws 사용)

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/draw_validation.dart';
import 'package:lotto_app/games/draw_record.dart';
import 'package:lotto_app/games/game_config.dart';

String toCsv(List<DrawRecord> newestFirst) => [
  'draw_no,draw_date,main,bonus',
  for (final d in newestFirst.reversed)
    '${d.no},${d.date},${d.main.join(' ')},${d.bonus.join(' ')}',
].join('\n');

void main() {
  final games = {
    for (final g in parseGames(
      jsonDecode(File('assets/games/games.json').readAsStringSync()),
    ))
      g.id: g,
  };
  final publish = Directory('../../docs/draws');
  final krText = File('${publish.path}/kr645.csv').readAsStringSync();
  final kr = parseDrawCsv(krText); // 최신이 앞
  final kr645 = games['kr645']!;

  test('배포 파일이 있고 한국 6/45 는 1회부터 빠짐없음', () {
    expect(kr.length, greaterThanOrEqualTo(1245));
    expect(kr.last.no, 1);
    expect(kr.first.no, kr.length);
  });

  test('새 회차가 있으면 받아들임 (기기: 1237회까지)', () {
    final local = kr.where((d) => d.no <= 1237).toList();
    final result = validateRemoteDraws(kr645, krText, local);
    expect(result, isNotNull);
    expect(result!.length, kr.length);
  });

  test('기존 회차 번호가 다르면 전체 거부', () {
    final local = kr.where((d) => d.no <= 1237).toList();
    final tampered = [
      for (final d in kr)
        d.no == 1000
            ? DrawRecord(d.no, d.date, [1, 2, 3, 4, 5, 6], d.bonus)
            : d,
    ];
    expect(validateRemoteDraws(kr645, toCsv(tampered), local), isNull);
  });

  test('회차가 늘지 않았으면 거부', () {
    expect(validateRemoteDraws(kr645, krText, kr), isNull);
  });

  test('규칙 위반(범위·중복·보너스 겹침)이 하나라도 있으면 거부', () {
    final local = kr.where((d) => d.no <= 1200).toList();
    DrawRecord latest(List<int> main, List<int> bonus) =>
        DrawRecord(kr.first.no + 1, '2026-10-17', main, bonus);
    for (final bad in [
      latest([1, 2, 3, 4, 5, 46], [7]), // 범위
      latest([1, 1, 3, 4, 5, 6], [7]), // 중복
      latest([1, 2, 3, 4, 5, 6], [6]), // 보너스가 메인과 겹침
      latest([1, 2, 3, 4, 5], [7]), // 개수
    ]) {
      expect(validateRemoteDraws(kr645, toCsv([bad, ...kr]), local), isNull);
    }
  });

  test('예전 기기 DB(추첨일 없음)는 회차로 맞춰 봄', () {
    final local = [
      for (final d in kr.where((d) => d.no <= 1237))
        DrawRecord(d.no, '', d.main, d.bonus),
    ];
    expect(validateRemoteDraws(kr645, krText, local), isNotNull);
  });

  test('해외 복권: 파워볼 최근 3회가 빠진 기기에 갱신', () {
    final text = File('${publish.path}/powerball.csv').readAsStringSync();
    final all = parseDrawCsv(text);
    final local = all.skip(3).toList();
    final result = validateRemoteDraws(games['powerball']!, text, local);
    expect(result, isNotNull);
    expect(result!.first.date, all.first.date);
  });

  test('잘못된 CSV 는 예외 없이 거부', () {
    expect(
      validateRemoteDraws(kr645, '<html>blocked</html>', const []),
      isNull,
    );
    expect(
      validateRemoteDraws(
        kr645,
        'draw_no,draw_date,main,bonus\nx,y,z,w',
        const [],
      ),
      isNull,
    );
  });

  test('관리자 정정(revision 상승): 같은 회차 수라도 번호가 바뀐 데이터를 받음', () {
    final corrected = [
      for (final d in kr)
        d.no == kr.first.no
            ? DrawRecord(d.no, d.date, [1, 2, 3, 4, 5, 6], [7])
            : d,
    ];
    // 정정이 아니면(기존 규칙) 거부
    expect(validateRemoteDraws(kr645, toCsv(corrected), kr), isNull);
    // 정정이면 받아들이고, 고친 번호가 들어감
    final r = validateRemoteDraws(
      kr645,
      toCsv(corrected),
      kr,
      allowCorrection: true,
    );
    expect(r, isNotNull);
    expect(r!.first.main, [1, 2, 3, 4, 5, 6]);
  });

  test('관리자 정정이어도 규칙 위반·회차 감소는 거부', () {
    final broken = [
      for (final d in kr)
        d.no == kr.first.no
            ? DrawRecord(d.no, d.date, [1, 2, 3, 4, 5, 46], [7])
            : d,
    ];
    expect(
      validateRemoteDraws(kr645, toCsv(broken), kr, allowCorrection: true),
      isNull,
    );
    expect(
      validateRemoteDraws(
        kr645,
        toCsv(kr.skip(1).toList()),
        kr,
        allowCorrection: true,
      ),
      isNull,
    );
  });
}
