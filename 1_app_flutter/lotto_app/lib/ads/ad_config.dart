// 광고 단위 ID 설정.
//
// AdMob 계정을 만든 뒤 아래 _release* 값에 실제 광고 단위 ID 를 넣으세요.
// - 실제 ID 는 "릴리스 빌드" 에서만 쓰입니다. 개발(디버그) 중에는 항상 Google 테스트 광고가 나옵니다.
//   개발 중 실제 광고를 보거나 누르면 무효 트래픽으로 계정이 정지될 수 있기 때문입니다.
// - 값이 비어 있으면 릴리스 빌드도 테스트 광고를 씁니다 (수익은 없지만 정책 위반도 아님).
// - 앱 ID(ca-app-pub-...~...)는 여기가 아니라 android/gradle.properties 와 ios/Flutter/AdMob.xcconfig 에 넣습니다.

import 'dart:io';

import 'package:flutter/foundation.dart';

// ---- 실제 광고 단위 ID (AdMob 콘솔 → 앱 → 광고 단위) ----
const String _releaseBannerAndroid = 'ca-app-pub-3679955202953976/7845434998';
const String _releaseInterstitialAndroid =
    'ca-app-pub-3679955202953976/7313071629';
const String _releaseRewardedAndroid = 'ca-app-pub-3679955202953976/5019961107';
const String _releaseBannerIos = '';
const String _releaseInterstitialIos = '';
const String _releaseRewardedIos = '';

// ---- Google 공식 테스트 광고 단위 ID (2026-10 확인) ----
// https://developers.google.com/admob/android/test-ads
// https://developers.google.com/admob/ios/test-ads
const String _testBannerAndroid = 'ca-app-pub-3940256099942544/9214589741';
const String _testInterstitialAndroid =
    'ca-app-pub-3940256099942544/1033173712';
const String _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
const String _testBannerIos = 'ca-app-pub-3940256099942544/2435281174';
const String _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';
const String _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';

/// 스토어 스크린샷 촬영용 빌드에서는 광고를 끕니다:
///   flutter build apk --dart-define=SCREENSHOT_MODE=true
const bool screenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');

/// 광고를 띄울 수 있는 플랫폼인지 (웹·데스크톱은 광고 없음)
bool get adsSupported =>
    !screenshotMode && !kIsWeb && (Platform.isAndroid || Platform.isIOS);

String _pick(String release, String test) =>
    kReleaseMode && release.isNotEmpty ? release : test;

String get bannerAdUnitId => Platform.isIOS
    ? _pick(_releaseBannerIos, _testBannerIos)
    : _pick(_releaseBannerAndroid, _testBannerAndroid);

String get interstitialAdUnitId => Platform.isIOS
    ? _pick(_releaseInterstitialIos, _testInterstitialIos)
    : _pick(_releaseInterstitialAndroid, _testInterstitialAndroid);

String get rewardedAdUnitId => Platform.isIOS
    ? _pick(_releaseRewardedIos, _testRewardedIos)
    : _pick(_releaseRewardedAndroid, _testRewardedAndroid);

// ---- 노출 규칙 (기획서 8단계) ----

/// 번호 추출 몇 번마다 전면 광고를 한 번 보여 줄지
const int interstitialEveryNExtractions = 2;

/// 한 번에 이 개수까지는 광고 없이 추출. 더 많이 뽑으려면 보상형 광고를 보고 추출합니다.
const int freeExtractLimit = 10;

/// 광고 동의 화면을 유럽 사용자처럼 테스트하려면:
///   flutter run --dart-define=UMP_DEBUG_EEA=true
const bool umpDebugEea = bool.fromEnvironment('UMP_DEBUG_EEA');
