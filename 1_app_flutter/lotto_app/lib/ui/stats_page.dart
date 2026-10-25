// 번호 통계: 복권별 번호 출현 횟수, 오래 안 나온 번호, 홀짝 비율

import 'package:flutter/material.dart';

import '../data/number_stats.dart';
import '../games/draw_record.dart';
import '../games/game_config.dart';
import '../l10n/app_localizations.dart';
import 'app_style.dart';

class StatsPage extends StatefulWidget {
  final GameConfig game;

  /// 최신순 당첨번호 (공식 + 직접 입력)
  final List<DrawRecord> draws;

  const StatsPage({super.key, required this.game, required this.draws});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  static const _windows = <int?>[10, 50, 100, null];

  int? _window = 50;
  bool _bonus = false;
  StatsSort _sort = StatsSort.most;

  GameConfig get g => widget.game;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final draws = widget.draws;
    final analyzed = _window == null || _window! > draws.length
        ? draws.length
        : _window!;
    final stats = numberStats(
      draws,
      max: _bonus ? g.bonus.max : g.main.max,
      window: _window,
      bonus: _bonus,
    );
    final sorted = sortStats(stats, _sort);
    final maxCount = stats.fold<int>(0, (m, s) => s.count > m ? s.count : m);
    final pickCount = _bonus ? g.bonus.count : g.main.count;
    final hot = sortStats(stats, StatsSort.most).take(pickCount).toList();
    final cold = sortStats(stats, StatsSort.gap).take(pickCount).toList();

    return Scaffold(
      backgroundColor: pageGray,
      appBar: AppBar(
        backgroundColor: brandYellow,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '${flagOf(g.country)}  ${t.statsTitle}',
          style: TextStyle(fontFamily: appFont, fontWeight: FontWeight.w500),
        ),
      ),
      body: draws.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.noDrawData,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: appFont, height: 1.6),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Text(
                  g.displayName(lang),
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _chips<int?>(
                  _windows,
                  _window,
                  (w) => w == null ? t.statsAll : t.statsRecent('$w'),
                  (w) => setState(() => _window = w),
                ),
                if (g.hasPlayerBonus) ...[
                  const SizedBox(height: 6),
                  _chips<bool>(
                    const [false, true],
                    _bonus,
                    (b) => b
                        ? (g.bonus.label[lang] ?? g.bonus.label['en'] ?? '')
                        : t.statsMain,
                    (b) => setState(() => _bonus = b),
                  ),
                ],
                const SizedBox(height: 12),
                _card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.statsAnalyzed(analyzed), style: _small()),
                      const SizedBox(height: 10),
                      _ballLine(t.statsHot, hot),
                      const SizedBox(height: 8),
                      _ballLine(t.statsCold, cold),
                    ],
                  ),
                ),
                if (!_bonus) ...[
                  const SizedBox(height: 10),
                  _card(_oddEven(t, analyzed)),
                ],
                const SizedBox(height: 14),
                _chips<StatsSort>(
                  StatsSort.values,
                  _sort,
                  (s) => switch (s) {
                    StatsSort.number => t.statsSortNumber,
                    StatsSort.most => t.statsSortMost,
                    StatsSort.least => t.statsSortLeast,
                    StatsSort.gap => t.statsSortGap,
                  },
                  (s) => setState(() => _sort = s),
                ),
                const SizedBox(height: 8),
                _card(
                  Column(
                    children: [for (final s in sorted) _row(t, s, maxCount)],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.statsDisclaimer,
                  textAlign: TextAlign.center,
                  style: _small(),
                ),
              ],
            ),
    );
  }

  TextStyle _small() => TextStyle(
    fontFamily: appFont,
    fontSize: 12,
    height: 1.5,
    color: Colors.black54,
  );

  Widget _card(Widget child, {EdgeInsets? padding}) => Container(
    padding: padding ?? const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );

  Widget _chips<T>(
    List<T> values,
    T selected,
    String Function(T) label,
    ValueChanged<T> onSelected,
  ) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final v in values)
        ChoiceChip(
          label: Text(label(v), style: TextStyle(fontFamily: appFont)),
          selected: v == selected,
          selectedColor: brandYellow,
          showCheckmark: false,
          onSelected: (_) => onSelected(v),
        ),
    ],
  );

  Widget _ballLine(String title, List<NumberStat> stats) => Row(
    children: [
      SizedBox(
        width: 110,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                for (final s in stats) ...[
                  LottoBall(s.number, size: 30, bonus: _bonus),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _oddEven(AppLocalizations t, int analyzed) {
    final dist = oddCountDistribution(widget.draws, window: _window);
    final k = g.main.count;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.statsOddEven,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        for (var odd = k; odd >= 0; odd--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    t.statsOddLabel('$odd', '${k - odd}'),
                    style: TextStyle(fontFamily: appFont, fontSize: 12),
                  ),
                ),
                Expanded(child: _bar((dist[odd] ?? 0) / analyzed)),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${((dist[odd] ?? 0) * 100 / analyzed).round()}%',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: appFont, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _bar(double ratio) => ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: LinearProgressIndicator(
      value: ratio.clamp(0, 1).toDouble(),
      minHeight: 10,
      backgroundColor: const Color(0xFFF0F0F0),
      color: const Color(0xFFFA7A2C),
    ),
  );

  Widget _row(AppLocalizations t, NumberStat s, int maxCount) {
    final gap = s.gap == null
        ? t.statsGapNever
        : s.gap == 0
        ? t.statsGapLatest
        : t.statsGap(s.gap!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          LottoBall(s.number, size: 30, bonus: _bonus),
          const SizedBox(width: 10),
          Expanded(child: _bar(maxCount == 0 ? 0 : s.count / maxCount)),
          SizedBox(
            width: 52,
            child: Text(
              t.statsCount('${s.count}'),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 104,
            child: Text(gap, textAlign: TextAlign.right, style: _small()),
          ),
        ],
      ),
    );
  }
}
