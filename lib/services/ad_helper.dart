import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7897101252102419/8864622641';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7897101252102419/8119922157';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7897101252102419/2295344865';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7897101252102419/2183416809';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
