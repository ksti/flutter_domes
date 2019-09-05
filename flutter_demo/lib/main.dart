import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// custom packages
import 'package:no_route/no_route.dart';

import 'generated/i18n.dart';
import 'flutter_demo_route.dart';
import 'flutter_demo_route_helper.dart';
import 'common/theme/ThemeManager.dart';
import 'common/channel/ChannelHandler.dart';
import 'common/api/ApiConfiger.dart';
import 'demos/demo1_BloC/index.dart';
import 'demos/demo2_BloC/index.dart';
import 'demos/demo3_BloC/index.dart';

// ThemeManager themeManager = ThemeManager('xlmm');

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  // [VERBOSE-2:ui_dart_state.cc(148)] Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  // If you're running an application and need to access the binary messenger before `runApp()` has been called (for example, during plugin initialization), then you need to explicitly call the `WidgetsFlutterBinding.ensureInitialized()` first.
  // If you're running a test, you can call the `TestWidgetsFlutterBinding.ensureInitialized()` as the first line in your test's `main()` method to initialize the binding.
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(_widgetForRoute(window.defaultRouteName));
}

Widget _widgetForRoute(String route) {
  ThemeManager themeManager = ThemeManager(route == '/' ? 'zdjs' : route);
  ThemeManager.manager = themeManager;
  ApiConfiger apiConfiger = ApiConfiger(route);
  ChannelHandler channelHandler = ChannelHandler();
  channelHandler.addListener(() {
    dynamic message = channelHandler.nativeToFlutterValue;
    apiConfiger.handleNativeMessage(message);
  });
  Widget myApp = MyApp();
  switch (route) {
    case 'zdjs':
      myApp = MyAppDemo1Bloc();
      break;
    case 'xlmm':
      myApp = MyAppDemo2Bloc();
      break;
    default:
      myApp = MyAppDemo3Bloc();
      break;
  }
  // return ChangeNotifierProvider.value(
  //   value: themeManager,
  //   child: myApp,
  // );
  return MultiProvider(
    providers: [
      Provider<ApiConfiger>.value(value: apiConfiger),
      ChangeNotifierProvider.value(value: themeManager),
    ],
    child: myApp,
  );
}

/*
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
*/

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final i18n = I18n.delegate;

  @override
  void initState() {
    super.initState();
    I18n.onLocaleChanged = onLocaleChange;
  }

  // Calling this anywhere in your app will now change the app's language
  // I18n.onLocaleChanged(newLocale);
  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
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
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorObservers: [
          FFNavigatorObserver(routeChange: (name) {
            //you can track page here
            print(name);
          }, showStatusBarChange: (bool showStatusBar) {
            if (showStatusBar) {
              SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
            } else {
              SystemChrome.setEnabledSystemUIOverlays([]);
            }
          })
        ],
        initialRoute: "sample://main_page",
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
                  ? CupertinoPageRoute(settings: settings, builder: (c) => page)
                  : MaterialPageRoute(settings: settings, builder: (c) => page);
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
        home: ThemeConsumer(
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
                child: Text(I18n.of(context).helloTo(widget.title)),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) => ThemeConsumer(child: ThemeDialog()))),
          ),
          actions: [CycleThemeIconButton()]),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
