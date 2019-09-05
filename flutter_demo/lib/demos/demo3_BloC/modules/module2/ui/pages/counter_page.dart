import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

import '../../blocs/theme_bloc.dart';
import '../../blocs/counter_bloc.dart';
import '../../../../../../generated/i18n.dart';

@FFRoute(
  name: "module2://count_page",
  routeName: "CounterPage",
)
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc3>(
          builder: (BuildContext context) => CounterBloc3(),
        ),
        BlocProvider<ThemeBloc3>(
          builder: (BuildContext context) => ThemeBloc3(),
        ),
      ],
      child: BlocBuilder<ThemeBloc3, ThemeData>(builder: (context, theme) {
        return new Theme(
          data: theme,
          child: CounterPageChild(),
        );
      }),
    );
  }
}

class CounterPageChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc3 counterBloc = BlocProvider.of<CounterBloc3>(context);
    final ThemeBloc3 themeBloc = BlocProvider.of<ThemeBloc3>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          child: GestureDetector(
              child: Text(I18n.of(context).helloTo('Counter')),
              onTap: () => themeBloc.dispatch(ThemeEvent.toggle)),
        ),
      ),
      body: BlocBuilder<CounterBloc3, int>(
        builder: (context, count) {
          return Center(
            child: Text(
              '$count',
              style: TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              heroTag: null,
              onPressed: () {
                counterBloc.dispatch(CounterEvent.increment);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              heroTag: null,
              onPressed: () {
                counterBloc.dispatch(CounterEvent.decrement);
              },
            ),
          ),
        ],
      ),
    );
  }
}
