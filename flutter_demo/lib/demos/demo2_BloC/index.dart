import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/theme/ThemeManager.dart';
import '../../generated/i18n.dart';
import 'modules/module1/blocs/theme_bloc.dart';
import 'modules/module1/blocs/counter_bloc.dart';
import 'modules/module1/ui/pages/counter_page.dart';

class MyAppDemo2Bloc extends StatelessWidget {
  MyAppDemo2Bloc({Key key}) : super(key: key) {
    I18n.onLocaleChanged = onLocaleChange;
  }

  final i18n = I18n.delegate;

  // Calling this anywhere in your app will now change the app's language
  // I18n.onLocaleChanged(newLocale);
  void onLocaleChange(Locale locale) {
    I18n.locale = locale;
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return ThemeProvider(
      defaultThemeId: 'light_mode_${themeManager.themeID}',
      themes: [
        themeManager.darkTheme, // This is a dark theme
        themeManager.lightTheme, // This is a light theme
      ],
      saveThemesOnChange: true,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        // Do some other task here if you need to
        String savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        }
      },
      child: BlocProvider<ThemeBloc2>(
        builder: (context) => ThemeBloc2(),
        child: BlocBuilder<ThemeBloc2, ThemeData>(
          builder: (context, theme) {
            return MaterialApp(
              title: 'Flutter Demo',
              // title: I18n.of(context).greetTo('Flutter Demo'), // 在这里时还未初始化，null
              localizationsDelegates: [
                i18n,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: i18n.supportedLocales,
              localeResolutionCallback:
                  i18n.resolution(fallback: new Locale("en", "US")),
              home: BlocProvider(
                builder: (context) => CounterBloc2(),
                child: CounterPage(),
              ),
              theme: theme,
            );
          },
        ),
      ),
    );
  }
}
