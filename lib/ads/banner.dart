import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  BannerAd? _bannerAd;
  BannerAd? _largeBannerAd;
  BannerAd? _smallBannerAd;

  void loadBannerAd(Function onAdLoaded, Function onAdFailedToLoad) {
    _bannerAd = BannerAd(
      adUnitId: '#',
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          onAdFailedToLoad(error);
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadLargeBannerAd(Function onAdLoaded, Function onAdFailedToLoad) {
    _largeBannerAd = BannerAd(
      adUnitId: '#',
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          onAdFailedToLoad(error);
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadSmallBannerAd(Function onAdLoaded, Function onAdFailedToLoad) {
    _smallBannerAd = BannerAd(
      adUnitId: '#',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          onAdFailedToLoad(error);
          ad.dispose();
        },
      ),
    )..load();
  }

  BannerAd? get bannerAd => _bannerAd;
  BannerAd? get largeBannerAd => _largeBannerAd;
  BannerAd? get smallBannerAd => _smallBannerAd;

  void dispose() {
    _bannerAd?.dispose();
    _largeBannerAd?.dispose();
    _smallBannerAd?.dispose();
  }
}
