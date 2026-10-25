// 내 번호 당첨 확인: 저장한 조합을 추출 후 처음 열린 추첨 결과와 비교합니다.

import '../engine/combination_engine.dart';
import '../games/draw_record.dart';
import '../games/game_config.dart';

class TicketResult {
  final Set<int> mainHits;

  /// 보조 번호를 고르는 복권: 맞힌 보조 번호.
  /// 고르지 않는 복권(한국·캐나다): 내 메인 번호 중 추첨 보너스 번호와 같은 것.
  final Set<int> bonusHits;

  /// 1부터 시작하는 등수, 0 = 낙첨
  final int rank;

  const TicketResult(this.mainHits, this.bonusHits, this.rank);
}

class EntryResult {
  /// 비교한 추첨. null 이면 아직 추첨 전(또는 결과 미입력)
  final DrawRecord? draw;
  final List<TicketResult> tickets;

  const EntryResult(this.draw, this.tickets);

  /// 가장 높은 등수 (0 = 전부 낙첨)
  int get bestRank {
    var best = 0;
    for (final t in tickets) {
      if (t.rank > 0 && (best == 0 || t.rank < best)) best = t.rank;
    }
    return best;
  }
}

/// [createdAt] 이후 처음 열린 추첨. [draws] 는 순서 무관.
/// 추첨일 당일에 뽑았으면 추첨 시각(복권 현지 시각을 휴대폰 시각으로 근사) 전일 때만 그날 추첨으로 봅니다.
DrawRecord? firstDrawAfter(
  GameConfig game,
  List<DrawRecord> draws,
  DateTime createdAt,
) {
  final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
  final beforeDraw =
      createdAt.hour * 60 + createdAt.minute <
      game.drawHour * 60 + game.drawMinute;
  DrawRecord? best;
  DateTime? bestDate;
  for (final d in draws) {
    final date = DateTime.tryParse(d.date);
    if (date == null) continue;
    final dd = DateTime(date.year, date.month, date.day);
    final eligible = dd.isAfter(day) || (dd == day && beforeDraw);
    if (!eligible) continue;
    if (bestDate == null || dd.isBefore(bestDate)) {
      best = d;
      bestDate = dd;
    }
  }
  return best;
}

TicketResult checkTicket(GameConfig game, Ticket ticket, DrawRecord draw) {
  final mainHits = ticket.main.toSet().intersection(draw.main.toSet());
  final Set<int> bonusHits = game.hasPlayerBonus
      ? ticket.bonus.toSet().intersection(draw.bonus.toSet())
      : ticket.main.toSet().intersection(draw.bonus.toSet());
  var rank = 0;
  for (var i = 0; i < game.prizeTiers.length; i++) {
    final tier = game.prizeTiers[i];
    if (tier.main == mainHits.length &&
        (tier.bonus == -1 || tier.bonus == bonusHits.length)) {
      rank = i + 1;
      break;
    }
  }
  return TicketResult(mainHits, bonusHits, rank);
}

EntryResult checkEntry(
  GameConfig game,
  List<Ticket> tickets,
  DateTime createdAt,
  List<DrawRecord> draws,
) {
  final draw = firstDrawAfter(game, draws, createdAt);
  if (draw == null) return EntryResult(null, const []);
  return EntryResult(draw, [
    for (final t in tickets) checkTicket(game, t, draw),
  ]);
}
