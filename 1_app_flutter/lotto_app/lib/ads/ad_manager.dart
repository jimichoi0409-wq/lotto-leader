// 광고 동의(UMP) → 광고 SDK 초기화 → 전면·보상형 광고 미리 불러오기를 담당합니다.
//
// 원칙
// - 동의 절차(유럽·영국·스위스, 미국 일부 주 등은 Google 동의 화면)를 마친 뒤에만 광고를 요청합니다.
// - 광고가 없거나 실패해도 앱 기능은 그대로 동작합니다 (광고 때문에 사용자를 막지 않음).

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_config.dart';

class AdManager {
  AdManager._();
  static final AdManager instance = AdManager._();

  /// 광고를 요청해도 되는 상태인지 (동의 완료 + SDK 초기화 완료)
  final ValueNotifier<bool> canShowAds = ValueNotifier(false);

  /// 설정 화면에 "광고 개인정보 설정" 을 보여야 하는지 (유럽 등 동의 지역)
  final ValueNotifier<bool> privacyOptionsRequired = ValueNotifier(false);

  bool _started = false;
  bool _sdkInitialized = false;
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  int _extractions = 0;
  bool _isFirstDay = true;

  /// 앱 시작 시 한 번 호출. 동의 화면이 필요한 지역이면 여기서 표시됩니다.
  Future<void> start() async {
    if (!adsSupported || _started) return;
    _started = true;
    _isFirstDay = await _checkFirstDay();

    final params = ConsentRequestParameters(
      consentDebugSettings: umpDebugEea && !kReleaseMode
          ? ConsentDebugSettings(
              debugGeography: DebugGeography.debugGeographyEea,
            )
          : null,
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () => ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) debugPrint('광고 동의 화면 오류: ${error.message}');
        _afterConsent();
      }),
      (FormError error) {
        // 동의 정보 갱신 실패 시에도 이전 세션의 동의 상태로 광고 가능 여부를 판단합니다.
        debugPrint('광고 동의 정보 갱신 실패: ${error.message}');
        _afterConsent();
      },
    );
  }

  Future<void> _afterConsent() async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    privacyOptionsRequired.value =
        status == PrivacyOptionsRequirementStatus.required;

    if (!await ConsentInformation.instance.canRequestAds()) return;
    if (!_sdkInitialized) {
      _sdkInitialized = true;
      await MobileAds.instance.initialize();
    }
    canShowAds.value = true;
    _loadInterstitial();
    _loadRewarded();
  }

  /// 설정 → "광고 개인정보 설정": 사용자가 동의를 바꿀 수 있는 Google 양식
  void showPrivacyOptions() {
    ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (error != null) debugPrint('광고 개인정보 설정 오류: ${error.message}');
      _afterConsent();
    });
  }

  /// 설치 후 첫날은 전면 광고를 보여 주지 않습니다 (첫인상 보호).
  Future<bool> _checkFirstDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final first = prefs.getString('firstLaunchDate');
      if (first == null) {
        await prefs.setString('firstLaunchDate', today);
        return true;
      }
      return first == today;
    } catch (_) {
      return true;
    }
  }

  // ---------------- 전면 광고 ----------------

  void _loadInterstitial() {
    if (!canShowAds.value) return;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (error) {
          debugPrint('전면 광고 로드 실패: ${error.message}');
          _interstitial = null;
        },
      ),
    );
  }

  /// 번호 추출 직후, 결과를 보여 주기 전에 호출.
  /// N번째 추출마다 한 번, 설치 첫날은 제외. 광고가 닫힐 때까지 기다린 뒤 돌아옵니다.
  /// 이번 추출에서 이미 보상형 광고를 봤다면 연달아 광고를 띄우지 않고 횟수도 처음부터 셉니다.
  Future<void> maybeShowInterstitial({bool afterRewarded = false}) async {
    if (afterRewarded) {
      _extractions = 0;
      return;
    }
    _extractions++;
    final ad = _interstitial;
    if (!canShowAds.value ||
        _isFirstDay ||
        ad == null ||
        _extractions % interstitialEveryNExtractions != 0) {
      return;
    }

    _interstitial = null;
    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
        if (!closed.isCompleted) closed.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadInterstitial();
        if (!closed.isCompleted) closed.complete();
      },
    );
    await ad.show();
    await closed.future;
  }

  // ---------------- 보상형 광고 ----------------

  void _loadRewarded() {
    if (!canShowAds.value) return;
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (error) {
          debugPrint('보상형 광고 로드 실패: ${error.message}');
          _rewarded = null;
        },
      ),
    );
  }

  /// 지금 보상형 광고를 보여 줄 수 있는지
  bool get rewardedReady => canShowAds.value && _rewarded != null;

  /// 보상형 광고를 보여 주고, 끝까지 봐서 보상을 받았으면 true.
  Future<bool> showRewarded() async {
    final ad = _rewarded;
    if (!canShowAds.value || ad == null) return false;

    _rewarded = null;
    var earned = false;
    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewarded();
        if (!closed.isCompleted) closed.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewarded();
        if (!closed.isCompleted) closed.complete();
      },
    );
    await ad.show(onUserEarnedReward: (_, _) => earned = true);
    await closed.future;
    return earned;
  }
}
