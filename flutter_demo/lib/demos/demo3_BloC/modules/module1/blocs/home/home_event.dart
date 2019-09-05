import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const []]) : super(props);
}

class HomeChangeActionType extends HomeEvent {

  HomeChangeActionType();

  @override
  String toString() =>
      'HomeChangeActionType';
}

class HomeToCounterPage extends HomeEvent {

  HomeToCounterPage();

  @override
  String toString() =>
      'HomeToCounterPage';
}