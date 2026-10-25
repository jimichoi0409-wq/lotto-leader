// 화면 맨 아래 고정 배너 (적응형). 광고를 쓸 수 없거나 아직 불러오지 못했으면 공간을 차지하지 않습니다.

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ad_manager.dart';

class BannerAdView extends StatefulWidget {
  const BannerAdView({super.key});

  @override
  State<BannerAdView> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAdView> {
  BannerAd? _ad;
  bool _loaded = false;
  int? _loadedForWidth;

  /// 실제로 내려온 광고 크기 (불러온 뒤 알 수 있음)
  AdSize? _shownSize;

  @override
  void initState() {
    super.initState();
    AdManager.instance.canShowAds.addListener(_onAdsAvailabilityChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  void _onAdsAvailabilityChanged() => _load();

  Future<void> _load() async {
    if (!adsSupported || !AdManager.instance.canShowAds.value) return;
    final width = MediaQuery.of(context).size.width.truncate();
    if (_loadedForWidth == width) return;
    _loadedForWidth = width;

    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) return;

    await _ad?.dispose();
    setState(() {
      _loaded = false;
      _shownSize = null;
    });
    _ad = BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          // 큰 적응형은 최대 높이를 미리 잡으므로, 실제 광고 크기만큼만 공간을 씁니다.
          // (위 메뉴와의 빈 틈 제거)
          final shown = await (ad as BannerAd).getPlatformAdSize();
          if (mounted) {
            setState(() {
              _loaded = true;
              _shownSize = shown;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('배너 광고 로드 실패: ${error.message}');
          ad.dispose();
          if (mounted) setState(() => _loaded = false);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    AdManager.instance.canShowAds.removeListener(_onAdsAvailabilityChanged);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    final size = _shownSize ?? ad.size;
    return SafeArea(
      top: false,
      child: SizedBox(
        width: size.width.toDouble(),
        height: size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
