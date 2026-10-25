// 복권별 규칙 정의. assets/games/games.json 과 1:1 로 대응합니다.
// 서버 수집 스크립트(3_db_scripts)도 같은 JSON 을 읽으므로 필드를 바꿀 때 함께 확인하세요.

class NumberPool {
  final int count;
  final int max;

  const NumberPool({required this.count, required this.max});

  factory NumberPool.fromJson(Map<String, dynamic> j) =>
      NumberPool(count: j['count'] as int, max: j['max'] as int);
}

class BonusPool extends NumberPool {
  /// true: 사용자가 직접 고르는 번호 (파워볼, 럭키스타 등)
  /// false: 추첨기만 뽑는 2등용 번호 (한국 보너스, 캐나다 보너스)
  final bool playerPicks;
  final Map<String, String> label;

  const BonusPool({
    required super.count,
    required super.max,
    required this.playerPicks,
    required this.label,
  });

  factory BonusPool.fromJson(Map<String, dynamic> j) => BonusPool(
    count: j['count'] as int,
    max: j['max'] as int,
    playerPicks: j['playerPicks'] as bool,
    label: Map<String, String>.from(j['label'] as Map),
  );
}

/// 당첨 등수 조건. bonus == -1 이면 보조 번호 일치 여부와 무관합니다.
/// 보조 번호를 고르지 않는 복권(한국·캐나다)은 "추첨 보너스 번호가 내 번호에 있는지"를 1/0 으로 셉니다.
class PrizeTier {
  final int main;
  final int bonus;

  const PrizeTier(this.main, this.bonus);

  factory PrizeTier.fromJson(List<dynamic> j) =>
      PrizeTier(j[0] as int, j[1] as int);
}

class GameConfig {
  final String id;
  final Map<String, String> name;
  final String country;
  final NumberPool main;
  final BonusPool bonus;
  final List<String> drawDays;
  final String timezone;

  /// 현재 규칙이 적용된 첫 추첨일. 통계·과거번호 필터는 이 날짜 이후만 씁니다.
  /// null 이면 전체 기간이 같은 규칙입니다.
  final DateTime? ruleSince;

  /// 추첨 시각 (timezone 기준 현지 시각) — 시, 분
  final int drawHour;
  final int drawMinute;

  /// 1등부터 순서대로
  final List<PrizeTier> prizeTiers;

  const GameConfig({
    required this.id,
    required this.name,
    required this.country,
    required this.main,
    required this.bonus,
    required this.drawDays,
    required this.timezone,
    required this.ruleSince,
    this.drawHour = 20,
    this.drawMinute = 0,
    this.prizeTiers = const [],
  });

  factory GameConfig.fromJson(Map<String, dynamic> j) => GameConfig(
    id: j['id'] as String,
    name: Map<String, String>.from(j['name'] as Map),
    country: j['country'] as String,
    main: NumberPool.fromJson(j['main'] as Map<String, dynamic>),
    bonus: BonusPool.fromJson(j['bonus'] as Map<String, dynamic>),
    drawDays: List<String>.from(j['drawDays'] as List),
    timezone: j['timezone'] as String,
    ruleSince: j['ruleSince'] == null
        ? null
        : DateTime.parse(j['ruleSince'] as String),
    drawHour: int.parse(((j['drawTime'] ?? '20:00') as String).split(':')[0]),
    drawMinute: int.parse(((j['drawTime'] ?? '20:00') as String).split(':')[1]),
    prizeTiers: ((j['prizeTiers'] ?? const []) as List)
        .map((e) => PrizeTier.fromJson(e as List))
        .toList(),
  );

  String displayName(String languageCode) =>
      name[languageCode] ?? name['en'] ?? id;

  /// 사용자가 고르는 보조 번호가 있는 복권인지 (파워볼·메가밀리언·유로 복권)
  bool get hasPlayerBonus => bonus.playerPicks;

  /// 1등 당첨 확률의 분모 (모든 조합의 수)
  int get jackpotOddsDenominator {
    final mainCombos = combinations(main.max, main.count);
    return hasPlayerBonus
        ? mainCombos * combinations(bonus.max, bonus.count)
        : mainCombos;
  }
}

List<GameConfig> parseGames(Map<String, dynamic> json) =>
    (json['games'] as List)
        .map((e) => GameConfig.fromJson(e as Map<String, dynamic>))
        .toList();

/// nCk. 복권 규모(n ≤ 90)에서는 int 범위를 넘지 않습니다.
int combinations(int n, int k) {
  if (k < 0 || k > n) return 0;
  if (k > n - k) k = n - k;
  int r = 1;
  for (int i = 1; i <= k; i++) {
    r = r * (n - k + i) ~/ i;
  }
  return r;
}
