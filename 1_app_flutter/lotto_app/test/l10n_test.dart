// 번역 파일 검증: 5개 언어가 모두 같은 키를 갖고, 한국어 외 언어에 한글이 섞이지 않았는지 확인합니다.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/l10n/app_localizations.dart';

void main() {
  final hangul = RegExp(r'[가-힣]');
  Map<String, dynamic> arb(String lang) =>
      jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
          as Map<String, dynamic>;
  Set<String> keys(Map<String, dynamic> m) =>
      m.keys.where((k) => !k.startsWith('@')).toSet();

  test('지원 언어 7개', () {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      {'ko', 'en', 'es', 'fr', 'de', 'ja', 'vi'},
    );
  });

  final template = arb('en');
  for (final lang in ['ko', 'es', 'fr', 'de', 'ja', 'vi']) {
    test('$lang: 키와 자리표시자가 영어 원본과 같음', () {
      final m = arb(lang);
      expect(keys(m), keys(template));
      for (final k in keys(template)) {
        final want = RegExp(
          r'\{(\w+)\}',
        ).allMatches(template[k] as String).map((x) => x[1]).toSet();
        final got = RegExp(
          r'\{(\w+)\}',
        ).allMatches(m[k] as String).map((x) => x[1]).toSet();
        expect(got, want, reason: '$lang.$k');
      }
    });
  }

  for (final lang in ['en', 'es', 'fr', 'de', 'ja', 'vi']) {
    test('$lang: 한글이 섞이지 않음', () {
      final m = arb(lang);
      // 운영자 실명(한지성)은 모든 언어에서 그대로 표기하므로 검사에서 뺍니다.
      final mixed = [
        for (final k in keys(m))
          if (hangul.hasMatch((m[k] as String).replaceAll('한지성', ''))) k,
      ];
      expect(mixed, isEmpty);
    });
  }

  test('자리표시자가 실제 값으로 채워짐', () {
    final de = lookupAppLocalizations(const Locale('de'));
    expect(de.fPastFull('5'), 'Gewinnkombinationen ausschließen (5 Treffer)');
    final en = lookupAppLocalizations(const Locale('en'));
    expect(en.jackpotOdds('292,201,338'), 'Jackpot odds 1 in 292,201,338');
    final ko = lookupAppLocalizations(const Locale('ko'));
    expect(ko.includeExcludeHeader('5'), '포함[최대 5개] | 제외[최대 18개] 숫자 지정');
  });

  test('여러 자리표시자의 인자 순서 = 한국어 원문 순서', () {
    final ko = lookupAppLocalizations(const Locale('ko'));
    final fr = lookupAppLocalizations(const Locale('fr'));
    // gameRuleBonus(label, count, max)
    expect(ko.gameRuleBonus('파워볼', '1', '26'), ' + 파워볼 1개(1~26)');
    expect(fr.gameRuleBonus('Powerball', '1', '26'), ' + 1 Powerball (1–26)');
    // bonusHeader(label, max, inc, exc)
    expect(
      ko.bonusHeader('럭키스타', '12', '2', '10'),
      '럭키스타 지정 (1~12, 포함 최대 2개 · 제외 최대 10개)',
    );
    expect(
      fr.bonusHeader('Étoiles', '12', '2', '10'),
      "Étoiles (1–12, inclure jusqu'à 2 · exclure jusqu'à 10)",
    );
    // notNumber(label, raw), outOfRange(label, max), hPastMinus1(k, m)
    expect(ko.outOfRange('포함 숫자', '45'), '포함 숫자: 1부터 45까지의 숫자만 입력할 수 있습니다.');
    expect(fr.hPastMinus1('5', '4'), contains('4 des 5'));
  });
}
