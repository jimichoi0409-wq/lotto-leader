// 처음 실행 화면: 언어 선택 → 간단 가입 흐름 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/data/user_store.dart';
import 'package:lotto_app/l10n/app_localizations.dart';
import 'package:lotto_app/ui/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('언어 선택 → 닉네임·동의 확인 → 가입 저장', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final chosen = <String>[];
    var finished = false;
    var language = 'ko';

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => MaterialApp(
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingPage(
            currentLanguage: language,
            onLanguageChosen: (c) {
              chosen.add(c);
              setState(() => language = c);
            },
            onFinished: () => finished = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // ① 언어: English 를 고르면 화면이 바로 영어로
    expect(find.text('로또대장에 오신 것을 환영합니다'), findsOneWidget);
    // 언어 앞에 대표 국기
    expect(find.text('🇰🇷'), findsOneWidget);
    expect(find.text('🇩🇪'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Lotto Leader'), findsOneWidget);
    // 국기가 붙어 목록이 길어졌으므로 버튼이 보이게 스크롤한 뒤 누름
    await tester.ensureVisible(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(chosen.last, 'en', reason: 'Next 를 누르면 현재 언어를 저장');

    // ② 가입: 닉네임 없이 시작하면 오류
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(
      find.text('Please enter a nickname of 2–12 characters.'),
      findsOneWidget,
    );
    expect(finished, isFalse);

    // 닉네임만 넣고 동의하지 않으면 안내
    await tester.enterText(find.byType(TextField), 'Lucky7');
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('Please confirm all required items.'), findsOneWidget);
    expect(finished, isFalse);

    // 두 항목 동의 후 시작
    await tester.tap(find.byType(Checkbox).at(0));
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(finished, isTrue);
    expect((await UserStore.profile())!.nickname, 'Lucky7');
  });
}
