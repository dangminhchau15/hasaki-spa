import 'dart:async';
import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/sign_in_event.dart';
import 'package:app/src/eventstate/sign_in_event_success.dart';
import 'package:app/src/utils/function_util.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:app/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc {
  DataRepository _dataRepository;
  final _passSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final reverAnimation = PublishSubject<bool>();
  final eventCallApiWithButtonSubject = BehaviorSubject<ModelInputSignIn>();

  SignInBloc() {
    validateField();
  }

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  validateField() {
    Observable.combineLatest2(_emailSubject, _passSubject,
        (String email, String password) {
      return email.length > 0 && password.length > 0;
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (pass.length > 0) {
      sink.add(null);
      return;
    }
    sink.add('Mật khẩu không được để trống');
  });

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length > 0) {
      if (Validation.isEmailValid(email)) {
        sink.add(null);
        return;
      } else {
        sink.add('Email không đúng định dạng!');
        return;
      }
    } else {
      sink.add('Email không được để trống');
      return;
    }
  });

  void signIn(SignInEvent event) async {
    try {
      showLoading();
      _dataRepository = DataRepository(event.email);
      await PreferenceProvider.load();
      PreferenceProvider.setString(SharePrefNames.USER_NAME, event.email);
      var results = await _dataRepository.signIn(event);
      if (results.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        await PreferenceProvider.load();
        PreferenceProvider.setString(
            SharePrefNames.TOKEN, results.bodyResponse.data.token);
        processEventSink
            .add(SignInEventSucess(signInResponse: results.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorLogin));
      }
    } catch (_, stacktrace) {
      print(_);
      print(stacktrace);
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passSubject.close();
    _emailSubject.close();
    _btnSubject.close();
    reverAnimation.close();
    eventCallApiWithButtonSubject.close();
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        signIn(event);
        break;
      default:
        break;
    }
  }
}

class ModelInputSignIn {
  StatusAnimation statusAnimation;
  String msg;

  ModelInputSignIn({this.statusAnimation, this.msg});
}
