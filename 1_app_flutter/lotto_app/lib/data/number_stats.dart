// 번호 통계: 최근 N회 동안 번호별 출현 횟수와 마지막 출현 후 지난 회차 수

import '../games/draw_record.dart';

class NumberStat {
  final int number;
  final int count;

  /// 마지막으로 나온 뒤 지난 추첨 수 (0 = 가장 최근 추첨에 나옴, null = 기간 안에 안 나옴)
  final int? gap;

  const NumberStat(this.number, this.count, this.gap);
}

enum StatsSort { number, most, least, gap }

/// [draws] 는 최신순. [window] 가 null 이면 전체.
/// [bonus] 가 true 면 보조 번호(파워볼·럭키스타 등)를 셉니다.
List<NumberStat> numberStats(
  List<DrawRecord> draws, {
  required int max,
  int? window,
  bool bonus = false,
}) {
  final used = window == null || window > draws.length
      ? draws
      : draws.sublist(0, window);
  final counts = List<int>.filled(max + 1, 0);
  final gaps = List<int?>.filled(max + 1, null);
  for (var i = 0; i < used.length; i++) {
    for (final n in bonus ? used[i].bonus : used[i].main) {
      if (n < 1 || n > max) continue;
      counts[n]++;
      gaps[n] ??= i;
    }
  }
  return [for (var n = 1; n <= max; n++) NumberStat(n, counts[n], gaps[n])];
}

List<NumberStat> sortStats(List<NumberStat> stats, StatsSort sort) {
  final list = [...stats];
  int byNumber(NumberStat a, NumberStat b) => a.number.compareTo(b.number);
  switch (sort) {
    case StatsSort.number:
      list.sort(byNumber);
    case StatsSort.most:
      list.sort(
        (a, b) => b.count != a.count ? b.count - a.count : byNumber(a, b),
      );
    case StatsSort.least:
      list.sort(
        (a, b) => a.count != b.count ? a.count - b.count : byNumber(a, b),
      );
    case StatsSort.gap:
      // 오래 안 나온 순 (기간 안에 한 번도 안 나온 번호가 맨 앞)
      list.sort((a, b) {
        final ga = a.gap ?? 1 << 30, gb = b.gap ?? 1 << 30;
        return ga != gb ? gb - ga : byNumber(a, b);
      });
  }
  return list;
}

/// 홀수 개수별 출현 비율 (키: 당첨번호 중 홀수 개수)
Map<int, int> oddCountDistribution(List<DrawRecord> draws, {int? window}) {
  final used = window == null || window > draws.length
      ? draws
      : draws.sublist(0, window);
  final dist = <int, int>{};
  for (final d in used) {
    final odd = d.main.where((n) => n.isOdd).length;
    dist[odd] = (dist[odd] ?? 0) + 1;
  }
  return dist;
}
