import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'ads/ad_config.dart';
import 'ads/ad_manager.dart';
import 'ads/banner_ad_view.dart';
import 'data/backup.dart';
import 'data/draw_alarm.dart';
import 'data/draw_sync.dart';
import 'data/filter_store.dart';
import 'data/manual_draws.dart';
import 'data/user_store.dart';
import 'engine/combination_engine.dart';
import 'engine/filter_options.dart';
import 'games/draw_record.dart';
import 'games/game_config.dart';
import 'l10n/app_localizations.dart';
import 'ui/app_style.dart';
import 'ui/history_page.dart';
import 'ui/manual_draw_page.dart';
import 'ui/onboarding_page.dart';
import 'ui/stats_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 저장된 언어와 가입 여부를 먼저 읽어, 첫 화면부터 올바른 언어로 보여 줍니다.
  String? language;
  var hasProfile = false;
  try {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString(_LottoAppState.prefKey);
    hasProfile = prefs.getString('userProfile') != null;
  } catch (e) {
    debugPrint('저장된 설정 읽기 실패: $e');
  }
  runApp(LottoApp(initialLanguage: language, hasProfile: hasProfile));
}

/// 앱 최상위.
/// - 처음 실행: 언어 선택 → 간단 가입 (OnboardingPage). 고른 언어는 저장되어 다음부터 묻지 않습니다.
/// - 이후 실행: 저장된 언어로 바로 메인 화면.
class LottoApp extends StatefulWidget {
  final String? initialLanguage;
  final bool hasProfile;

  const LottoApp({super.key, this.initialLanguage, this.hasProfile = false});

  /// null = 기기 언어 따르기
  static void setLocale(BuildContext context, Locale? locale) =>
      context.findAncestorStateOfType<_LottoAppState>()?._setLocale(locale);

  static Locale? localeOverride(BuildContext context) =>
      context.findAncestorStateOfType<_LottoAppState>()?._locale;

  /// 탈퇴 후 처음 화면(간단 가입)으로
  static void showOnboarding(BuildContext context) =>
      context.findAncestorStateOfType<_LottoAppState>()?._showOnboarding();

  @override
  State<LottoApp> createState() => _LottoAppState();
}

class _LottoAppState extends State<LottoApp> {
  static const prefKey = 'languageCode';
  late Locale? _locale = widget.initialLanguage == null
      ? null
      : Locale(widget.initialLanguage!);
  late bool _hasProfile = widget.hasProfile;

  void _showOnboarding() => setState(() => _hasProfile = false);

  Future<void> _setLocale(Locale? locale) async {
    setState(() => _locale = locale);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(prefKey);
      } else {
        await prefs.setString(prefKey, locale.languageCode);
      }
    } catch (e) {
      debugPrint('언어 설정 저장 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (device, supported) {
        for (final s in supported) {
          if (s.languageCode == device?.languageCode) return s;
        }
        return const Locale('en');
      },
      // 입력칸·버튼·안내 메시지 등 기본 위젯도 언어에 맞는 글꼴을 쓰도록 (한국어는 이사만루)
      builder: (context, child) {
        final ko = Localizations.localeOf(context).languageCode == 'ko';
        return Theme(
          data: ThemeData(fontFamily: ko ? 'Esamanru' : null),
          child: child!,
        );
      },
      home: _hasProfile
          ? const LottoFilterPage()
          : Builder(
              builder: (context) => OnboardingPage(
                currentLanguage: Localizations.localeOf(context).languageCode,
                onLanguageChosen: (code) => _setLocale(Locale(code)),
                onFinished: () => setState(() => _hasProfile = true),
              ),
            ),
    );
  }
}

class CountUpNumber extends StatefulWidget {
  final int value;
  final TextStyle style;
  final bool isMinus;

  const CountUpNumber({
    super.key,
    required this.value,
    required this.style,
    this.isMinus = false,
  });

  @override
  State<CountUpNumber> createState() => _CountUpNumberState();
}

class _CountUpNumberState extends State<CountUpNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _prevValue = 0;

  @override
  void initState() {
    super.initState();
    _prevValue = widget.value.toDouble();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: _prevValue,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CountUpNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _prevValue = _animation.value;
      _animation =
          Tween<double>(
            begin: _prevValue,
            end: widget.value.toDouble(),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
          );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatCommas(int val) => NumberFormat.decimalPattern(
    Localizations.localeOf(context).toString(),
  ).format(val);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentVal = _animation.value.toInt();
        final formatted = _formatCommas(currentVal);

        return Text(
          '${widget.isMinus && currentVal > 0 ? "- " : ""}$formatted',
          style: widget.style,
        );
      },
    );
  }
}

class CountUpPercent extends StatefulWidget {
  final double value;
  final TextStyle style;

  const CountUpPercent({super.key, required this.value, required this.style});

  @override
  State<CountUpPercent> createState() => _CountUpPercentState();
}

