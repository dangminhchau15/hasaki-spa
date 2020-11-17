import 'dart:async';
import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlocListener<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final Function(BaseEvent event) listener;
  T bloc;
  BlocListener({
    @required this.child,
    @required this.listener,
    this.bloc
  });

  @override
  _BlocListenerState createState() => _BlocListenerState<T>();
}

class _BlocListenerState<T> extends State<BlocListener> {
  StreamSubscription subscription;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var bloc = widget.bloc ??  Provider.of<T>(context) as BaseBloc;
    // subscription=null;
    if (subscription == null) {
      subscription = bloc.processEventStream.listen(
        (event) {
          widget.listener(event);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<BaseEvent>.value(
      value: (Provider.of<T>(context) as BaseBloc).processEventStream,
      initialData: null,
      updateShouldNotify: (prev, current) {
        return false;
      },
      child: Consumer<BaseEvent>(
        builder: (context, event, child) {
          return Container(
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose  Bloc Listener');
    if (subscription != null) {
      subscription.cancel();
      subscription=null;
    }
  }
}