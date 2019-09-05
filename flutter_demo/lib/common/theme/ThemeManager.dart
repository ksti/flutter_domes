import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeManager with ChangeNotifier {
  ThemeManager(this.themeID);
  String themeID;

  static ThemeManager _instance = ThemeManager('zdjs');

  static ThemeManager get manager => _instance;

  /// [ThemeManager] setter which sets the singleton [ThemeManager] instance's [ThemeManager].
  static set manager(ThemeManager m) {
    if (m is ThemeManager) {
      _instance = m;
    }
  }

  AppTheme get darkTheme {
    switch (this.themeID) {
      case 'zdjs':
        return _darkModeZdjs;
        break;
      case 'xlmm':
        return _darkModeXlmm;
        break;

      default:
        return _darkModeZdjs;
    }
  }

  AppTheme get lightTheme {
    switch (this.themeID) {
      case 'zdjs':
        return _lightModeZdjs;
        break;
      case 'xlmm':
        return _lightModeXlmm;
        break;

      default:
        return _lightModeZdjs;
    }
  }

  AppTheme _darkModeZdjs = AppTheme(
      id: "dark_mode_zdjs",
      description:
          '', // 还必须有，因为 AppTheme 内部有 assert(description.length < 30, "Theme description too long ($id)");
      data: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color(0xFF1E1E1E),
            elevation: 1.5,
          ),
          scaffoldBackgroundColor: Color(0xFF121212),
          backgroundColor: Color(0xFF1E1E1E),
          dialogBackgroundColor: Color(0xFF121212),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Color(0xFF121212),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ))),
          textTheme: TextTheme(
            body1: TextStyle(color: Color(0xFFFFFFFF)),
            body2: TextStyle(color: Color(0xFF8A8A8A)),
            title: TextStyle(color: Color(0xFFFFFFFF)),
            subtitle: TextStyle(color: Color(0xFF8A8A8A)),
            caption: TextStyle(color: Color(0xFF8A8A8A)),
            display1: TextStyle(color: Color(0xFFF05A22)),
            display2: TextStyle(color: Color(0xFFFFFFFF)),
            display3: TextStyle(color: Color(0xFF1E1E1E)),
          ),
          cardColor: Color(0xFF1E1E1E),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8A8A8A)),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF05A22)),
                borderRadius: BorderRadius.circular(30.0),
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCE020D)),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCE020D)),
                  borderRadius: BorderRadius.circular(30.0)))));

  AppTheme _lightModeZdjs = AppTheme(
      id: "light_mode_zdjs",
      description: '', // 还必须有
      data: ThemeData.light());

  AppTheme _darkModeXlmm = AppTheme(
      id: "dark_mode_xlmm",
      description: '', // 还必须有
      data: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color(0xFF1E1E1E),
            elevation: 1.5,
          ),
          scaffoldBackgroundColor: Color(0xFF121212),
          backgroundColor: Color(0xFF1E1E1E),
          dialogBackgroundColor: Color(0xFF121212),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Color(0xFF121212),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ))),
          textTheme: TextTheme(
            body1: TextStyle(color: Color(0xFFFFFFFF)),
            body2: TextStyle(color: Color(0xFF8A8A8A)),
            title: TextStyle(color: Color(0xFFFFFFFF)),
            subtitle: TextStyle(color: Color(0xFF8A8A8A)),
            caption: TextStyle(color: Color(0xFF8A8A8A)),
            display1: TextStyle(color: Color(0xFFF05A22)),
            display2: TextStyle(color: Color(0xFFFFFFFF)),
            display3: TextStyle(color: Color(0xFF1E1E1E)),
          ),
          cardColor: Color(0xFF1E1E1E),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8A8A8A)),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF05A22)),
                borderRadius: BorderRadius.circular(30.0),
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCE020D)),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCE020D)),
                  borderRadius: BorderRadius.circular(30.0)))));

  AppTheme _lightModeXlmm = AppTheme(
      id: "light_mode_xlmm",
      description: '', // 还必须有
      data: ThemeData.light());
}
