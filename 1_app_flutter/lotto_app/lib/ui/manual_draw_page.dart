// 당첨번호 직접 입력 화면 (자동 갱신이 안 될 때)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/manual_draws.dart';
import '../games/draw_record.dart';
import '../games/game_config.dart';
import '../l10n/app_localizations.dart';
import 'app_style.dart';

class ManualDrawPage extends StatefulWidget {
  final GameConfig game;

  /// 공식 데이터 (최신이 앞). 입력 중복 검사·다음 회차 제안에 씁니다.
  final List<DrawRecord> official;

  const ManualDrawPage({super.key, required this.game, required this.official});

  @override
  State<ManualDrawPage> createState() => _ManualDrawPageState();
}

class _ManualDrawPageState extends State<ManualDrawPage> {
  List<DrawRecord> _manual = const [];
  final Set<int> _main = {};
  final Set<int> _bonus = {};
  late DateTime _date;
  final _round = TextEditingController();
  bool _changed = false;

  GameConfig get g => widget.game;
  bool get _isKorea => g.id == 'kr645';
  List<DrawRecord> get _all => mergeDraws(widget.official, _manual);

  @override
  void initState() {
    super.initState();
    _date = suggestedDrawDate(g, widget.official, DateTime.now());
    _load();
  }

  Future<void> _load() async {
    final m = await ManualDrawStore.load(g.id);
    if (!mounted) return;
    setState(() {
      _manual = m;
      _resetForm();
    });
  }

  void _resetForm() {
    _main.clear();
    _bonus.clear();
    _date = suggestedDrawDate(g, _all, DateTime.now());
    _round.text = '${nextDrawNo(_all)}';
  }

  @override
  void dispose() {
    _round.dispose();
    super.dispose();
  }

  String _errorText(AppLocalizations t, ManualDrawError e, String bonusLabel) =>
      switch (e) {
        ManualDrawError.round => t.mErrRound,
        ManualDrawError.mainNumbers => t.mErrMain('${g.main.count}'),
        ManualDrawError.bonusNumbers => t.mErrBonus(
          bonusLabel,
          '${g.bonus.count}',
        ),
        ManualDrawError.bonusOverlap => t.mErrBonusOverlap,
        ManualDrawError.date => t.mErrDate,
        ManualDrawError.exists => t.mErrExists,
      };

  Future<void> _save(AppLocalizations t, String bonusLabel) async {
    final no = _isKorea
        ? (int.tryParse(_round.text.trim()) ?? 0)
        : nextDrawNo(_all);
    final record = DrawRecord(
      no,
      ManualDrawStore.isoDate(_date),
      _main.toList()..sort(),
      _bonus.toList()..sort(),
      manual: true,
    );
    final error = validateManualDraw(g, record, _all, DateTime.now());
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorText(t, error, bonusLabel))));
      return;
    }
    final updated = [record, ..._manual];
    await ManualDrawStore.save(g.id, updated);
    _changed = true;
    if (!mounted) return;
    setState(() {
      _manual = updated..sort((a, b) => b.date.compareTo(a.date));
      _resetForm();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.manualSaved)));
  }

  Future<void> _remove(DrawRecord d) async {
    final updated = [
      for (final m in _manual)
        if (m.date != d.date) m,
    ];
    await ManualDrawStore.save(g.id, updated);
    _changed = true;
    if (mounted) setState(() => _manual = updated);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isAfter(now) ? now : _date,
      firstDate: g.ruleSince ?? DateTime(2000),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _toggle(Set<int> set, int n, int max) {
    setState(() {
      if (set.contains(n)) {
        set.remove(n);
      } else if (set.length < max) {
        set.add(n);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context);
    final bonusLabel =
        g.bonus.label[lang.languageCode] ?? g.bonus.label['en'] ?? '';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        backgroundColor: pageGray,
        appBar: AppBar(
          backgroundColor: brandYellow,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(
            t.manualEntry,
            style: TextStyle(fontFamily: appFont, fontWeight: FontWeight.w500),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        flagOf(g.country),
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          g.displayName(lang.languageCode),
                          style: TextStyle(
                            fontFamily: appFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.manualHelp,
                    style: TextStyle(
                      fontFamily: appFont,
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (_isKorea) ...[
                        SizedBox(
                          width: 110,
                          child: TextField(
                            controller: _round,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: t.manualRound,
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.event_rounded),
                          label: Text(
                            '${t.manualDate}${t.colon}${DateFormat.yMMMEd(lang.toString()).format(_date)}',
                            style: TextStyle(fontFamily: appFont),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _gridTitle(
                    t.manualMain('${g.main.count}'),
                    _main.length,
                    g.main.count,
                  ),
                  _numberGrid(g.main.max, _main, g.main.count, bonus: false),
                  if (g.bonus.count > 0) ...[
                    const SizedBox(height: 14),
                    _gridTitle(
                      t.manualBonus(bonusLabel, '${g.bonus.count}'),
                      _bonus.length,
                      g.bonus.count,
                    ),
                    _numberGrid(
                      g.bonus.max,
                      _bonus,
                      g.bonus.count,
                      bonus: true,
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => _save(t, bonusLabel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandYellowDark,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        t.manualSave,
                        style: TextStyle(
                          fontFamily: appFont,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.manualList,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            if (_manual.isEmpty)
              Text(
                t.manualNone,
                style: TextStyle(fontFamily: appFont, color: Colors.black54),
              )
            else
              for (final d in _manual)
                _card(
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_isKorea ? '${d.no} · ' : ''}${DateFormat.yMMMEd(lang.toString()).format(DateTime.parse(d.date))}',
                              style: TextStyle(
                                fontFamily: appFont,
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TicketRow(d.main, d.bonus, size: 26),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: t.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => _remove(d),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );

  Widget _gridTitle(String label, int chosen, int need) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      '$label  ($chosen/$need)',
      style: TextStyle(
        fontFamily: appFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: chosen == need ? const Color(0xFF07BA0F) : Colors.black87,
      ),
    ),
  );

  Widget _numberGrid(
    int max,
    Set<int> chosen,
    int need, {
    required bool bonus,
  }) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (int n = 1; n <= max; n++)
          GestureDetector(
            onTap: () => _toggle(chosen, n, need),
            child: chosen.contains(n)
                ? LottoBall(n, size: 36, bonus: bonus)
                : Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                    ),
                    child: Text(
                      '$n',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}
