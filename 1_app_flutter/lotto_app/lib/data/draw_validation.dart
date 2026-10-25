// 서버에서 받은 당첨번호를 받아들여도 되는지 검사합니다 (네트워크·파일과 무관한 순수 함수).
//
// 받아들이는 조건
// - 모든 회차가 복권 규칙(번호 개수·범위·중복, 보조 번호)을 지킴
// - 날짜가 겹치지 않고, 현재 규칙 시작일 이후
// - 기기에 이미 있는 회차는 번호가 똑같음 (서버 데이터가 잘못되어 기존 기록을 덮어쓰는 일 방지)
// - 기존보다 회차가 많음 (줄어드는 갱신은 거부)
//
// 관리자 정정([allowCorrection] = true, 서버의 revision 이 기기보다 높을 때)
// - 이미 있는 회차의 번호가 달라도 받아들임 (잘못 올라간 번호 교체)
// - 회차 수는 같거나 많아야 함. 번호 규칙 검사는 그대로

import '../games/draw_record.dart';
import '../games/game_config.dart';

List<DrawRecord>? validateRemoteDraws(
  GameConfig game,
  String csvText,
  List<DrawRecord> local, {
  bool allowCorrection = false,
}) {
  final List<DrawRecord> remote;
  try {
    remote = parseDrawCsv(csvText); // 최신 회차가 앞
  } catch (_) {
    return null;
  }
  if (allowCorrection
      ? remote.length < local.length
      : remote.length <= local.length) {
    return null;
  }

  final since = game.ruleSince;
  final dates = <String>{};
  for (final d in remote) {
    final date = DateTime.tryParse(d.date);
    if (date == null || !dates.add(d.date)) return null;
    if (since != null && date.isBefore(since)) return null;
    if (!_validNumbers(d.main, game.main.count, game.main.max)) return null;
    if (!_validNumbers(d.bonus, game.bonus.count, game.bonus.max)) return null;
    if (!game.bonus.playerPicks && d.bonus.any(d.main.contains)) return null;
  }

  if (allowCorrection) return remote;

  final byDate = {for (final d in remote) d.date: d};
  final byNo = {for (final d in remote) d.no: d};
  for (final old in local) {
    // 예전 기기 DB 에는 추첨일이 비어 있을 수 있어 그때는 회차로 맞춰 봅니다.
    final match = old.date.isEmpty ? byNo[old.no] : byDate[old.date];
    if (match == null ||
        !_same(match.main, old.main) ||
        !_same(match.bonus, old.bonus)) {
      return null;
    }
  }
  return remote;
}

bool _validNumbers(List<int> nums, int count, int max) =>
    nums.length == count &&
    nums.toSet().length == count &&
    nums.every((n) => n >= 1 && n <= max);

bool _same(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  final sa = [...a]..sort();
  final sb = [...b]..sort();
  for (var i = 0; i < sa.length; i++) {
    if (sa[i] != sb[i]) return false;
  }
  return true;
}
