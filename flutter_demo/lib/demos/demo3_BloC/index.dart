import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart'
    as ffAnnotationRoute;

// custom packages
import 'package:no_route/no_route.dart';
import 'package:user_repository/user_repository.dart';

import '../../generated/i18n.dart';
import 'modules/module1/blocs/theme_bloc.dart';
import '../../flutter_demo_route.dart';
import '../../flutter_demo_route_helper.dart';

import 'modules/module1/authentication.dart';
import 'modules/module1/ui/pages/splash/splash.dart';
import 'modules/module1/login.dart';
import 'modules/module1/home.dart';
import 'modules/module1/common/common.dart';

class MyAppDemo3Bloc extends StatelessWidget {
  MyAppDemo3Bloc({Key key}) : super(key: key) {
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
    final userRepository = UserRepository();
    return BlocProvider<ThemeBloc3>(
      builder: (context) => ThemeBloc3(),
      child: BlocBuilder<ThemeBloc3, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'Flutter Demo3',
            navigatorObservers: [FFNavigatorObserver.getInstance()],
            initialRoute: "demo3://index",
            onGenerateRoute: (RouteSettings settings) {
              var routeResult = getRouteResult(
                  name: settings.name, arguments: settings.arguments);

              if (routeResult.showStatusBar != null ||
                  routeResult.routeName != null) {
                settings = FFRouteSettings(
                    arguments: settings.arguments,
                    name: settings.name,
                    isInitialRoute: settings.isInitialRoute,
                    routeName: routeResult.routeName,
                    showStatusBar: routeResult.showStatusBar);
              }

              var page = routeResult.widget ?? NoRoute();

              switch (routeResult.pageRouteType) {
                case PageRouteType.material:
                  return MaterialPageRoute(
                      settings: settings, builder: (c) => page);
                case PageRouteType.cupertino:
                  return CupertinoPageRoute(
                      settings: settings, builder: (c) => page);
                case PageRouteType.transparent:
                  return FFTransparentPageRoute(
                      settings: settings,
                      pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) =>
                          page);
                default:
                  return Platform.isIOS
                      ? CupertinoPageRoute(
                          settings: settings, builder: (c) => page)
                      : MaterialPageRoute(
                          settings: settings, builder: (c) => page);
              }
            },
            // title: I18n.of(context).greetTo('Flutter Demo'), // 在这里时还未初始化，null
            localizationsDelegates: [
              i18n,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: i18n.supportedLocales,
            localeResolutionCallback:
                i18n.resolution(fallback: new Locale("en", "US")),
            home: BlocProvider<AuthenticationBloc>(
              builder: (context) {
                return AuthenticationBloc(userRepository: userRepository)
                  ..dispatch(AppStarted());
              },
              child: BlocProvider<HomeBloc>(
                builder: (context) {
                  return HomeBloc();
                },
                child: MyAppDemo3Home(userRepository: userRepository),
              ),
            ),
            theme: theme,
          );
        },
      ),
    );
  }
}

@ffAnnotationRoute.FFRoute(
  name: "demo3://index",
  routeName: "MyAppDemo3Home",
)
class MyAppDemo3Home extends StatelessWidget {
  final UserRepository userRepository;
  MyAppDemo3Home({Key key, @required this.userRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return HomePage();
        }
        if (state is AuthenticationUnauthenticated) {
          return LoginPage(userRepository: userRepository);
        }
        if (state is AuthenticationLoading) {
          return LoadingIndicator();
        }
        return SplashPage();
      },
    );
  }
}
