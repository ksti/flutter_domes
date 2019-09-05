import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import '../../../../../common/theme/ThemeManager.dart';

enum ThemeEvent { toggle }

class ThemeBloc3 extends Bloc<ThemeEvent, ThemeData> {
  @override
  ThemeData get initialState => ThemeManager.manager.lightTheme.data;

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.toggle:
        yield currentState == ThemeManager.manager.darkTheme.data
            ? ThemeManager.manager.lightTheme.data
            : ThemeManager.manager.darkTheme.data;
        break;
    }
  }
}