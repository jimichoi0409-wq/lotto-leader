import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('앱 안 버전 표시가 pubspec.yaml 버전과 같다', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*([0-9.]+)',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    final main = File('lib/main.dart').readAsStringSync();
    expect(main, contains("_appVersion = 'V$version'"));
  });

  test('문의하기에 실제 운영자·이메일이 들어 있다 (자리표시자 없음)', () {
    for (final lang in ['ko', 'en', 'es', 'fr', 'de', 'ja', 'vi']) {
      final arb = File('lib/l10n/app_$lang.arb').readAsStringSync();
      expect(arb, contains('jnhteamsoft@gmail.com'), reason: lang);
      expect(arb, contains('한지성'), reason: lang);
    }
    for (final path in [
      '../../docs/index.html',
      '../../docs/privacy/index.html',
    ]) {
      final html = File(path).readAsStringSync();
      expect(html, isNot(contains('[CONTACT_EMAIL]')), reason: path);
      expect(html, isNot(contains('[DEVELOPER_NAME]')), reason: path);
      expect(html, contains('mailto:jnhteamsoft@gmail.com'), reason: path);
    }
  });
}
