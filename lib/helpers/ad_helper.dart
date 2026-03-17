import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // --- IDs DE BANNER (Ya los tenías) ---
  static const String _androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';

  // --- IDs DE INTERSTICIAL (PRUEBA) ---
  static const String _androidInterstitialTestId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialTestId = 'ca-app-pub-3940256099942544/4411468910';

  // TODO: Sustituir por IDs REALES antes de subir a la Play Store
  static const String _androidInterstitialRealId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  

  static String get bannerAdUnitId => kReleaseMode 
    ? (Platform.isAndroid ? 'TU_ID_REAL_BANNER' : 'TU_ID_REAL_IOS_BANNER') 
    : (Platform.isAndroid ? _androidBannerTestId : _iosBannerTestId);

  static String get interstitialAdUnitId => kReleaseMode
    ? (Platform.isAndroid ? _androidInterstitialRealId : 'TU_ID_REAL_IOS_INT')
    : (Platform.isAndroid ? _androidInterstitialTestId : _iosInterstitialTestId);

  /// Carga y muestra un anuncio a pantalla completa de forma inmediata
  static void showInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // Tan pronto como carga, lo mostramos
          ad.show();
          
          // Limpiamos la memoria cuando se cierra o falla
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