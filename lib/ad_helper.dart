import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2795434684756178/2208739243";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2795434684756178/5325749370";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
