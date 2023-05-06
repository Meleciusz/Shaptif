
import 'package:flutter/cupertino.dart';

import 'SharedPreferences.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class ShowEmbeddedProvider with ChangeNotifier {
  ShowEmbeddedPreference showEmbeddedPreference = ShowEmbeddedPreference();
  bool _showEmbedded = true;

  bool get showEmbedded => _showEmbedded;

  set showEmbedded(bool value) {
    _showEmbedded = value;
    showEmbeddedPreference.setShowEmbedded(value);
    notifyListeners();
  }
}