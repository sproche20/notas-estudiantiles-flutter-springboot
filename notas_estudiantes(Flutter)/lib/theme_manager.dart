import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  // Guardamos el estado actual del tema (por defecto es claro)
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // Cambiar el estado del tema
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners(); // Notificar a los widgets que escuchan
  }
}
