import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd(Function onAdLoaded, Function onAdFailedToLoad) {
    InterstitialAd.load(
      adUnitId: '#',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad(error);
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          print('Ad showed full screen content.');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('Ad dismissed full screen content.');
          ad.dispose();  // Dispose the ad when it is dismissed
          _interstitialAd = null;  // Set to null to load a new one
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Ad failed to show full screen content: $error');
          ad.dispose();
          _interstitialAd = null;  // Set to null to load a new one
        },
      );
      _interstitialAd!.show();
    } else {
      print('Warning: try to show interstitial before it is loaded.');
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
