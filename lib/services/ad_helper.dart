import 'dart:io';

class AdHelper {
  static String homePageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      return "";
    }
  }

  static String detailsPageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      return "";
    }
  }

  static String fullPageAd() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      return "";
    }
  }
}