class _CountUpPercentState extends State<CountUpPercent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _prevValue = 0.0;

  @override
  void initState() {
    super.initState();

    _prevValue = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: _prevValue,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CountUpPercent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _prevValue = _animation.value;
      _animation = Tween<double>(begin: _prevValue, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final format = NumberFormat(
          '0.000',
          Localizations.localeOf(context).toString(),
        );
        final symbols = format.symbols;
        final parts = format
            .format(_animation.value)
            .split(symbols.DECIMAL_SEP);

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(parts[0], style: widget.style),
            Text(
              '${symbols.DECIMAL_SEP}${parts[1]}',
              style: widget.style.copyWith(
                fontSize: widget.style.fontSize! * 0.75,
              ),
            ),
            Text(
              '%',
              style: widget.style.copyWith(
                fontSize: widget.style.fontSize! * 0.75,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CornerBoxPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final Color fillColor;

  const _CornerBoxPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(5)),
      fillPaint,
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final l = cornerLength;

    canvas.drawLine(const Offset(0, 0), Offset(l, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, l), paint);
    canvas.drawLine(Offset(w, 0), Offset(w - l, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, l), paint);
    canvas.drawLine(Offset(0, h), Offset(l, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - l), paint);
    canvas.drawLine(Offset(w, h), Offset(w - l, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - l), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBoxPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.fillColor != fillColor;
  }
}

class LottoFilterPage extends StatefulWidget {
  const LottoFilterPage({super.key});

  @override
  State<LottoFilterPage> createState() => _LottoFilterPageState();
}

class _LottoFilterPageState extends State<LottoFilterPage>
    with WidgetsBindingObserver {
  static const String _logoAssetPath = 'assets/images/app_logo.png';
  // pubspec.yaml 의 version 과 같게 유지 (test/version_test.dart 가 확인)
  static const String _appVersion = 'V1.0.0';
  AppLocalizations get t => AppLocalizations.of(context);
  String get _lang => Localizations.localeOf(context).languageCode;

  /// 추첨일 알림을 마지막으로 등록한 언어 (언어가 바뀌면 알림 문구를 다시 등록)
  String? _alarmLang;

  Future<List<DrawRecord>> _loadDrawsForViewer() async =>
      _drawsOf(_activeGame.id);

  void _refreshCurrentCalculation() {
    _countCache.clear();
    FilterStore.clear(_activeGame.id);
    _resetFilterInputs();
    _showSnack(t.resetDone);
  }

  /// 필터·입력값·결과를 처음 상태로 되돌립니다 (복권을 바꿀 때도 사용).
  void _resetFilterInputs() {
    FocusScope.of(context).unfocus();
    _debounce?.cancel();
    _activeQueryId++;

    for (final c in _incControllers) {
      c.clear();
    }
    for (final c in _excControllers) {
      c.clear();
    }
    for (final c in [..._bonusIncControllers, ..._bonusExcControllers]) {
      c.clear();
    }

    setState(() {
      _recentDrawsController.clear();
      _extractCountController.clear();
      _leastFreqNums.clear();
      _mostFreqNums.clear();

      _exc1st = false;
      _exc2nd3rd = false;
      _exc4thSeq = false;
      _exc5thSeq = false;
      _exc3Consec = false;
      _excSkip1 = false;
      _excSkip2 = false;
      _excSkip3 = false;
      _exc2Pairs = false;
      _exc10Range = false;
      _excAllOdd = false;
      _excAllEven = false;
      _excOE1 = false;
      _excOE2 = false;
      _excOE3 = false;
      _excOE4 = false;
      _excOE5 = false;
      _excSameLastDigit3 = false;
      _excTripleMultiple = false;
      _excSum = false;
      _excBirthday = false;
      _excLowHigh = false;
      _excDecade4 = false;
      _excRepeatLast = false;
      _bonusExcRecent = false;
      _bonusExcConsec = false;
      _bonusExcParity = false;

      _targetRemaining = _totalCombinations;
      _targetMainRemaining = combinations(_mainMax, _mainCount);
      _targetExcluded = 0;
      _targetPercent = 0.000;
      _isCalculating = false;
      _isExtracting = false;
    });
  }

  void _showWinningNumberDialog() {
    if (!_isDbReady) {
      _showSnack(t.dbLoading);
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: t.close,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FutureBuilder<List<DrawRecord>>(
          future: _loadDrawsForViewer(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Material(
                  color: Colors.transparent,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final rows = snapshot.data ?? [];
            if (rows.isEmpty) {
              return _buildSimplePopup(
                title: t.menuResults,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.noResultsStored,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: appFont, fontSize: 15),
                      ),
                      _manualEntryButton(context),
                    ],
                  ),
                ),
              );
            }

            int currentIndex = 0;
            return StatefulBuilder(
              builder: (context, dialogSetState) {
                final row = rows[currentIndex];
                final round = row.no;
                final date = row.date;
                final nums = row.main;
                final bonus = row.bonus;

                return Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.78,
                      constraints: const BoxConstraints(maxWidth: 430),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _brandYellow, width: 3),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  16,
                                  10,
                                  13,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE9D52B),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: currentIndex < rows.length - 1
                                          ? () => dialogSetState(
                                              () => currentIndex++,
                                            )
                                          : null,
                                      icon: const Icon(
                                        Icons.chevron_left,
                                        size: 32,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text.rich(
                                              TextSpan(
                                                children: _isKorea
                                                    ? [
                                                        TextSpan(
                                                          text:
                                                              '${flagOf(_activeGame.country)} ',
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              t.drawRoundPrefix,
                                                        ),
                                                        TextSpan(
                                                          text: '$round',
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xFF0286D8,
                                                                ),
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              t.drawRoundSuffix,
                                                        ),
                                                      ]
                                                    : [
                                                        TextSpan(
                                                          text:
                                                              '${flagOf(_activeGame.country)} ',
                                                        ),
                                                        TextSpan(
                                                          text: t
                                                              .drawResultPrefix,
                                                        ),
                                                        TextSpan(
                                                          text: _activeGame
                                                              .displayName(
                                                                _lang,
                                                              ),
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xFF0286D8,
                                                                ),
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: t
                                                              .drawResultSuffix,
                                                        ),
                                                      ],
                                              ),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: appFont,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF282727),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            (date.isEmpty
                                                    ? t.noDrawDate
                                                    : t.drawDate(date)) +
                                                (row.manual
                                                    ? ' · ${t.manualTag}'
                                                    : ''),
                                            style: TextStyle(
                                              fontFamily: appFont,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: currentIndex > 0
                                          ? () => dialogSetState(
                                              () => currentIndex--,
                                            )
                                          : null,
                                      icon: const Icon(
                                        Icons.chevron_right,
                                        size: 32,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  18,
                                  12,
                                  22,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...nums.map(
                                        (n) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          child: _buildLargeLottoBall(n),
                                        ),
                                      ),
                                      if (bonus.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                              fontFamily: appFont,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF555555),
                                            ),
                                          ),
                                        ),
                                      for (final b in bonus)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          child: _activeGame.hasPlayerBonus
                                              ? _buildBonusBall(
                                                  b,
                                                  size: 36,
                                                  fontSize: 16,
                                                )
                                              : _buildLargeLottoBall(b),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 4,
                                children: [
                                  _statsButton(context),
                                  _manualEntryButton(context),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            right: -18,
                            top: -18,
                            child: _buildPopupCloseButton(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  /// "토 20:35" 처럼 추첨 요일과 현지 시각
  String _drawScheduleText(GameConfig g) {
    const codes = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final fmt = DateFormat.E(Localizations.localeOf(context).toString());
    // 2024-01-01 은 월요일
    final days = [
      for (final c in g.drawDays)
        if (codes.contains(c))
          fmt.format(DateTime(2024, 1, 1 + codes.indexOf(c))),
    ].join(', ');
    final hh = g.drawHour.toString().padLeft(2, '0');
    final mm = g.drawMinute.toString().padLeft(2, '0');
    return t.alarmDrawAt(days, '$hh:$mm');
  }

  Future<void> _showAlarmDialog() async {
    final enabled = await DrawAlarm.enabledGames();
    if (!mounted) return;
    final busy = <String>{};
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: t.close,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            Future<void> toggle(GameConfig g, bool on) async {
              final messenger = ScaffoldMessenger.of(this.context);
              if (!DrawAlarm.supported) {
                messenger.showSnackBar(
                  SnackBar(content: Text(t.alarmUnsupported)),
                );
                return;
              }
              dialogSetState(() => busy.add(g.id));
              final name = g.displayName(_lang);
              var ok = false;
              try {
                ok = await DrawAlarm.setEnabled(
                  g,
                  on,
                  title: t.notifyTitle(name),
                  body: t.notifyBody,
                  channelName: t.notifyChannel,
                );
              } catch (e) {
                debugPrint('알림 설정 실패: $e');
              }
              if (!mounted) return;
              dialogSetState(() {
                busy.remove(g.id);
                if (ok) on ? enabled.add(g.id) : enabled.remove(g.id);
              });
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    !ok
                        ? t.alarmDenied
                        : on
                        ? t.alarmOn(name)
                        : t.alarmOff(name),
                  ),
                ),
              );
            }

            return _buildSimplePopup(
              title: t.menuAlarm,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: Text(
                        DrawAlarm.supported ? t.alarmIntro : t.alarmUnsupported,
                        style: TextStyle(
                          fontFamily: appFont,
                          fontSize: 13,
                          height: 1.5,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    for (final g in _games)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              flagOf(g.country),
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g.displayName(_lang),
                                    style: TextStyle(
                                      fontFamily: appFont,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    _drawScheduleText(g),
                                    style: TextStyle(
                                      fontFamily: appFont,
                                      fontSize: 11,
                                      color: const Color(0xFF888888),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            busy.contains(g.id)
                                ? const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: enabled.contains(g.id),
                                      activeThumbColor: Colors.green,
                                      activeTrackColor: Colors.green.withValues(
                                        alpha: 0.35,
                                      ),
                                      onChanged: (v) => toggle(g, v),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  void _showSettingsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: t.close,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _buildSimplePopup(
          title: t.menuSettings,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_profile != null)
                  _buildSettingsItem(t.profileNickname(_profile!.nickname), () {
                    Navigator.of(context).pop();
                    _openHistory();
                  }),
                _buildSettingsItem(t.statsTitle, () {
                  Navigator.of(context).pop();
                  _openStats();
                }),
                _buildSettingsItem(t.manualEntry, () {
                  Navigator.of(context).pop();
                  _openManualEntry();
                }),
                _buildSettingsItem(
                  '${t.language}${t.colon}${languageFlags[LottoApp.localeOverride(context)?.languageCode] ?? '📱'} ${_languageName(LottoApp.localeOverride(context))}',
                  () {
                    Navigator.of(context).pop();
                    _showLanguagePicker();
                  },
                ),
                _buildSettingsItem(
                  t.privacyPolicy,
                  () => _showPolicyText(t.privacyPolicy, t.privacyText),
                ),
                if (AdManager.instance.privacyOptionsRequired.value)
                  _buildSettingsItem(t.adPrivacyOptions, () {
                    Navigator.of(context).pop();
                    AdManager.instance.showPrivacyOptions();
                  }),
                _buildSettingsItem(
                  t.disclaimer,
                  () => _showPolicyText(t.disclaimer, t.disclaimerText),
                ),
                _buildSettingsItem(
                  t.contact,
                  () => _showPolicyText(t.contact, t.contactText),
                ),
                _buildSettingsItem(t.backupExport, () {
                  Navigator.of(context).pop();
                  _exportBackup();
                }),
                _buildSettingsItem(t.backupImport, () {
                  Navigator.of(context).pop();
                  _importBackup();
                }),
                _buildSettingsItem(t.withdraw, () {
                  Navigator.of(context).pop();
                  _confirmWithdraw();
                }),
                _buildSettingsItem(
                  '${t.versionLabel}${t.colon}$_appVersion',
                  () => _showPolicyText(
                    t.versionLabel,
                    t.currentVersion(_appVersion),
                  ),
                  highlightVersion: true,
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  String _languageName(Locale? locale) => locale == null
      ? t.languageSystem
      : (languageNames[locale.languageCode] ?? locale.languageCode);

  void _showLanguagePicker() {
    final current = LottoApp.localeOverride(context)?.languageCode;
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        backgroundColor: _boxWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _brandYellow, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            const Icon(Icons.language_rounded, color: Color(0xFF282727)),
            const SizedBox(width: 8),
            Text(
              t.language,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
        children: [
          for (final code in [null, ...languageNames.keys])
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                LottoApp.setLocale(context, code == null ? null : Locale(code));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: code == current
                      ? const Color(0xFFFEF6BD)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    LanguageFlag(code, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        code == null ? t.languageSystem : languageNames[code]!,
                        style: TextStyle(
                          fontFamily: code == null
                              ? appFont
                              : languageNameFont(code),
                          fontSize: 17,
                          fontWeight: code == current
                              ? FontWeight.w500
                              : FontWeight.w300,
                        ),
                      ),
                    ),
                    if (code == current)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF07BA0F),
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 당첨번호 팝업 아래 "당첨번호 직접 입력" 버튼
  Widget _manualEntryButton(BuildContext dialogContext) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextButton.icon(
      onPressed: () {
        Navigator.of(dialogContext).pop();
        _openManualEntry();
      },
      icon: const Icon(Icons.edit_note_rounded),
      label: Text(t.manualEntry, style: TextStyle(fontFamily: appFont)),
    ),
  );

  Widget _statsButton(BuildContext dialogContext) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextButton.icon(
      onPressed: () {
        Navigator.of(dialogContext).pop();
        _openStats();
      },
      icon: const Icon(Icons.bar_chart_rounded),
      label: Text(t.statsTitle, style: TextStyle(fontFamily: appFont)),
    ),
  );

  void _openStats() {
    final game = _activeGame;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StatsPage(game: game, draws: _drawsOf(game.id)),
      ),
    );
  }

  Future<void> _openManualEntry() async {
    final game = _activeGame;
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ManualDrawPage(
          game: game,
          official: _officialDraws[game.id] ?? const [],
        ),
      ),
    );
    if (changed != true || !mounted) return;
    _manualDraws[game.id] = await ManualDrawStore.load(game.id);
    if (!mounted) return;
    setState(() {});
    _onFilterChanged();
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryPage(
          games: _games,
          draws: {for (final g in _games) g.id: _drawsOf(g.id)},
        ),
      ),
    );
  }

  /// 가입 정보·기록·직접 입력 당첨번호·필터를 JSON 파일로 만들어 공유 시트로 보냅니다.
  Future<void> _exportBackup() async {
    try {
      final data = await BackupStore.collect(_games);
      if (data.history.isEmpty && data.manualCount == 0) {
        _showSnack(t.backupEmpty);
        return;
      }
      final now = DateTime.now();
      final stamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final name = 'lotto_leader_backup_$stamp.json';
      final bytes = utf8.encode(encodeBackup(data, now: now));
      final XFile file;
      if (kIsWeb) {
        file = XFile.fromData(bytes, name: name, mimeType: 'application/json');
      } else {
        final dir = await getTemporaryDirectory();
        final path = p.join(dir.path, name);
        await File(path).writeAsBytes(bytes, flush: true);
        file = XFile(path, name: name, mimeType: 'application/json');
      }
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          text: t.backupShareText,
          subject: name,
          fileNameOverrides: [name],
        ),
      );
    } catch (e) {
      debugPrint('백업 실패: $e');
      if (mounted) _showSnack(t.backupFailed);
    }
  }

  /// 백업 파일을 골라 지금 기록과 합칩니다.
  Future<void> _importBackup() async {
    final PlatformFile? picked;
    try {
      picked = await FilePicker.pickFile(dialogTitle: t.backupImport);
    } catch (e) {
      debugPrint('파일 선택 실패: $e');
      _showSnack(t.backupInvalid);
      return;
    }
    if (picked == null || !mounted) return;

    final BackupData backup;
    try {
      final size = picked.lengthSync() ?? await picked.length() ?? 0;
      if (size > backupMaxBytes) {
        _showSnack(t.backupTooLarge);
        return;
      }
      final text = utf8.decode(await picked.readAsBytes());
      backup = decodeBackup(text, _games);
    } catch (e) {
      debugPrint('백업 읽기 실패: $e');
      if (mounted) _showSnack(t.backupInvalid);
      return;
    }
    if (!mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(
          t.backupImportConfirm,
          style: TextStyle(fontFamily: appFont, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(t.continueButton),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      final summary = await BackupStore.restore(backup, _games);
      _profile = await UserStore.profile();
      for (final g in _games) {
        _manualDraws[g.id] = await ManualDrawStore.load(g.id);
      }
      if (!mounted) return;
      _countCache.clear();
      await _restoreFilters(_activeGame.id);
      if (!mounted) return;
      setState(() {});
      _onFilterChanged();
      _showSnack(
        t.backupImportDone('${summary.historyAdded}', '${summary.manualAdded}'),
      );
    } catch (e) {
      debugPrint('복원 실패: $e');
      if (mounted) _showSnack(t.backupInvalid);
    }
  }

  Future<void> _confirmWithdraw() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(t.withdrawConfirm, style: TextStyle(fontFamily: appFont)),
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
    if (ok != true || !mounted) return;
    await UserStore.deleteAccount();
    if (DrawAlarm.supported) {
      await DrawAlarm.clearAll().catchError((Object e) {
        debugPrint('알림 해제 실패: $e');
      });
    }
    if (mounted) LottoApp.showOnboarding(context);
  }

  Widget _buildSettingsItem(
    String title,
    VoidCallback onTap, {
    bool highlightVersion = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        child: Align(
          alignment: Alignment.centerLeft,
          child: highlightVersion
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${t.versionLabel}${t.colon}'),
                      TextSpan(
                        text: _appVersion,
                        style: const TextStyle(color: Color(0xFF3BA316)),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF444444),
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF444444),
                  ),
                ),
        ),
      ),
    );
  }

  void _showPolicyText(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _boxWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _brandYellow, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF282727),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(
              fontFamily: appFont,
              fontSize: 15,
              fontWeight: FontWeight.w300,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.close,
              style: TextStyle(fontFamily: appFont, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimplePopup({required String title, required Widget child}) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.78,
          // 작은 화면에서는 내용이 화면을 넘지 않고 안쪽에서 스크롤
          constraints: BoxConstraints(
            maxWidth: 430,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _brandYellow, width: 3),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9D52B),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: appFont,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF282727),
                      ),
                    ),
                  ),
                  Flexible(child: SingleChildScrollView(child: child)),
                ],
              ),
              Positioned(right: -18, top: -18, child: _buildPopupCloseButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupCloseButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(Icons.close, size: 30, color: Colors.grey),
      ),
    );
  }

  Widget _buildLargeLottoBall(int num) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _lottoBallColor(num),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$num',
        style: TextStyle(
          fontFamily: appFont,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  Color _lottoBallColor(int num) {
    if (num <= 10) return const Color(0xFFFFC107);
    if (num <= 20) return const Color(0xFF29B6F6);
    if (num <= 30) return const Color(0xFFFF3BA7);
    if (num <= 40) return const Color(0xFFBDBDBD);
    if (num <= 50) return const Color(0xFF21F10E);
    return const Color(0xFFB39DDB);
  }

  /// 보조 번호(파워볼·메가볼·럭키스타 등) 공: 흰 바탕에 빨간 테두리로 메인 번호와 구분
  Widget _buildBonusBall(int num, {double size = 28, double fontSize = 12}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE53935), width: 2.4),
      ),
      alignment: Alignment.center,
      child: Text(
        '$num',
        style: TextStyle(
          fontFamily: appFont,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          color: const Color(0xFFE53935),
        ),
      ),
    );
  }

  /// 추출 결과 한 줄: 메인 번호 + (있으면) 보조 번호
  Widget _buildTicketRow(Ticket ticket) {
    final gap = ticket.main.length + ticket.bonus.length > 6 ? 6.0 : 10.0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final (i, n) in ticket.main.indexed) ...[
            if (i > 0) SizedBox(width: gap),
            _buildLottoBall(n),
          ],
          if (ticket.bonus.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '+',
                style: TextStyle(
                  fontFamily: appFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            for (final (i, n) in ticket.bonus.indexed) ...[
              if (i > 0) SizedBox(width: gap),
              _buildBonusBall(n),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildBottomMenuBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomMenuItem(
              icon: Icons.workspace_premium_rounded,
              label: t.menuResults,
              onTap: _showWinningNumberDialog,
            ),
            _buildBottomMenuItem(
              icon: Icons.refresh_rounded,
              label: t.menuReset,
              onTap: _refreshCurrentCalculation,
            ),
            _buildBottomMenuItem(
              icon: Icons.history_rounded,
              label: t.menuHistory,
              onTap: _openHistory,
            ),
            _buildBottomMenuItem(
              icon: Icons.notifications_rounded,
              label: t.menuAlarm,
              onTap: _showAlarmDialog,
            ),
            _buildBottomMenuItem(
              icon: Icons.settings_rounded,
              label: t.menuSettings,
              onTap: _showSettingsDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFC6C3C3), size: 34),
            const SizedBox(height: 4),
            // 양옆 여백: 독일어처럼 긴 단어도 박스 끝에 닿지 않고 글자만 조금 작아짐
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF666666),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterVersion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: _brandYellow,
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${t.versionLabel} '),
            TextSpan(
              text: _appVersion,
              style: const TextStyle(color: Color(0xFF3BA316)),
            ),
          ],
        ),
        style: TextStyle(
          fontFamily: appFont,
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Database? _db;
  Timer? _debounce;

  // 복권 선택. games.json 을 읽기 전에는 한국 6/45 로 동작합니다.
  List<GameConfig> _games = [];
  GameConfig? _game;

  /// 복권별 공식 당첨번호 (최신이 앞). 한국 6/45 는 기기 DB, 해외는 내장 CSV·자동 갱신분.
  final Map<String, List<DrawRecord>> _officialDraws = {};

  /// 복권별 직접 입력한 당첨번호 (기기에만 저장)
  final Map<String, List<DrawRecord>> _manualDraws = {};

  /// 화면·필터에 쓰는 당첨번호 = 공식 + 직접 입력 (같은 날짜는 공식 우선)
  List<DrawRecord> _drawsOf(String id) =>
      mergeDraws(_officialDraws[id] ?? const [], _manualDraws[id] ?? const []);

  UserProfile? _profile;

  // games.json 을 읽기 전·실패 시에도 기존처럼 한국 6/45 로 동작하게 하는 기본값
  static final GameConfig _kr645Fallback = GameConfig(
    id: 'kr645',
    name: const {'ko': '로또 6/45', 'en': 'Lotto 6/45 (Korea)'},
    country: 'KR',
    main: const NumberPool(count: 6, max: 45),
    bonus: const BonusPool(
      count: 1,
      max: 45,
      playerPicks: false,
      label: {'ko': '보너스', 'en': 'Bonus'},
    ),
    drawDays: const ['SAT'],
    timezone: 'Asia/Seoul',
    ruleSince: DateTime(2002, 12, 7),
  );

  GameConfig get _activeGame => _game ?? _kr645Fallback;
  bool get _isKorea => _activeGame.id == 'kr645';
  int get _mainCount => _game?.main.count ?? 6;
  int get _mainMax => _game?.main.max ?? 45;
  int get _totalCombinations => _game?.jackpotOddsDenominator ?? 8145060;

  /// 현재 복권의 과거 당첨 메인 번호 (최신 회차가 앞)
  List<List<int>> get _currentPastWinners => [
    for (final d in _drawsOf(_activeGame.id)) d.main,
  ];

  int _targetRemaining = 8145060;
  int _targetMainRemaining = 8145060;
  int _targetExcluded = 0;
  double _targetPercent = 0.000;

  bool _isDbReady = false;
  bool _dbLoadFailed = false;
  bool _isLoading = false;
  bool _isCalculating = false;
  bool _isExtracting = false;
  int _activeQueryId = 0;

  // 같은 조건을 다시 적용할 때 즉시 표시하기 위한 계산 결과 캐시입니다.
  // 814만 개 조합을 매번 새로 세지 않아도 되므로, 재적용/반복 확인 속도가 빨라집니다.
  final Map<String, ({int main, int total})> _countCache = {};

  bool _exc1st = false;
  bool _exc2nd3rd = false;
  bool _exc4thSeq = false;
  bool _exc5thSeq = false;
  bool _exc3Consec = false;
  bool _excSkip1 = false;
  bool _excSkip2 = false;
  bool _excSkip3 = false;
  bool _exc2Pairs = false;
  bool _exc10Range = false;
  bool _excAllOdd = false;
  bool _excAllEven = false;
  bool _excOE1 = false;
  bool _excOE2 = false;
  bool _excOE3 = false;
  bool _excOE4 = false;
  bool _excOE5 = false;
  bool _excSameLastDigit3 = false;
  bool _excTripleMultiple = false;

  // 해외 복권용 추가 필터 (메인 번호 5개 + 보조 번호 3개)
  bool _excSum = false;
  bool _excBirthday = false;
  bool _excLowHigh = false;
  bool _excDecade4 = false;
  bool _excRepeatLast = false;
  bool _bonusExcRecent = false;
  bool _bonusExcConsec = false;
  bool _bonusExcParity = false;

  final List<TextEditingController> _incControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _excControllers = List.generate(
    18,
    (_) => TextEditingController(),
  );

  // 보조 번호(파워볼·메가볼·럭키스타·유로번호) 포함·제외. 사용자가 고르는 보조 번호가 있는 복권에서만 보입니다.
  final List<TextEditingController> _bonusIncControllers = List.generate(
    2,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _bonusExcControllers = List.generate(
    12,
    (_) => TextEditingController(),
  );

  int get _bonusMax => _activeGame.bonus.max;
  int get _bonusCount => _activeGame.bonus.count;
  String get _bonusLabel =>
      _activeGame.bonus.label[_lang] ?? _activeGame.bonus.label['en'] ?? '';

  /// 보조 번호는 최소한 뽑을 개수만큼은 남겨 두어야 하므로 제외 개수를 제한합니다.
  int get _bonusExcLimit => (_bonusMax - _bonusCount).clamp(0, 12);

  final TextEditingController _recentDrawsController = TextEditingController();
  final TextEditingController _extractCountController = TextEditingController();

  final List<int> _leastFreqNums = [];
  final List<int> _mostFreqNums = [];

  final Color _brandYellow = const Color(0xFFFDE046);
  final Color _bgGray = const Color(0xFFF3F2F2);
  final Color _ballOrange = const Color(0xFFFA7A2C);
  final Color _boxWhite = const Color(0xFFFFFFFF);
  final Color _popupHeaderBtnYellow = const Color(0xFFEFD82D);
  final Color _popupRowEvenYellow = const Color(0xFFFEF6BD);

  static final List<TextInputFormatter> _roundInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadGames().whenComplete(() async {
      _refreshAlarms();
      await _connectAlarmTaps();
      await _restoreFilters(_activeGame.id);
      await _initDatabase();
      await _syncDraws();
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => AdManager.instance.start(),
    );
  }

  /// 앱을 다시 화면에 띄울 때도 새 당첨번호를 확인 (간격은 sync_config 의 drawSyncInterval)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isDbReady) _syncDraws();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_alarmLang != null && _alarmLang != _lang) _refreshAlarms();
  }

  /// 켜 둔 추첨일 알림을 현재 언어 문구로 다시 등록합니다.
  void _refreshAlarms() {
    if (!mounted || _games.isEmpty || !DrawAlarm.supported) return;
    _alarmLang = _lang;
    final tr = t;
    final lang = _lang;
    DrawAlarm.rescheduleAll(
      _games,
      title: (g) => tr.notifyTitle(g.displayName(lang)),
      body: (_) => tr.notifyBody,
      channelName: tr.notifyChannel,
    ).catchError((Object e) => debugPrint('알림 재등록 실패: $e'));
  }

  /// 서버에서 새 당첨번호를 받아 반영합니다 (lib/data/sync_config.dart 의 주소가 있을 때만).
  /// 한국 6/45 는 기기 DB(past_winners)에 새 회차를 추가하고, 해외 복권은 메모리 목록을 바꿉니다.
  bool _syncing = false;

  Future<void> _syncDraws() async {
    if (!DrawSync.enabled || _games.isEmpty || _syncing) return;
    _syncing = true;
    try {
      await _syncDrawsOnce();
    } finally {
      _syncing = false;
    }
  }

  Future<void> _syncDrawsOnce() async {
    final local = <String, List<DrawRecord>>{..._officialDraws};
    final updates = await DrawSync.run(_games, local);
    if (updates.isEmpty || !mounted) return;

    final kr = updates['kr645'];
    if (kr != null && _db != null) {
      final known = {
        for (final d in local['kr645']!) d.no: '${d.main}|${d.bonus}',
      };
      final batch = _db!.batch();
      // 새 회차, 그리고 관리자 정정으로 번호가 바뀐 회차
      for (final d in kr.where((d) => known[d.no] != '${d.main}|${d.bonus}')) {
        batch.insert('past_winners', {
          '회차': d.no,
          '추첨일': d.date,
          for (int i = 0; i < 6; i++) '번호${i + 1}': d.main[i],
          '보너스': d.bonus.isEmpty ? null : d.bonus.first,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      await _loadPastWinners();
    }

    if (!mounted) return;
    setState(() {
      for (final e in updates.entries) {
        if (e.key != 'kr645') _officialDraws[e.key] = e.value;
      }
    });
    for (final id in updates.keys) {
      _manualDraws[id] = await ManualDrawStore.prune(
        id,
        _officialDraws[id] ?? const [],
      );
    }
    if (mounted) setState(() {});
    // 지금 보고 있는 복권의 과거 번호가 늘었으면 조합 수를 다시 계산
    if (updates.containsKey(_activeGame.id)) _onFilterChanged();
  }

  /// 복권 규칙(games.json)과 앱에 내장된 해외 당첨번호(assets/draws)를 읽습니다.
  Future<void> _loadGames() async {
    try {
      final games = parseGames(
        jsonDecode(await rootBundle.loadString('assets/games/games.json'))
            as Map<String, dynamic>,
      );

      for (final g in games.where((g) => g.id != 'kr645')) {
        try {
          _officialDraws[g.id] = parseDrawCsv(
            await rootBundle.loadString('assets/draws/${g.id}.csv'),
          );
        } catch (_) {
          // 아직 당첨번호를 확보하지 못한 복권 (과거 번호 필터·통계 없이 동작)
          _officialDraws[g.id] = const [];
        }
        // 이전에 자동 갱신으로 받아 둔 데이터가 더 최신이면 그것을 씁니다.
        final cached = await DrawSync.cached(g);
        if (cached != null && cached.length >= _officialDraws[g.id]!.length) {
          _officialDraws[g.id] = cached;
        }
      }

      for (final g in games) {
        _manualDraws[g.id] = await ManualDrawStore.load(g.id);
      }
      _profile = await UserStore.profile();

      final initial = await _initialGameId(games);
      if (mounted) {
        setState(() {
          _games = games;
          _game = games.firstWhere((g) => g.id == initial);
          _targetRemaining = _totalCombinations;
          _targetMainRemaining = combinations(_mainMax, _mainCount);
        });
      }
    } catch (e) {
      debugPrint('복권 규칙 로드 오류: $e');
    }
  }

  static const _prefGameKey = 'gameId';

  /// 유로밀리언 참가국 / 유로잭팟 참가국 (기본 복권 고를 때만 사용)
  static const _euroMillionsCountries = {
    'FR',
    'ES',
    'PT',
    'BE',
    'LU',
    'AT',
    'CH',
    'GB',
  };
  static const _eurojackpotCountries = {
    'DE',
    'FI',
    'DK',
    'NL',
    'NO',
    'SE',
    'IT',
    'EE',
    'LV',
    'LT',
    'SI',
    'SK',
    'CZ',
    'HR',
    'HU',
    'PL',
    'IS',
  };

  Future<String> _initialGameId(List<GameConfig> games) async {
    final ids = games.map((g) => g.id).toSet();
    try {
      final saved = (await SharedPreferences.getInstance()).getString(
        _prefGameKey,
      );
      if (saved != null && ids.contains(saved)) return saved;
    } catch (e) {
      debugPrint('복권 설정 읽기 실패: $e');
    }

    final device = WidgetsBinding.instance.platformDispatcher.locale;
    final country = device.countryCode?.toUpperCase();
    final byCountry = switch (country) {
      'KR' => 'kr645',
      'US' => 'powerball',
      'CA' => 'ca649',
      'JP' => 'jp_loto6',
      'IE' => 'ie_lotto',
      'VN' => 'vn_mega645',
      _ when _euroMillionsCountries.contains(country) => 'euromillions',
      _ when _eurojackpotCountries.contains(country) => 'eurojackpot',
      _ => switch (device.languageCode) {
        'ko' => 'kr645',
        'ja' => 'jp_loto6',
        'vi' => 'vn_mega645',
        _ => 'powerball',
      },
    };
    return ids.contains(byCountry) ? byCountry : 'kr645';
  }

  void _selectGame(GameConfig game) {
    if (_game?.id == game.id) return;
    SharedPreferences.getInstance()
        .then((p) => p.setString(_prefGameKey, game.id))
        .catchError((Object e) {
          debugPrint('복권 설정 저장 실패: $e');
          return false;
        });
    _resetFilterInputs();
    setState(() {
      _game = game;
      _targetRemaining = _totalCombinations;
      _targetMainRemaining = combinations(game.main.max, game.main.count);
      _targetExcluded = 0;
      _targetPercent = 0.000;
    });
    _restoreFilters(game.id).then((restored) {
      if (restored && mounted) _onFilterChanged();
    });
  }

  /// 알림을 눌러 들어오면 그 복권을 엽니다.
  Future<void> _connectAlarmTaps() async {
    if (!DrawAlarm.supported) return;
    DrawAlarm.onOpenGame = _openGameById;
    try {
      final id = await DrawAlarm.launchGameId();
      if (id != null) _openGameById(id);
    } catch (e) {
      debugPrint('알림 실행 정보 읽기 실패: $e');
    }
  }

  void _openGameById(String id) {
    if (!mounted) return;
    for (final g in _games) {
      if (g.id == id) {
        Navigator.of(context).popUntil((r) => r.isFirst);
        _selectGame(g);
        return;
      }
    }
  }

  // ---- 복권별 필터 저장 ----

  Map<String, bool> get _flagValues => {
    'exc1st': _exc1st,
    'exc2nd3rd': _exc2nd3rd,
    'exc4thSeq': _exc4thSeq,
    'exc5thSeq': _exc5thSeq,
    'exc3Consec': _exc3Consec,
    'excSkip1': _excSkip1,
    'excSkip2': _excSkip2,
    'excSkip3': _excSkip3,
    'exc2Pairs': _exc2Pairs,
    'exc10Range': _exc10Range,
    'excAllOdd': _excAllOdd,
    'excAllEven': _excAllEven,
    'excOE1': _excOE1,
    'excOE2': _excOE2,
    'excOE3': _excOE3,
    'excOE4': _excOE4,
    'excOE5': _excOE5,
    'excSameLastDigit3': _excSameLastDigit3,
    'excTripleMultiple': _excTripleMultiple,
    'excSum': _excSum,
    'excBirthday': _excBirthday,
    'excLowHigh': _excLowHigh,
    'excDecade4': _excDecade4,
    'excRepeatLast': _excRepeatLast,
    'bonusExcRecent': _bonusExcRecent,
    'bonusExcConsec': _bonusExcConsec,
    'bonusExcParity': _bonusExcParity,
  };

  void _setFlag(String key, bool v) {
    switch (key) {
      case 'exc1st':
        _exc1st = v;
      case 'exc2nd3rd':
        _exc2nd3rd = v;
      case 'exc4thSeq':
        _exc4thSeq = v;
      case 'exc5thSeq':
        _exc5thSeq = v;
      case 'exc3Consec':
        _exc3Consec = v;
      case 'excSkip1':
        _excSkip1 = v;
      case 'excSkip2':
        _excSkip2 = v;
      case 'excSkip3':
        _excSkip3 = v;
      case 'exc2Pairs':
        _exc2Pairs = v;
      case 'exc10Range':
        _exc10Range = v;
      case 'excAllOdd':
        _excAllOdd = v;
      case 'excAllEven':
        _excAllEven = v;
      case 'excOE1':
        _excOE1 = v;
      case 'excOE2':
        _excOE2 = v;
      case 'excOE3':
        _excOE3 = v;
      case 'excOE4':
        _excOE4 = v;
      case 'excOE5':
        _excOE5 = v;
      case 'excSameLastDigit3':
        _excSameLastDigit3 = v;
      case 'excTripleMultiple':
        _excTripleMultiple = v;
      case 'excSum':
        _excSum = v;
      case 'excBirthday':
        _excBirthday = v;
      case 'excLowHigh':
        _excLowHigh = v;
      case 'excDecade4':
        _excDecade4 = v;
      case 'excRepeatLast':
        _excRepeatLast = v;
      case 'bonusExcRecent':
        _bonusExcRecent = v;
      case 'bonusExcConsec':
        _bonusExcConsec = v;
      case 'bonusExcParity':
        _bonusExcParity = v;
    }
  }

  SavedFilters _snapshotFilters() => SavedFilters(
    flags: {
      for (final e in _flagValues.entries)
        if (e.value) e.key,
    },
    include: [for (final c in _incControllers) c.text],
    exclude: [for (final c in _excControllers) c.text],
    bonusInclude: [for (final c in _bonusIncControllers) c.text],
    bonusExclude: [for (final c in _bonusExcControllers) c.text],
    recentDraws: _recentDrawsController.text,
    extractCount: _extractCountController.text,
    mostFrequent: [..._mostFreqNums],
    leastFrequent: [..._leastFreqNums],
  );

  void _saveFilters() {
    if (_game == null) return;
    FilterStore.save(_game!.id, _snapshotFilters());
  }

  /// 저장된 필터가 있으면 화면에 채우고 true
  Future<bool> _restoreFilters(String gameId) async {
    final f = await FilterStore.load(gameId);
    if (f == null || !mounted || _activeGame.id != gameId) return false;
    void fill(List<TextEditingController> cs, List<String> values) {
      for (var i = 0; i < cs.length; i++) {
        cs[i].text = i < values.length ? values[i] : '';
      }
    }

    setState(() {
      for (final k in _flagValues.keys) {
        _setFlag(k, f.flags.contains(k));
      }
      fill(_incControllers, f.include);
      fill(_excControllers, f.exclude);
      fill(_bonusIncControllers, f.bonusInclude);
      fill(_bonusExcControllers, f.bonusExclude);
      _recentDrawsController.text = f.recentDraws;
      _extractCountController.text = f.extractCount;
      _mostFreqNums
        ..clear()
        ..addAll(f.mostFrequent);
      _leastFreqNums
        ..clear()
        ..addAll(f.leastFrequent);
    });
    return true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();

    for (final c in _incControllers) {
      c.dispose();
    }
    for (final c in _excControllers) {
      c.dispose();
    }
    for (final c in [..._bonusIncControllers, ..._bonusExcControllers]) {
      c.dispose();
    }

    _recentDrawsController.dispose();
    _extractCountController.dispose();

    super.dispose();
  }

  Future<void> _initDatabase() async {
    setState(() {
      _isDbReady = false;
      _dbLoadFailed = false;
    });

    try {
      if (kIsWeb ||
          Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS) {
        _officialDraws['kr645'] = parseKoreanCsv(
          await rootBundle.loadString('assets/lotto.csv'),
        );
        setState(() {
          _isDbReady = true;
          _dbLoadFailed = _officialDraws['kr645']!.isEmpty;
        });
        _onFilterChanged();
        return;
      }

      final dbDir = await getDatabasesPath();
      final path = p.join(dbDir, 'lotto.db');

      // 이전 버전이 기기에 복사해 둔 487MB 짜리 DB는 더 이상 쓰지 않으므로 삭제
      final legacyPath = p.join(dbDir, 'lotto_master.db');
      if (await databaseExists(legacyPath)) {
        await deleteDatabase(legacyPath);
      }

      final exists = await databaseExists(path);

      if (!exists) {
        await Directory(p.dirname(path)).create(recursive: true);

        final data = await rootBundle.load('assets/db/lotto.db');
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );

        await File(path).writeAsBytes(bytes, flush: true);
      }

      _db = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await _ensurePastWinnersSchema(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          await _ensurePastWinnersSchema(db);
        },
      );

      await _ensurePastWinnersSchema(_db!);
      await _syncCsvAssetToDb();
      await _loadPastWinners();

      if (mounted) {
        setState(() {
          _isDbReady = true;
          _dbLoadFailed = (_officialDraws['kr645'] ?? const []).isEmpty;
        });
      }

      _onFilterChanged();
    } catch (e) {
      debugPrint('DB 초기화 오류: $e');

      if (mounted) {
        setState(() {
          _isDbReady = true;
          _dbLoadFailed = true;
        });
        _showSnack(t.dbLoadFailed);
      }
    }
  }

  Future<void> _ensurePastWinnersSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS past_winners (
        회차 INTEGER PRIMARY KEY,
        추첨일 TEXT,
        번호1 INTEGER NOT NULL,
        번호2 INTEGER NOT NULL,
        번호3 INTEGER NOT NULL,
        번호4 INTEGER NOT NULL,
        번호5 INTEGER NOT NULL,
        번호6 INTEGER NOT NULL,
        보너스 INTEGER
      )
    ''');

    final columns = await db.rawQuery('PRAGMA table_info(past_winners)');
    final columnNames = columns.map((e) => e['name'] as String).toSet();

    if (!columnNames.contains('추첨일')) {
      await db.execute('ALTER TABLE past_winners ADD COLUMN 추첨일 TEXT');
    }

    if (!columnNames.contains('보너스')) {
      await db.execute('ALTER TABLE past_winners ADD COLUMN 보너스 INTEGER');
    }
  }

  List<String> _splitCsvLine(String line) {
    final result = <String>[];
    final current = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final ch = line[i];

      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        result.add(current.toString().trim());
        current.clear();
      } else {
        current.write(ch);
      }
    }

    result.add(current.toString().trim());
    return result;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;

    final cleaned = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return null;

    return int.tryParse(cleaned);
  }

  bool _isValidDrawForDb(int round, List<int> nums, int? bonus) {
    if (round < 1) return false;
    if (nums.length != 6) return false;
    if (nums.any((n) => n < 1 || n > 45)) return false;
    if (nums.toSet().length != 6) return false;

    if (bonus != null) {
      if (bonus < 1 || bonus > 45) return false;
      if (nums.contains(bonus)) return false;
    }

    return true;
  }

  Future<void> _syncCsvAssetToDb() async {
    if (_db == null) return;

    try {
      final bytes = await rootBundle.load('assets/lotto.csv');

      final csvText = utf8.decode(
        bytes.buffer.asUint8List(),
        allowMalformed: true,
      );

      final lines = const LineSplitter()
          .convert(csvText)
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (lines.length < 2) return;

      final header = _splitCsvLine(lines.first);
      final headerIndex = <String, int>{};

      for (int i = 0; i < header.length; i++) {
        // 엑셀 'CSV UTF-8' 저장 시 붙는 BOM(﻿) 제거
        headerIndex[header[i].replaceAll('﻿', '').replaceAll(' ', '')] = i;
      }

      int inserted = 0;
      final batch = _db!.batch();

      for (int i = 1; i < lines.length; i++) {
        final cols = _splitCsvLine(lines[i]);
        if (cols.isEmpty) continue;

        int? round;
        String? drawDate;
        List<int?> numsNullable = [];
        int? bonus;

        if (headerIndex.containsKey('회차') && headerIndex.containsKey('번호1')) {
          round = _toInt(
            cols.length > headerIndex['회차']! ? cols[headerIndex['회차']!] : null,
          );

          drawDate =
              headerIndex.containsKey('추첨일') &&
                  cols.length > headerIndex['추첨일']!
              ? cols[headerIndex['추첨일']!]
              : null;

          numsNullable = List.generate(6, (idx) {
            final key = '번호${idx + 1}';
            final pos = headerIndex[key];
            return pos != null && cols.length > pos ? _toInt(cols[pos]) : null;
          });

          final bonusPos = headerIndex['보너스'];
          bonus = bonusPos != null && cols.length > bonusPos
              ? _toInt(cols[bonusPos])
              : null;
        } else {
          final numsFromLine = RegExp(
            r'\d+',
          ).allMatches(lines[i]).map((m) => int.parse(m.group(0)!)).toList();

          if (numsFromLine.length < 8) continue;

          round = numsFromLine[0];
          numsNullable = numsFromLine.sublist(1, 7);
          bonus = numsFromLine[7];
        }

        if (round == null || numsNullable.any((e) => e == null)) {
          continue;
        }

        final nums = numsNullable.cast<int>();

        if (!_isValidDrawForDb(round, nums, bonus)) {
          continue;
        }

        batch.insert('past_winners', {
          '회차': round,
          '추첨일': drawDate,
          '번호1': nums[0],
          '번호2': nums[1],
          '번호3': nums[2],
          '번호4': nums[3],
          '번호5': nums[4],
          '번호6': nums[5],
          '보너스': bonus,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        inserted++;
      }

      if (inserted > 0) {
        await batch.commit(noResult: true);
        debugPrint('CSV DB 반영 완료: $inserted건');
      }
    } catch (e) {
      debugPrint('CSV asset 반영 건너뜀: $e');
    }
  }

  Future<void> _loadPastWinners() async {
    if (_db == null) return;

    try {
      final rows = await _db!.query(
        'past_winners',
        columns: ['회차', '추첨일', '번호1', '번호2', '번호3', '번호4', '번호5', '번호6', '보너스'],
        orderBy: '회차 DESC',
      );
      _officialDraws['kr645'] = [
        for (final row in rows)
          if ([for (int i = 1; i <= 6; i++) row['번호$i']].every((v) => v is int))
            DrawRecord(
              row['회차'] as int,
              (row['추첨일'] ?? '').toString().trim(),
              [for (int i = 1; i <= 6; i++) row['번호$i'] as int],
              [if (row['보너스'] is int) row['보너스'] as int],
            ),
      ];
    } catch (e) {
      debugPrint('DB 테이블 조회 오류: $e');
    }
  }

  /// 현재 복권에서 보여 줄 패턴 필터 목록. 번호 개수(5·6개)와 범위에 맞춰 제목과 설명이 바뀝니다.
  List<_FilterItem> _filterItems() {
    final k = _mainCount;
    final narrow = _game == null
        ? 9
        : const FilterOptions().narrowRangeFor(_game!);
    final noData = !_isKorea && _currentPastWinners.isEmpty;
    final pastNote = noData ? t.pastPending : '';
    // 한국어 화면의 한국 로또는 익숙한 등수 기준 이름을 그대로 씁니다.
    final kr = _isKorea && _lang == 'ko';
    final recentMinus2 = const FilterOptions().recentMinus2For(_activeGame);

    return [
      _FilterItem(
        kr ? t.fKr1st : t.fPastFull('$k') + pastNote,
        kr ? t.hKr1st : t.hPastFull('$k'),
        _exc1st,
        (v) => _exc1st = v,
      ),
      _FilterItem(
        kr ? t.fKr23 : t.fPastMinus1('${k - 1}') + pastNote,
        kr ? t.hKr23 : t.hPastMinus1('$k', '${k - 1}'),
        _exc2nd3rd,
        (v) => _exc2nd3rd = v,
      ),
      _FilterItem(
        kr ? t.fKr4th : t.fPastMinus2('$recentMinus2', '${k - 2}') + pastNote,
        kr ? t.hKr4th : t.hPastMinus2('$recentMinus2', '${k - 2}'),
        _exc4thSeq,
        (v) => _exc4thSeq = v,
      ),
      _FilterItem(
        kr ? t.fKr5th : t.fPastConsec + pastNote,
        kr ? t.hKr5th : t.hPastConsec,
        _exc5thSeq,
        (v) => _exc5thSeq = v,
      ),
      _FilterItem(t.f3Consec, t.h3Consec, _exc3Consec, (v) => _exc3Consec = v),
      _FilterItem(t.fSkip1, t.hSkip1, _excSkip1, (v) => _excSkip1 = v),
      _FilterItem(t.fSkip2, t.hSkip2, _excSkip2, (v) => _excSkip2 = v),
      _FilterItem(t.fSkip3, t.hSkip3, _excSkip3, (v) => _excSkip3 = v),
      _FilterItem(t.f2Pairs, t.h2Pairs, _exc2Pairs, (v) => _exc2Pairs = v),
      _FilterItem(
        kr ? t.fKrRange : t.fNarrow('$narrow'),
        kr ? t.hKrRange : t.hNarrow('$narrow'),
        _exc10Range,
        (v) => _exc10Range = v,
      ),
      _FilterItem(
        t.fAllOdd('$k'),
        t.hAllOdd('$k'),
        _excAllOdd,
        (v) => _excAllOdd = v,
      ),
      _FilterItem(
        t.fAllEven('$k'),
        t.hAllEven('$k'),
        _excAllEven,
        (v) => _excAllEven = v,
      ),
      // 홀짝 배열 5종은 6개 번호 전용
      if (k == 6) ...[
        _FilterItem(t.fOE1, t.hOE(_parityText(0)), _excOE1, (v) => _excOE1 = v),
        _FilterItem(t.fOE2, t.hOE(_parityText(1)), _excOE2, (v) => _excOE2 = v),
        _FilterItem(t.fOE3, t.hOE(_parityText(2)), _excOE3, (v) => _excOE3 = v),
        _FilterItem(t.fOE4, t.hOE(_parityText(3)), _excOE4, (v) => _excOE4 = v),
        _FilterItem(t.fOE5, t.hOE(_parityText(4)), _excOE5, (v) => _excOE5 = v),
      ],
      _FilterItem(
        t.fSameDigit,
        t.hSameDigit,
        _excSameLastDigit3,
        (v) => _excSameLastDigit3 = v,
      ),
      _FilterItem(
        t.fTripleMult,
        t.hTripleMult,
        _excTripleMultiple,
        (v) => _excTripleMultiple = v,
      ),
      // 해외 복권 추가 필터 (한국 로또 화면은 기존 그대로)
      if (!_isKorea) ..._overseasFilterItems(pastNote),
    ];
  }

  List<_FilterItem> _overseasFilterItems(String pastNote) {
    final g = _activeGame;
    final sum = sumRangeFor(g);
    final half = lowHalfMax(g);
    final section = t.filtersOverseas;
    final label = _bonusLabel;
    final n = '${recentBonusDrawsFor(g)}';
    final bonusSection = t.filtersBonus(label);
    return [
      _FilterItem(
        t.fSum('${sum.low}', '${sum.high}'),
        t.hSum('${sum.low}', '${sum.high}'),
        _excSum,
        (v) => _excSum = v,
        section: section,
      ),
      _FilterItem(
        t.fBirthday,
        t.hBirthday,
        _excBirthday,
        (v) => _excBirthday = v,
        section: section,
      ),
      _FilterItem(
        t.fLowHigh,
        t.hLowHigh('$half', '${half + 1}', '${g.main.max}'),
        _excLowHigh,
        (v) => _excLowHigh = v,
        section: section,
      ),
      _FilterItem(
        t.fDecade4,
        t.hDecade4,
        _excDecade4,
        (v) => _excDecade4 = v,
        section: section,
      ),
      _FilterItem(
        t.fRepeatLast + pastNote,
        t.hRepeatLast,
        _excRepeatLast,
        (v) => _excRepeatLast = v,
        section: section,
      ),
      if (g.hasPlayerBonus) ...[
        _FilterItem(
          g.bonus.count == 1
              ? t.fBonusRecent(n, label) + pastNote
              : t.fBonusPairRecent(n, label) + pastNote,
          g.bonus.count == 1
              ? t.hBonusRecent(n, label)
              : t.hBonusPairRecent(n, label),
          _bonusExcRecent,
          (v) => _bonusExcRecent = v,
          section: bonusSection,
        ),
        if (g.bonus.count >= 2) ...[
          _FilterItem(
            t.fBonusConsec(label),
            t.hBonusConsec(label),
            _bonusExcConsec,
            (v) => _bonusExcConsec = v,
            section: bonusSection,
          ),
          _FilterItem(
            t.fBonusParity(label),
            t.hBonusParity(label),
            _bonusExcParity,
            (v) => _bonusExcParity = v,
            section: bonusSection,
          ),
        ],
      ],
    ];
  }

  /// 홀짝 패턴 설명용 표기. 예) ko: 홀짝홀짝홀짝 또는 짝홀짝홀짝홀 / en: O-E-O-E-O-E / E-O-E-O-E-O
  String _parityText(int index) {
    final (odd, even, sep, or) = switch (_lang) {
      'ko' => ('홀', '짝', '', ' 또는 '),
      'en' => ('O', 'E', '-', ' / '),
      'de' => ('U', 'G', '-', ' / '),
      'ja' => ('奇', '偶', '', ' / '),
      'vi' => ('L', 'C', '-', ' / '),
      _ => ('I', 'P', '-', ' / '),
    };
    return legacyParityPatterns645[index]
        .map((p) => p.map((b) => b == 1 ? odd : even).join(sep))
        .join(or);
  }

  bool get _isAllSelected => _filterItems().every((f) => f.value);

  void _toggleAllFilters(bool val) {
    setState(() {
      for (final f in _filterItems()) {
        f.set(val);
      }
    });
  }

  void _onFilterChanged() {
    if (!mounted) return;

    if (!_isDbReady) {
      setState(() => _isCalculating = true);
      return;
    }

    final parsed = _parseInputNumbers(showMessage: false);

    if (parsed == null) {
      setState(() => _isCalculating = false);
      return;
    }

    setState(() => _isCalculating = true);

    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(
      // 적용 버튼을 눌렀을 때 체감 대기 시간을 줄이기 위해 500ms에서 80ms로 단축했습니다.
      const Duration(milliseconds: 80),
      () => _runIsolateCalculation(),
    );
  }

  List<int>? _parseControllerNumbers(
    List<TextEditingController> controllers,
    String label, {
    bool showMessage = true,
    int? max,
  }) {
    final maxNumber = max ?? _mainMax;
    final result = <int>[];

    for (final c in controllers) {
      final raw = c.text.trim();
      if (raw.isEmpty) continue;

      if (!RegExp(r'^\d+$').hasMatch(raw)) {
        if (showMessage) {
          _showSnack(t.notNumber(label, raw));
        }
        return null;
      }

      final value = int.tryParse(raw);
      if (value == null || value < 1 || value > maxNumber) {
        if (showMessage) {
          _showSnack(t.outOfRange(label, '$maxNumber'));
        }
        return null;
      }

      result.add(value);
    }

    return result;
  }

  _Picks? _parseInputNumbers({bool showMessage = true}) {
    final inc = _parseControllerNumbers(
      _incControllers,
      t.includeLabel,
      showMessage: showMessage,
    );
    if (inc == null) return null;

    final exc = _parseControllerNumbers(
      _excControllers,
      t.excludeLabel,
      showMessage: showMessage,
    );
    if (exc == null) return null;

    final error = _validateNumberLists(inc, exc);
    if (error != null) {
      if (showMessage) _showSnack(error);
      return null;
    }

    // 사용자가 고르는 보조 번호가 없는 복권(한국·캐나다)은 보조 번호 입력을 무시합니다.
    if (!_activeGame.hasPlayerBonus) {
      return (inc: inc, exc: exc, bonusInc: <int>[], bonusExc: <int>[]);
    }

    final bonusInc = _parseControllerNumbers(
      _bonusIncControllers,
      t.includeBonusLabel(_bonusLabel),
      showMessage: showMessage,
      max: _bonusMax,
    );
    if (bonusInc == null) return null;

    final bonusExc = _parseControllerNumbers(
      _bonusExcControllers,
      t.excludeBonusLabel(_bonusLabel),
      showMessage: showMessage,
      max: _bonusMax,
    );
    if (bonusExc == null) return null;

    final bonusError = _validateNumberLists(bonusInc, bonusExc);
    if (bonusError != null) {
      if (showMessage) _showSnack('$_bonusLabel: $bonusError');
      return null;
    }

    return (inc: inc, exc: exc, bonusInc: bonusInc, bonusExc: bonusExc);
  }

  String? _validateNumberLists(List<int> inc, List<int> exc) {
    if (inc.toSet().length != inc.length) {
      return t.dupInclude;
    }

    if (exc.toSet().length != exc.length) {
      return t.dupExclude;
    }

    final conflict = inc.toSet().intersection(exc.toSet());
    if (conflict.isNotEmpty) {
      return t.conflict(conflict.join(', '));
    }

    return null;
  }

  String _buildCountCacheKey(_Picks parsed) {
    final inc = parsed.inc.toList()..sort();
    final exc = parsed.exc.toList()..sort();

    return [
      _activeGame.id,
      _currentPastWinners.length,
      _exc1st ? 1 : 0,
      _exc2nd3rd ? 1 : 0,
      _exc4thSeq ? 1 : 0,
      _exc5thSeq ? 1 : 0,
      _exc3Consec ? 1 : 0,
      _excSkip1 ? 1 : 0,
      _excSkip2 ? 1 : 0,
      _excSkip3 ? 1 : 0,
      _exc2Pairs ? 1 : 0,
      _exc10Range ? 1 : 0,
      _excAllOdd ? 1 : 0,
      _excAllEven ? 1 : 0,
      _excOE1 ? 1 : 0,
      _excOE2 ? 1 : 0,
      _excOE3 ? 1 : 0,
      _excOE4 ? 1 : 0,
      _excOE5 ? 1 : 0,
      _excSameLastDigit3 ? 1 : 0,
      _excTripleMultiple ? 1 : 0,
      _excSum ? 1 : 0,
      _excBirthday ? 1 : 0,
      _excLowHigh ? 1 : 0,
      _excDecade4 ? 1 : 0,
      _excRepeatLast ? 1 : 0,
      _bonusExcRecent ? 1 : 0,
      _bonusExcConsec ? 1 : 0,
      _bonusExcParity ? 1 : 0,
      inc.join('-'),
      exc.join('-'),
      ([...parsed.bonusInc]..sort()).join('-'),
      ([...parsed.bonusExc]..sort()).join('-'),
    ].join('|');
  }

  /// 화면의 필터 상태로 범용 엔진 요청을 만듭니다.
  EngineRequest _buildEngineRequest({
    EngineMode mode = EngineMode.count,
    int extractCount = 0,
  }) {
    final parsed = _parseInputNumbers(showMessage: false)!;
    final sixBalls = _mainCount == 6; // 홀짝 배열 5종은 6개 번호 전용

    final filters = filterOptionsFromLegacy({
      'exc1st': _exc1st,
      'exc2nd3rd': _exc2nd3rd,
      'exc4thSeq': _exc4thSeq,
      'exc5thSeq': _exc5thSeq,
      'exc3Consec': _exc3Consec,
      'excSkip1': _excSkip1,
      'excSkip2': _excSkip2,
      'excSkip3': _excSkip3,
      'exc2Pairs': _exc2Pairs,
      'exc10Range': _exc10Range,
      'excAllOdd': _excAllOdd,
      'excAllEven': _excAllEven,
      'excOE1': sixBalls && _excOE1,
      'excOE2': sixBalls && _excOE2,
      'excOE3': sixBalls && _excOE3,
      'excOE4': sixBalls && _excOE4,
      'excOE5': sixBalls && _excOE5,
      'excSameLastDigit3': _excSameLastDigit3,
      'excTripleMultiple': _excTripleMultiple,
      'excSum': _excSum,
      'excBirthday': _excBirthday,
      'excLowHigh': _excLowHigh,
      'excDecade4': _excDecade4,
      'excRepeatLast': _excRepeatLast,
      'bonusExcRecent': _bonusExcRecent,
      'bonusExcConsec': _bonusExcConsec,
      'bonusExcParity': _bonusExcParity,
      'inc': parsed.inc,
      'exc': parsed.exc,
      'bonusInc': parsed.bonusInc,
      'bonusExc': parsed.bonusExc,
    });

    return EngineRequest(
      game: _activeGame,
      filters: filters,
      pastWinners: _currentPastWinners,
      pastBonus: [for (final d in _drawsOf(_activeGame.id)) d.bonus],
      mode: mode,
      extractCount: extractCount,
    );
  }

  void _applyCount(({int main, int total}) c) {
    _targetMainRemaining = c.main;
    _targetRemaining = c.total;
    _targetExcluded = _totalCombinations - _targetRemaining;
    _targetPercent = (_targetExcluded / _totalCombinations) * 100;
  }

  Future<void> _runIsolateCalculation() async {
    if (!_isDbReady) return;

    final parsed = _parseInputNumbers(showMessage: true);
    if (parsed == null) {
      if (mounted) {
        setState(() => _isCalculating = false);
      }
      return;
    }

    _activeQueryId++;
    final currentId = _activeQueryId;
    _saveFilters();
    final cacheKey = _buildCountCacheKey(parsed);
    final cached = _countCache[cacheKey];

    if (cached != null) {
      if (mounted && currentId == _activeQueryId) {
        setState(() {
          _applyCount(cached);
          _isCalculating = false;
        });
      }
      return;
    }

    try {
      final result = await compute(runEngine, _buildEngineRequest());

      if (mounted && currentId == _activeQueryId) {
        final counted = (main: result.mainCount, total: result.total);
        _countCache[cacheKey] = counted;

        setState(() => _applyCount(counted));
      }
    } catch (e) {
      debugPrint('계산 오류: $e');

      if (mounted) {
        _showSnack(t.calcError);
      }
    } finally {
      if (mounted && currentId == _activeQueryId) {
        setState(() => _isCalculating = false);
      }
    }
  }

  /// true: 광고 보고 전부 추출, false: 무료 개수만, null: 취소
  Future<bool?> _askRewardedExtraction(int count) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _boxWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _brandYellow, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          t.rewardTitle('$count'),
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          t.rewardBody('$freeExtractLimit', '$count'),
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 15,
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              t.rewardFreeOnly('$freeExtractLimit'),
              style: TextStyle(fontFamily: appFont, color: Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _popupHeaderBtnYellow,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: Text(
              t.rewardWatch('$count'),
              style: TextStyle(fontFamily: appFont),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _executeSearch() async {
    FocusScope.of(context).unfocus();

    if (!_isDbReady) {
      _showSnack(t.dbLoading);
      return;
    }

    if (_isCalculating || _isExtracting) {
      _showSnack(t.busy);
      return;
    }

    final parsed = _parseInputNumbers(showMessage: true);
    if (parsed == null) return;

    int targetCount = int.tryParse(_extractCountController.text.trim()) ?? 5;
    if (targetCount < 1) {
      targetCount = 1;
    }

    if (_targetRemaining <= 0) {
      _showSnack(t.noResults);
      return;
    }

    if (targetCount > _targetMainRemaining) {
      targetCount = _targetMainRemaining;
      _showSnack(t.tooMany('$targetCount'));
    }

    // 무료 개수를 넘으면 보상형 광고를 제안. 광고를 쓸 수 없으면 막지 않고 그대로 추출합니다.
    if (targetCount > freeExtractLimit && AdManager.instance.rewardedReady) {
      final watch = await _askRewardedExtraction(targetCount);
      if (watch == null || !mounted) return;
      if (!watch) {
        targetCount = freeExtractLimit;
      } else if (!await AdManager.instance.showRewarded()) {
        targetCount = freeExtractLimit;
        if (mounted) _showSnack(t.rewardNotEarned('$freeExtractLimit'));
      }
      if (!mounted) return;
    }

    setState(() => _isExtracting = true);

    try {
      final result = await compute(
        runEngine,
        _buildEngineRequest(
          mode: EngineMode.extract,
          extractCount: targetCount,
        ),
      );

      final results = result.tickets;

      if (!mounted) return;

      if (results.isEmpty) {
        _showSnack(t.noExtract);
        return;
      }

      // 내 기록에 저장 (기기 안)
      UserStore.addHistory(
        HistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch,
          gameId: _activeGame.id,
          createdAt: DateTime.now(),
          tickets: results,
          filterCount: _filterItems().where((f) => f.value).length,
          include: parsed.inc,
          exclude: parsed.exc,
        ),
      );

      await AdManager.instance.maybeShowInterstitial();
      if (!mounted) return;

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: t.close,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _buildResultsDialog(results);
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          );
        },
      );
    } catch (e) {
      debugPrint('추출 오류: $e');
      _showSnack(t.extractError);
    } finally {
      if (mounted) {
        setState(() => _isExtracting = false);
      }
    }
  }

  Widget _buildResultsDialog(List<Ticket> results) {
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = screenWidth * 0.8;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: popupWidth,
        height: 460,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _popupHeaderBtnYellow, width: 3),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: _popupHeaderBtnYellow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 28),
                  Text(
                    '${flagOf(_activeGame.country)} ${t.resultsTitle}',
                    style: TextStyle(
                      fontFamily: appFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final row = results[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: index % 2 == 0
                          ? _popupRowEvenYellow
                          : Colors.white,
                      child: _buildTicketRow(row),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: popupWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final resultText = results.join('\n');

                            Clipboard.setData(ClipboardData(text: resultText));
                            _showSnack(t.copied);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _popupHeaderBtnYellow,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            t.copyButton,
                            style: TextStyle(
                              fontFamily: appFont,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final resultText =
                                '${t.shareHeader(_activeGame.displayName(_lang))}\n${results.join('\n')}';

                            SharePlus.instance.share(
                              ShareParams(
                                text: resultText,
                                subject: t.shareSubject,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _popupHeaderBtnYellow,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            t.shareButton,
                            style: TextStyle(
                              fontFamily: appFont,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _calculateFrequencies() async {
    if (!_isDbReady) {
      _showSnack(t.dbLoadingShort);
      return;
    }

    final past = _currentPastWinners;
    if (past.isEmpty) {
      _showSnack(t.noDrawData);
      return;
    }

    final String recentRaw = _recentDrawsController.text.trim();

    int limit = recentRaw.isEmpty
        ? past.length
        : (int.tryParse(recentRaw) ?? past.length);

    if (limit < 1) {
      limit = 1;
    }

    if (limit > past.length) {
      limit = past.length;
      _showSnack(t.recentTooLarge);
    }

    setState(() => _isLoading = true);

    try {
      final Map<int, int> freq = {for (int i = 1; i <= _mainMax; i++) i: 0};

      for (final nums in past.take(limit)) {
        for (final n in nums) {
          freq[n] = freq[n]! + 1;
        }
      }

      final sorted = freq.entries.toList();

      sorted.sort(
        (a, b) => b.value == a.value
            ? a.key.compareTo(b.key)
            : b.value.compareTo(a.value),
      );

      _mostFreqNums
        ..clear()
        ..addAll(sorted.take(_mainCount).map((e) => e.key));

      sorted.sort(
        (a, b) => a.value == b.value
            ? a.key.compareTo(b.key)
            : a.value.compareTo(b.value),
      );

      _leastFreqNums
        ..clear()
        ..addAll(sorted.take(_mainCount).map((e) => e.key));
      _saveFilters();

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('빈도 계산 오류: $e');
      setState(() => _isLoading = false);
      _showSnack(t.freqError);
    }
  }

  void _showHelpDialog(String title, [String? help]) {
    final content = help ?? t.noHelp;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _boxWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _brandYellow, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.close,
              style: TextStyle(
                fontFamily: appFont,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(fontFamily: appFont, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appFont = _lang == 'ko' ? 'Esamanru' : null;
    return Scaffold(
      backgroundColor: _bgGray,
      // 하단 고정 배너. 광고가 없으면 공간을 차지하지 않습니다.
      bottomNavigationBar: const BannerAdView(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildFixedTopSection(),
                  if (!_isDbReady || _dbLoadFailed) _buildDbStatusBanner(),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildFrequencySection(),
                          const SizedBox(height: 15),
                          _buildIncludeExcludeSection(),
                          const SizedBox(height: 15),
                          _buildPatternFilterSection(),
                          _buildFooterVersion(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 키보드가 열려 있으면 메뉴가 키보드 위로 올라와 입력칸을 가리므로 숨김
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                Positioned(
                  left: 0,
                  right: 0,
                  // 배너와 메뉴 버튼이 완전히 붙지 않도록 최소 간격만 둠 (AdMob 실수 클릭 정책)
                  bottom: 6,
                  child: _buildBottomMenuBar(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      _logoAssetPath,
      height: 42,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Text(
          t.appTitle,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        );
      },
    );
  }

  Widget _buildDbStatusBanner() {
    final loading = !_isDbReady;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: loading ? Colors.black87 : Colors.red.shade700,
      child: Row(
        children: [
          if (loading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 18,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              loading ? t.dbLoadingShort : t.dbLoadFailed,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySection() {
    return Container(
      decoration: BoxDecoration(
        color: _boxWhite,
        border: Border(bottom: BorderSide(color: _brandYellow, width: 2)),
      ),
      child: Column(
        children: [
          _buildSectionHeader(
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.freqPrefix,
                      style: TextStyle(
                        fontFamily: appFont,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      child: TextField(
                        controller: _recentDrawsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: _roundInputFormatters,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: appFont,
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                          color: Colors.blue,
                        ),
                        decoration: InputDecoration(
                          hintText: t.freqHint,
                          hintStyle: TextStyle(
                            fontFamily: appFont,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Text(
                      t.freqSuffix,
                      style: TextStyle(
                        fontFamily: appFont,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _calculateFrequencies();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _boxWhite,
                foregroundColor: const Color(0xFF07BA0F),
                minimumSize: const Size(52, 27),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      t.lookup,
                      style: TextStyle(
                        fontFamily: appFont,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                _buildBallRow(
                  t.mostDrawn,
                  _mostFreqNums.isEmpty ? [] : _mostFreqNums,
                  Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildBallRow(
                  t.leastDrawn,
                  _leastFreqNums.isEmpty ? [] : _leastFreqNums,
                  Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludeExcludeSection() {
    return Container(
      decoration: BoxDecoration(
        color: _boxWhite,
        border: Border(bottom: BorderSide(color: _brandYellow, width: 2)),
      ),
      child: Column(
        children: [
          _buildSectionHeader(
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  t.includeExcludeHeader('$_mainCount'),
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _onFilterChanged();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _boxWhite,
                foregroundColor: const Color(0xFF07BA0F),
                minimumSize: const Size(52, 27),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                t.apply,
                style: TextStyle(
                  fontFamily: appFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                _buildInputRow(
                  t.includeRow,
                  _incControllers.take(_mainCount).toList(),
                  Colors.blue,
                  columns: _mainCount,
                  isInclude: true,
                ),
                const SizedBox(height: 20),
                _buildInputRow(t.excludeRow, _excControllers, Colors.red),
                if (_activeGame.hasPlayerBonus) ...[
                  const SizedBox(height: 20),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        t.bonusHeader(
                          _bonusLabel,
                          '$_bonusMax',
                          '$_bonusCount',
                          '$_bonusExcLimit',
                        ),
                        style: TextStyle(
                          fontFamily: appFont,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                  _buildInputRow(
                    t.includeBonusRow,
                    _bonusIncControllers.take(_bonusCount).toList(),
                    Colors.blue,
                    columns: _bonusCount,
                    isBonus: true,
                    isInclude: true,
                  ),
                  const SizedBox(height: 20),
                  _buildInputRow(
                    t.excludeBonusRow,
                    _bonusExcControllers.take(_bonusExcLimit).toList(),
                    Colors.red,
                    isBonus: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternFilterSection() {
    return Container(
      decoration: BoxDecoration(
        color: _boxWhite,
        border: Border(bottom: BorderSide(color: _brandYellow, width: 2)),
      ),
      child: Column(
        children: [
          _buildSectionHeader(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAlignedCheckBox(
                  value: _isAllSelected,
                  onChanged: (v) => _toggleAllFilters(v),
                ),
                const SizedBox(width: 3),
                Text(
                  t.patternFilters,
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _onFilterChanged();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _boxWhite,
                foregroundColor: const Color(0xFF07BA0F),
                minimumSize: const Size(58, 30),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                t.apply,
                style: TextStyle(
                  fontFamily: appFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 30),
            child: Column(
              children: [
                for (final (i, item) in _filterItems().indexed) ...[
                  if (item.section != null &&
                      (i == 0 || _filterItems()[i - 1].section != item.section))
                    _buildFilterSectionTitle(item.section!),
                  _buildStripedFilterRow(
                    index: i,
                    title: item.title,
                    help: item.help,
                    value: item.value,
                    onChanged: (v) => setState(() => item.set(v)),
                  ),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSectionTitle(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
    child: Row(
      children: [
        const Icon(Icons.tune_rounded, size: 18, color: Color(0xFFE0A800)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: appFont,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF282727),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildProbabilityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: _headerRule()),
        const SizedBox(width: 8),
        Text(
          t.remainingCombos,
          style: TextStyle(
            fontFamily: appFont,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Color(0xFF282727),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(child: _headerRule()),
      ],
    );
  }

  /// 머리글 양옆 선: 최대 98, 공간이 부족하면 줄어듭니다.
  Widget _headerRule() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 98),
    child: Container(height: 1.2, color: const Color(0xFF282727)),
  );

  /// 상단 복권 선택 버튼
  Widget _buildGameSelector() {
    final game = _activeGame;
    return GestureDetector(
      onTap: _games.length > 1 ? _showGamePicker : null,
      child: Container(
        height: 46,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: const Color(0xFFE9D52B), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flagOf(game.country), style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  game.displayName(_lang),
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF282727),
                  ),
                ),
              ),
            ),
            if (_games.length > 1) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down_rounded,
                size: 32,
                color: Color(0xFF555555),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showGamePicker() {
    FocusScope.of(context).unfocus();
    final fmt = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Text(
                  t.chooseLottery,
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final g in _games)
                      ListTile(
                        leading: Text(
                          flagOf(g.country),
                          style: const TextStyle(fontSize: 26),
                        ),
                        title: Text(
                          g.displayName(_lang),
                          style: TextStyle(
                            fontFamily: appFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          _gameSummary(g, fmt),
                          style: TextStyle(
                            fontFamily: appFont,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            height: 1.4,
                          ),
                        ),
                        trailing: g.id == _activeGame.id
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF07BA0F),
                              )
                            : null,
                        onTap: () {
                          Navigator.of(context).pop();
                          _selectGame(g);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// 예) "번호 5개(1~69) + 파워볼 1개(1~26)\n1등 확률 1/292,201,338 · 당첨번호 1,419회"
  String _gameSummary(GameConfig g, NumberFormat fmt) {
    final rule = StringBuffer(t.gameRule('${g.main.count}', '${g.main.max}'));
    if (g.hasPlayerBonus) {
      rule.write(
        t.gameRuleBonus(
          g.bonus.label[_lang] ?? g.bonus.label['en'] ?? '',
          '${g.bonus.count}',
          '${g.bonus.max}',
        ),
      );
    }
    final draws = _drawsOf(g.id).length;
    final drawText = draws > 0
        ? t.drawCount(fmt.format(draws))
        : t.drawsPending;
    return '$rule\n${t.jackpotOdds(fmt.format(g.jackpotOddsDenominator))} · $drawText';
  }

  /// 오른쪽 상단 지구본 버튼: 누르면 언어 선택 창
  Widget _buildLanguageButton() {
    final code = LottoApp.localeOverride(context)?.languageCode;
    return Tooltip(
      message: t.language,
      child: Material(
        color: Colors.white,
        shape: const StadiumBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: _showLanguagePicker,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language_rounded,
                  size: 24,
                  color: Color(0xFF282727),
                ),
                const SizedBox(width: 4),
                Text(
                  languageFlags[code] ?? '📱',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFixedTopSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 171,
          child: Container(color: _brandYellow),
        ),
        Column(
          children: [
            const SizedBox(height: 15),
            _buildLogo(),
            const SizedBox(height: 8),
            _buildGameSelector(),
            const SizedBox(height: 14),
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
                    height: 158,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _boxWhite,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: _brandYellow, width: 4),
                    ),
                    child: _isCalculating
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  t.calculating,
                                  style: TextStyle(
                                    fontFamily: appFont,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildProbabilityHeader(),
                              const SizedBox(height: 6),
                              // 해외 복권은 9자리(예: 292,201,338)라 한 줄에 맞게 줄여 표시
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CountUpNumber(
                                  value: _targetRemaining,
                                  style: TextStyle(
                                    fontFamily: appFont,
                                    fontSize: 56,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: -1.0,
                                    height: 0.96,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 270,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: CountUpNumber(
                                            value: _targetExcluded,
                                            style: TextStyle(
                                              fontFamily: appFont,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue,
                                            ),
                                            isMinus: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: CountUpPercent(
                                            value: _targetPercent,
                                            style: TextStyle(
                                              fontFamily: appFont,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: _executeSearch,
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: _brandYellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '[ ',
                            style: TextStyle(
                              fontFamily: appFont,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: _extractCountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: _roundInputFormatters,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: appFont,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.blue,
                              ),
                              decoration: InputDecoration(
                                hintText: t.countHint,
                                hintStyle: TextStyle(
                                  fontFamily: appFont,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blue,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Text(
                            ' ] ',
                            style: TextStyle(
                              fontFamily: appFont,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _isExtracting ? t.extracting : t.extractButton,
                            style: TextStyle(
                              fontFamily: appFont,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
        // 오른쪽 상단 언어 변경 (지구본)
        Positioned(top: 10, right: 12, child: _buildLanguageButton()),
      ],
    );
  }

  Widget _buildSectionHeader(Widget titleWidget, Widget trailingWidget) {
    return Container(
      color: _brandYellow,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [titleWidget, trailingWidget],
      ),
    );
  }

  Widget _buildBallRow(String label, List<int> nums, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: appFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_mainCount, (index) {
                  final dynamic item = nums.isEmpty
                      ? '?'
                      : (nums.length > index ? nums[index] : 0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildLottoBall(item),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    List<TextEditingController> controllers,
    Color labelColor, {
    int columns = 6,
    bool isBonus = false,
    bool isInclude = false,
  }) {
    final selectedNums = controllers
        .map((c) => int.tryParse(c.text.trim()))
        .whereType<int>()
        .toList();

    final int rowCount = (controllers.length / columns).ceil();

    return GestureDetector(
      onTap: () => _showNumberPickerDialog(
        controllers,
        isBonus: isBonus,
        isInclude: isInclude,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(rowCount, (rowIndex) {
            final int start = rowIndex * columns;

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex == rowCount - 1 ? 0 : 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 105,
                    child: rowIndex == 0
                        ? FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              label,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: appFont,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: labelColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(columns, (index) {
                          final int globalIndex = start + index;
                          final dynamic item = globalIndex < selectedNums.length
                              ? selectedNums[globalIndex]
                              : '?';

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: isBonus && item is int
                                ? _buildBonusBall(item)
                                : _buildLottoBall(item),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _applySelectedNumbers(
    List<TextEditingController> targetControllers,
    Set<int> numbers,
  ) {
    final sorted = numbers.toList()..sort();
    for (int i = 0; i < targetControllers.length; i++) {
      targetControllers[i].text = i < sorted.length ? sorted[i].toString() : '';
    }
  }

  Future<void> _showNumberPickerDialog(
    List<TextEditingController> targetControllers, {
    bool isBonus = false,
    required bool isInclude,
  }) async {
    FocusScope.of(context).unfocus();

    final String kind = isBonus ? _bonusLabel : t.numbersWord;
    final String title = isInclude
        ? t.pickerInclude(kind)
        : t.pickerExclude(kind);
    final Color activeColor = isInclude ? Colors.blue : Colors.red;
    final int maxSelectable = isBonus
        ? (isInclude ? _bonusCount : _bonusExcLimit)
        : (isInclude ? _mainCount : 18);
    final int maxNumber = isBonus ? _bonusMax : _mainMax;

    final Set<int> tempSelected = targetControllers
        .map((c) => int.tryParse(c.text.trim()))
        .whereType<int>()
        .toSet();

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: t.close,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            void toggleNumber(int number) {
              final otherNumbers =
                  (isBonus
                          ? (isInclude
                                ? _bonusExcControllers
                                : _bonusIncControllers)
                          : (isInclude ? _excControllers : _incControllers))
                      .map((c) => int.tryParse(c.text.trim()))
                      .whereType<int>()
                      .toSet();

              if (!tempSelected.contains(number) &&
                  otherNumbers.contains(number)) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t.pickerConflict('$number'),
                      style: TextStyle(fontFamily: appFont),
                    ),
                  ),
                );
                return;
              }

              if (!tempSelected.contains(number) &&
                  tempSelected.length >= maxSelectable) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t.pickerMax('$maxSelectable'),
                      style: TextStyle(fontFamily: appFont),
                    ),
                  ),
                );
                return;
              }

              dialogSetState(() {
                if (tempSelected.contains(number)) {
                  tempSelected.remove(number);
                } else {
                  tempSelected.add(number);
                }
              });

              _applySelectedNumbers(targetControllers, tempSelected);

              if (mounted) {
                setState(() {});
              }
            }

            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.72,
                  constraints: BoxConstraints(
                    maxWidth: 390,
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _brandYellow, width: 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE9D52B),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                              ),
                            ),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: appFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF424142),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -18,
                            top: -18,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: GridView.count(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
                          crossAxisCount: 7,
                          shrinkWrap: true,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.56,
                          children: List.generate(maxNumber, (index) {
                            final n = index + 1;
                            final selected = tempSelected.contains(n);

                            return GestureDetector(
                              onTap: () => toggleNumber(n),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: const Size(28, 52),
                                    painter: _CornerBoxPainter(
                                      color: selected
                                          ? activeColor
                                          : Colors.black,
                                      strokeWidth: selected ? 2.2 : 1.8,
                                      cornerLength: 10,
                                      fillColor: selected
                                          ? activeColor.withValues(alpha: 0.28)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    '$n',
                                    style: TextStyle(
                                      fontFamily: appFont,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  Widget _buildAlignedCheckBox({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Checkbox(
        value: value,
        activeColor: Colors.blue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        onChanged: (v) => onChanged(v ?? false),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildFilterRow(
    String title,
    bool val,
    Function(bool) onChanged, {
    String? help,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAlignedCheckBox(value: val, onChanged: (v) => onChanged(v)),
        const SizedBox(width: 3),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontFamily: appFont,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF424142),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () => _showHelpDialog(title, help),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStripedFilterRow({
    required int index,
    required String title,
    String? help,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: index.isOdd ? const Color(0xFFEBEBEB) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _buildFilterRow(title, value, onChanged, help: help),
    );
  }

  Widget _buildLottoBall(dynamic item) {
    if (item == 0) return const SizedBox(width: 28, height: 28);

    if (item == '?') {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '?',
          style: TextStyle(
            fontFamily: appFont,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      );
    }

    final int num = item as int;
    Color bgColor;

    if (num <= 10) {
      bgColor = const Color(0xFFFFC107);
    } else if (num <= 20) {
      bgColor = const Color(0xFF29B6F6);
    } else if (num <= 30) {
      bgColor = _ballOrange;
    } else if (num <= 40) {
      bgColor = const Color(0xFF9E9E9E);
    } else if (num <= 50) {
      bgColor = const Color(0xFF4CAF50);
    } else {
      bgColor = const Color(0xFFB39DDB);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$num',
        style: TextStyle(
          fontFamily: appFont,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _FilterItem {
  final String title;
  final String help;
  final bool value;
  final void Function(bool) set;

  /// 소제목 (해외 복권 추가 필터·보조 번호 필터). null 이면 기본 목록
  final String? section;

  const _FilterItem(
    this.title,
    this.help,
    this.value,
    this.set, {
    this.section,
  });
}

/// 화면에서 고른 번호: 메인 포함·제외 + 보조 번호 포함·제외
typedef _Picks = ({
  List<int> inc,
  List<int> exc,
  List<int> bonusInc,
  List<int> bonusExc,
});
