// 내 기록: 가입 정보와 지금까지 추출한 번호 조합 (최신순), 추첨 후에는 당첨 여부까지

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:share_plus/share_plus.dart';

import '../data/user_store.dart';
import '../data/win_check.dart';
import '../games/draw_record.dart';
import '../games/game_config.dart';
import '../l10n/app_localizations.dart';
import 'app_style.dart';

class HistoryPage extends StatefulWidget {
  final List<GameConfig> games;

  /// 복권 id → 당첨번호 (공식 + 직접 입력)
  final Map<String, List<DrawRecord>> draws;

  const HistoryPage({super.key, required this.games, this.draws = const {}});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  UserProfile? _profile;
  List<HistoryEntry>? _entries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await UserStore.profile();
    final h = await UserStore.history();
    if (mounted) {
      setState(() {
        _profile = p;
        _entries = h;
      });
    }
  }

  GameConfig? _game(String id) {
    for (final g in widget.games) {
      if (g.id == id) return g;
    }
    return null;
  }

  String _ticketsText(List<HistoryEntry> entries) => [
    for (final e in entries)
      for (final t in e.tickets) t.toString(),
  ].join('\n');

  Future<void> _clearAll(AppLocalizations t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(
          t.historyClearConfirm,
          style: TextStyle(fontFamily: appFont),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await UserStore.clearHistory();
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).toString();
    final entries = _entries;

    return Scaffold(
      backgroundColor: pageGray,
      appBar: AppBar(
        backgroundColor: brandYellow,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          t.menuHistory,
          style: TextStyle(fontFamily: appFont, fontWeight: FontWeight.w500),
        ),
        actions: [
          if (entries != null && entries.isNotEmpty)
            IconButton(
              tooltip: t.historyClearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _clearAll(t),
            ),
        ],
      ),
      body: entries == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _profileCard(t, lang, entries.length),
                const SizedBox(height: 16),
                if (entries.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Text(
                      t.historyEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: appFont,
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black54,
                      ),
                    ),
                  )
                else
                  for (final e in entries) _entryCard(t, lang, e),
              ],
            ),
    );
  }

  Widget _note(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: appFont,
          fontSize: 12,
          height: 1.5,
          color: Colors.black54,
        ),
      ),
    ),
  );

  Widget _statusChip(String text, Color color, {bool highlight = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFFFF3E0) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 12,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
      );

  /// "4개 일치 · 4등" / "3+1 일치 · 낙첨" 등
  Widget _ticketLabel(AppLocalizations t, GameConfig g, TicketResult r) {
    final m = '${r.mainHits.length}';
    final match = g.hasPlayerBonus
        ? t.winMatchPlus(m, '${r.bonusHits.length}')
        : r.bonusHits.isNotEmpty
        ? t.winMatchBonus(m)
        : t.winMatch(m);
    final won = r.rank > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          won ? t.winRank('${r.rank}') : t.winNone,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 13,
            fontWeight: won ? FontWeight.w700 : FontWeight.w500,
            color: won ? const Color(0xFFD84315) : Colors.black45,
          ),
        ),
        Text(
          match,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _profileCard(AppLocalizations t, String lang, int count) {
    final p = _profile;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: brandYellow,
            child: Icon(Icons.person_rounded, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p?.nickname ?? '-',
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (p != null)
                      t.historyJoined(
                        DateFormat.yMMMd(lang).format(p.createdAt),
                      ),
                    t.historyStats(count),
                  ].join(' · '),
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryCard(AppLocalizations t, String lang, HistoryEntry e) {
    final g = _game(e.gameId);
    final name =
        g?.displayName(Localizations.localeOf(context).languageCode) ??
        e.gameId;
    final when = DateFormat.yMMMd(lang).add_Hm().format(e.createdAt);
    final result = g == null
        ? null
        : checkEntry(g, e.tickets, e.createdAt, widget.draws[g.id] ?? const []);
    final draw = result?.draw;
    final best = result?.bestRank ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        shape: const Border(),
        leading: Text(
          flagOf(g?.country ?? ''),
          style: const TextStyle(fontSize: 26),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$when · ${t.historyTickets(e.tickets.length)}'
              '${e.filterCount > 0 ? ' · ${t.historyFilters(e.filterCount)}' : ''}',
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: 4),
              _statusChip(
                draw == null
                    ? t.winPending
                    : best == 0
                    ? t.winNone
                    : t.winBest(t.winRank('$best')),
                draw == null
                    ? Colors.black45
                    : best == 0
                    ? Colors.black54
                    : const Color(0xFFD84315),
                highlight: best > 0,
              ),
            ],
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        children: [
          if (result != null && draw == null)
            _note(t.winPendingHint)
          else if (draw != null) ...[
            _note(
              '${t.winDrawOf(DateFormat.yMMMd(lang).format(DateTime.parse(draw.date)))}'
              '${draw.manual ? ' · ${t.manualTag}' : ''}',
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TicketRow(draw.main, draw.bonus, size: 24),
            ),
            const Divider(height: 8),
          ],
          for (final (i, ticket) in e.tickets.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: draw == null
                  ? TicketRow(ticket.main, ticket.bonus, size: 26)
                  : Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TicketRow(
                              ticket.main,
                              ticket.bonus,
                              size: 24,
                              mainHits: result!.tickets[i].mainHits,
                              bonusHits: result.tickets[i].bonusHits,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _ticketLabel(t, g!, result.tickets[i]),
                      ],
                    ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: t.copyButton,
                icon: const Icon(Icons.copy_rounded, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _ticketsText([e])));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(t.copied)));
                },
              ),
              IconButton(
                tooltip: t.shareButton,
                icon: const Icon(Icons.share_rounded, size: 20),
                onPressed: () => SharePlus.instance.share(
                  ShareParams(
                    text: '${t.shareHeader(name)}\n${_ticketsText([e])}',
                    subject: t.shareSubject,
                  ),
                ),
              ),
              IconButton(
                tooltip: t.delete,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                onPressed: () async {
                  await UserStore.removeHistory(e.id);
                  await _load();
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.historyDeleted)));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
