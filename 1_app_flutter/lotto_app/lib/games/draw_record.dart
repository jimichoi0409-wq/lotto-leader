// 복권 공통 당첨번호 한 회차.
// 한국 6/45 는 SQLite past_winners, 해외 복권은 assets/draws/<id>.csv 에서 읽습니다.
// 사용자가 직접 입력한 회차는 manual = true 입니다 (lib/data/manual_draws.dart).

class DrawRecord {
  /// 한국은 공식 회차, 해외는 현재 규칙 시작 이후 1부터 매긴 일련번호
  final int no;
  final String date;
  final List<int> main;
  final List<int> bonus;
  final bool manual;

  const DrawRecord(
    this.no,
    this.date,
    this.main,
    this.bonus, {
    this.manual = false,
  });

  Map<String, dynamic> toJson() => {
    'no': no,
    'date': date,
    'main': main,
    'bonus': bonus,
  };

  factory DrawRecord.fromJson(Map<String, dynamic> j, {bool manual = false}) =>
      DrawRecord(
        j['no'] as int,
        j['date'] as String,
        List<int>.from(j['main'] as List),
        List<int>.from(j['bonus'] as List),
        manual: manual,
      );
}

/// collect_draws.py 가 만든 CSV (draw_no,draw_date,main,bonus) → 최신 회차가 앞인 목록
List<DrawRecord> parseDrawCsv(String text) {
  List<int> nums(String s) => s.trim().isEmpty
      ? <int>[]
      : s.trim().split(RegExp(r'\s+')).map(int.parse).toList();

  final records = <DrawRecord>[];
  for (final line in text.split('\n').skip(1)) {
    final cols = line.trim().split(',');
    if (cols.length < 4) continue;
    records.add(
      DrawRecord(int.parse(cols[0]), cols[1], nums(cols[2]), nums(cols[3])),
    );
  }
  return records.reversed.toList();
}

/// 한국 6/45 원본 CSV (회차,추첨일,번호1~6,보너스 · 최신 회차가 위) → 최신 회차가 앞인 목록
List<DrawRecord> parseKoreanCsv(String text) {
  final records = <DrawRecord>[];
  for (final line in text.split('\n').skip(1)) {
    final c = line.trim().split(',');
    if (c.length < 9) continue;
    final no = int.tryParse(c[0]);
    final nums = [for (int i = 2; i < 8; i++) int.tryParse(c[i])];
    final bonus = int.tryParse(c[8]);
    if (no == null || nums.contains(null)) continue;
    records.add(DrawRecord(no, c[1], nums.cast<int>()..sort(), [?bonus]));
  }
  records.sort((a, b) => b.no.compareTo(a.no));
  return records;
}
