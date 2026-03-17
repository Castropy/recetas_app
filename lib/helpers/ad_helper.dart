import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  // IDs de PRUEBA oficiales de Google (USAR SIEMPRE EN DESARROLLO)
  static const String _androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';

  // TODO: Sustituir estos por tus IDs REALES cuando los tengas en la consola de AdMob
  static const String _androidBannerRealId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _iosBannerRealId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  static String get bannerAdUnitId {
    if (kReleaseMode) {
      // MODO PRODUCCIÓN: Retorna los IDs que generan dinero
      if (Platform.isAndroid) {
        return _androidBannerRealId;
      } else if (Platform.isIOS) {
        return _iosBannerRealId;
      } else {
        throw UnsupportedError('Plataforma no soportada para anuncios');
      }
    } else {
      // MODO DESARROLLO: Retorna IDs de prueba para evitar baneos
      if (Platform.isAndroid) {
        return _androidBannerTestId;
      } else if (Platform.isIOS) {
        return _iosBannerTestId;
      } else {
        throw UnsupportedError('Plataforma no soportada para anuncios');
      }
    }
  }
}