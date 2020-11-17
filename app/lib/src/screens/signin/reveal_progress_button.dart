import 'package:app/src/blocs/sign_in_bloc.dart';
import 'package:app/src/commonview/reveal_progress_button_painter.dart';
import 'package:app/src/screens/signin/progress_button.dart';
import 'package:app/src/utils/function_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnNextPage();
typedef OnPressedButton();

class RevealProgressButton extends StatefulWidget {
  bool isEnable;
  String title;
  OnNextPage onNextPage;
  bool isStartAnimation;
  OnPressedButton onPressedButton;
  RevealProgressButton(
      {this.isEnable,
      @required this.title,
      @required this.onNextPage,
      this.onPressedButton,
      @required this.isStartAnimation});
  @override
  State<StatefulWidget> createState() => _RevealProgressButtonState();
}

class _RevealProgressButtonState extends State<RevealProgressButton>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double _fraction = 0.0;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.isEnable
          ? RevealProgressButtonPainter(_fraction, MediaQuery.of(context).size)
          : null,
      child: ProgressButton(reveal, widget.isEnable,
          title: this.widget.title,
          isStartAnimation: this.widget.isStartAnimation,onPressedButton: (){
            this.widget.onPressedButton();
          },),
    );
  }

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  void reveal() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 0.1, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          print("AnimationStatus.completed");
           checkNetWorkUtil().then((isConnected){
             widget.onNextPage();
             if(!isConnected){
                setState(() {
                 reset();
               });
               Provider.of<SignInBloc>(context).reverAnimation.sink.add(true);
             }
           });

        }
      });
    _controller.forward();
  }

  void reset() {
    _fraction = 0.0;
  }
}