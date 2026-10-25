// 처음 실행 화면: ① 언어 선택 → ② 간단 가입 (닉네임 + 연령 확인 + 약관 동의)
// 고른 언어는 바로 적용·저장되어 다음 실행부터는 묻지 않습니다.

import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../l10n/app_localizations.dart';
import 'app_style.dart';

/// 언어 이름은 각 언어로 표기 (사용자가 자기 언어를 찾기 쉽게)
const Map<String, String> languageNames = {
  'ko': '한국어',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'de': 'Deutsch',
  'ja': '日本語',
  'vi': 'Tiếng Việt',
};

class OnboardingPage extends StatefulWidget {
  /// 현재 적용된 언어 코드 (기기 언어 기준 기본값)
  final String currentLanguage;
  final void Function(String languageCode) onLanguageChosen;
  final VoidCallback onFinished;

  const OnboardingPage({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChosen,
    required this.onFinished,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;
  final _nickname = TextEditingController();
  bool _age = false;
  bool _agree = false;
  bool _saving = false;
  String? _nicknameError;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _finish(AppLocalizations t) async {
    final name = _nickname.text.trim();
    if (!UserProfile.validNickname(name)) {
      setState(() => _nicknameError = t.obNicknameError);
      return;
    }
    if (!_age || !_agree) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.obNeedChecks)));
      return;
    }
    setState(() => _saving = true);
    await UserStore.saveProfile(UserProfile(name, DateTime.now()));
    if (mounted) widget.onFinished();
  }

  void _showPolicies(AppLocalizations t) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(
          '${t.privacyPolicy} · ${t.disclaimer}',
          style: TextStyle(fontFamily: appFont, fontSize: 17),
        ),
        content: SingleChildScrollView(
          child: Text(
            '${t.privacyText}\n\n──────\n\n${t.disclaimerText}',
            style: TextStyle(fontFamily: appFont, fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(t.close)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    appFont = Localizations.localeOf(context).languageCode == 'ko'
        ? 'Esamanru'
        : null;

    return Scaffold(
      backgroundColor: brandYellow,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  Image.asset('assets/images/app_logo.png', height: 52),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: _step == 0 ? _languageStep(t) : _profileStep(t),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: appFont,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _body(String text) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: appFont,
      fontSize: 14,
      height: 1.5,
      color: const Color(0xFF555555),
    ),
  );

  Widget _primaryButton(String label, VoidCallback? onPressed) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: brandYellowDark,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: appFont,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  Widget _languageStep(AppLocalizations t) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _title(t.obWelcome),
        const SizedBox(height: 8),
        _body(t.obChooseLanguage),
        const SizedBox(height: 14),
        RadioGroup<String>(
          groupValue: widget.currentLanguage,
          onChanged: (v) {
            if (v != null) widget.onLanguageChosen(v);
          },
          child: Column(
            children: [
              for (final e in languageNames.entries)
                RadioListTile<String>(
                  value: e.key,
                  title: Row(
                    children: [
                      LanguageFlag(e.key, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: languageNameFont(e.key),
                        ),
                      ),
                    ],
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _primaryButton(t.obNext, () {
          // 기본값(기기 언어)을 그대로 써도 저장해 두어 다음 실행부터 같은 언어로 엽니다.
          widget.onLanguageChosen(widget.currentLanguage);
          setState(() => _step = 1);
        }),
      ],
    );
  }

  Widget _profileStep(AppLocalizations t) {
    final style = TextStyle(fontFamily: appFont, fontSize: 14);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _title(t.obProfileTitle),
        const SizedBox(height: 8),
        _body(t.obProfileBody),
        const SizedBox(height: 18),
        TextField(
          controller: _nickname,
          maxLength: 12,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_nicknameError != null) setState(() => _nicknameError = null);
          },
          decoration: InputDecoration(
            labelText: t.obNickname,
            hintText: t.obNicknameHint,
            errorText: _nicknameError,
            border: const OutlineInputBorder(),
          ),
        ),
        CheckboxListTile(
          value: _age,
          onChanged: (v) => setState(() => _age = v ?? false),
          title: Text(t.obAge, style: style),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        CheckboxListTile(
          value: _agree,
          onChanged: (v) => setState(() => _agree = v ?? false),
          title: Text(t.obAgree, style: style),
          secondary: TextButton(
            onPressed: () => _showPolicies(t),
            child: Text(t.obView),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        const SizedBox(height: 12),
        _primaryButton(t.obStart, _saving ? null : () => _finish(t)),
        TextButton(
          onPressed: () => setState(() => _step = 0),
          child: Text(t.obBack),
        ),
      ],
    );
  }
}
