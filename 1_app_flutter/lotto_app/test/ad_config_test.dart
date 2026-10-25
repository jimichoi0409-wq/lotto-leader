// 개발·테스트 빌드에서는 항상 Google 테스트 광고 ID 를 쓰는지 확인합니다.
// (실제 광고 ID 로 개발 중 광고를 보거나 누르면 AdMob 계정이 정지될 수 있음)

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/ads/ad_config.dart';

void main() {
  const googleTestPublisher = 'ca-app-pub-3940256099942544/';

  test('릴리스가 아닌 빌드는 테스트 광고 ID 사용', () {
    expect(kReleaseMode, isFalse);
    expect(bannerAdUnitId, startsWith(googleTestPublisher));
    expect(interstitialAdUnitId, startsWith(googleTestPublisher));
    expect(rewardedAdUnitId, startsWith(googleTestPublisher));
  });

  test('노출 규칙 값', () {
    expect(interstitialEveryNExtractions, greaterThanOrEqualTo(2));
    expect(freeExtractLimit, greaterThanOrEqualTo(5));
    expect(umpDebugEea, isFalse, reason: '기본 실행에서는 유럽 테스트 모드가 꺼져 있어야 함');
  });

  test('테스트 환경(데스크톱)에서는 광고를 띄우지 않음', () {
    expect(adsSupported, isFalse);
  });
}
