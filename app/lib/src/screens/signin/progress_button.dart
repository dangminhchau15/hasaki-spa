import 'package:app/src/blocs/sign_in_bloc.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/function_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

typedef OnPressedButton();

class ProgressButton extends StatefulWidget {
  final Function callback;
  bool isEnable;
  String title;
  bool isStartAnimation;
  OnPressedButton onPressedButton;
  ProgressButton(this.callback, this.isEnable,
      {this.title, @required this.isStartAnimation, this.onPressedButton});

  @override
  State<StatefulWidget> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  bool _isPressed = false, _animatingReveal = false;
  int _state = 0;
  double _width = double.infinity;
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  AnimationController _controller;
  Animation<double> buttonScaleRoundOut;
  SignInBloc _signInBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_signInBloc == null) {
      _signInBloc = Provider.of(context);
      _signInBloc.eventCallApiWithButtonSubject.stream.listen((onData) {
        print("chau $onData");
        if (onData.statusAnimation == StatusAnimation.FAILD) {
          reverAnimation();
          Fluttertoast.showToast(
              msg: onData.msg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1);
        } else if (onData.statusAnimation == StatusAnimation.SUCCESS) {
          doneAnimation();
        }
      });
//      _inputNameBloc.reverAnimation.stream.listen((onData) {
//       reset();
//        _controller.reverse();
//      });
    }
  }

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    if (_controller != null) _controller.dispose();
    // _signInBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(buttonScaleRoundOut != null ? "${buttonScaleRoundOut.value}" : "");
    return PhysicalModel(
        color: widget.isEnable
            ? ColorData.primaryColor
            : Colors.red.withOpacity(0),
        elevation: widget.isEnable ? calculateElevation() : 0,
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          key: _globalKey,
          height: 48.0,
          width: _width,
          child: _state != 2
              ? RaisedButton(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(_state == 1
                        ? buttonScaleRoundOut.value
                        : buttonScaleRoundOut != null
                            ? buttonScaleRoundOut.value
                            : 10),
                  ),
                  color: _state == 2
                      ? ColorData.primaryColor
                      : ColorData.primaryColor,
                  child: buildButtonChild(),
                  onPressed:
                      widget.isEnable ? () => {widget.onPressedButton()} : null,
                  onHighlightChanged: (isPressed) {
                    // setState(() {
                    _isPressed = isPressed;
                    if (_state == 0) {
                      animateButton();
                    }
                    // });
                  },
                )
              : Container(
                  color: ColorData.primaryColor,
                ),
        ));
  }

  void animateButton() {
    FocusScope.of(context).requestFocus(FocusNode()); //hide keyboard
    if (this.widget.isStartAnimation == null || !this.widget.isStartAnimation) {
      return;
    }
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    buttonScaleRoundOut = Tween(begin: 10.0, end: 30.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.125,
          curve: Curves.ease,
        ),
      ),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });

    _controller.forward();
    setState(() {
      _state = 1;
    });

//    Timer(Duration(milliseconds: 1000), () {
//      setState(() {
//        _state = 2;
//      });
//      _animatingReveal = true;
//      _controller.reverse();
//
//      widget.callback();
//    });
  }

  reverAnimation() {
    setState(() {
      _state = 0;
    });
    _animatingReveal = false;
    _controller.reverse();
  }

  doneAnimation() {
    setState(() {
      _state = 2;
    });
    _animatingReveal = true;
    _controller.reverse();
    widget.callback();
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        '${this.widget.title}',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == 1) {
      return Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  double calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return _isPressed ? 0.0 : 0.0;
    }
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = 0;
  }
}