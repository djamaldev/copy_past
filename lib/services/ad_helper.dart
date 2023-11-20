import 'dart:io';

//ca-app-pub-3940256099942544/1033173712
class AdHelper {
  static String get banerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7897101252102419/9657794714';
      /*test ad*/
      //return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7897101252102419/8864622641';
      /*test ad*/
      //return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get OpenAppAdAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7897101252102419/2295344865';
      /*test ad*/
      //return 'ca-app-pub-3940256099942544/3419835294';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
