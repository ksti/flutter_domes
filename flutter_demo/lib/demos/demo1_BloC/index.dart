import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../generated/i18n.dart';
import '../../common/theme/ThemeManager.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/counter_bloc.dart';

class MyAppDemo1Bloc extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppDemo1Bloc> {
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
          child: BlocProvider(
              child: MyHomePage(title: 'Bloc Demo Home Page'),
              blocs: [CounterBloc()]),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    BlocProvider.of<CounterBloc>(context).first.increment(_counter);
  }

  @override
  void initState() {
    BlocProvider.of<CounterBloc>(context).first.counter.listen((_count) {
      setState(() {
        _counter = _count;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
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
      ),
    );
  }
}
