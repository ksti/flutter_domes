import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super(props);
}

class HomeActionTypeDone extends HomeState {
  final IconData actionIcon;

  HomeActionTypeDone({@required this.actionIcon}) : super([actionIcon]);

  @override
  String toString() => 'HomeActionTypeDone { icon: $actionIcon }';
}

class HomeActionTypeDelete extends HomeState {
  final IconData actionIcon;

  HomeActionTypeDelete({@required this.actionIcon}) : super([actionIcon]);

  @override
  String toString() => 'HomeActionTypeDelete { icon: $actionIcon }';
}