import 'dart:async';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import '../../home.dart';
import '../../../../../../flutter_demo_route_helper.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc();

  @override
  HomeState get initialState => HomeActionTypeDone(actionIcon: Icons.done);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeChangeActionType) {
      yield currentState is HomeActionTypeDone
          ? HomeActionTypeDelete(actionIcon: Icons.delete)
          : HomeActionTypeDone(actionIcon: Icons.done);
    } else if (event is HomeToCounterPage) {
      // Navigator.pushNamed(context, "module2://count_page");
      FFNavigatorObserver.getInstance().pushNamed("module2://count_page");
    }
  }
}
