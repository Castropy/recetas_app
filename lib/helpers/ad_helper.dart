import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // --- IDs DE PRUEBA OFICIALES ---
  static const String _androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';
  static const String _androidInterstitialTestId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialTestId = 'ca-app-pub-3940256099942544/4411468910';

  // --- TUS IDs REALES (RECETAS APP) ---
  static const String _androidBannerRealId = 'ca-app-pub-6576213341321650/7948394580';
  static const String _androidInterstitialRealId = 'ca-app-pub-6576213341321650/5435011965';

  // Getter para el Banner
  static String get bannerAdUnitId => kReleaseMode 
    ? (Platform.isAndroid ? _androidBannerRealId : '') // Dejar vacío si no tienes ID de iOS aún
    : (Platform.isAndroid ? _androidBannerTestId : _iosBannerTestId);

  // Getter para el Intersticial
  static String get interstitialAdUnitId => kReleaseMode
    ? (Platform.isAndroid ? _androidInterstitialRealId : '') 
    : (Platform.isAndroid ? _androidInterstitialTestId : _iosInterstitialTestId);

  /// Carga y muestra un anuncio a pantalla completa de forma inmediata
  static void showInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
          
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
            onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose(),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}