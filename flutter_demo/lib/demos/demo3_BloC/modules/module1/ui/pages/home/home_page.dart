import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

import '../../../authentication.dart';
import '../../../home.dart';

@FFRoute(
  name: "module1://home_page",
  routeName: "HomePage",
)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    IconData _actionIcon;

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeActionTypeDone) {
        _actionIcon = state.actionIcon;
      } else {
        _actionIcon = (state as HomeActionTypeDelete).actionIcon;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            AnimatedSwitcher(
              transitionBuilder: (child, anim) {
                return ScaleTransition(child: child, scale: anim);
              },
              duration: Duration(milliseconds: 300),
              child: IconButton(
                  key: ValueKey(_actionIcon),
                  icon: Icon(_actionIcon),
                  onPressed: () {
                    homeBloc.dispatch(HomeChangeActionType());
                  }),
            ),
            IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  // Navigator.pushNamed(context, "module2://count_page");
                  homeBloc.dispatch(HomeToCounterPage());
                }),
          ],
        ),
        body: Container(
          child: Center(
              child: RaisedButton(
            child: Text('logout'),
            onPressed: () {
              authenticationBloc.dispatch(LoggedOut());
            },
          )),
        ),
      );
    });
  }
}
