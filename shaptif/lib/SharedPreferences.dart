import 'package:shared_preferences/shared_preferences.dart';


class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class ShowEmbeddedPreference {
  static const EMBEDDED_STATUS = "SHOWEMBEDDED";

  setShowEmbedded(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(EMBEDDED_STATUS, value);
  }

  Future<bool> getShowEmbedded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(EMBEDDED_STATUS) ?? true;
  }
}
