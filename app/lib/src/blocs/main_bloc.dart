import 'dart:convert';
import 'dart:io';
import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/dataresources/remote/apisubdomain.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/dataresources/restclient.dart';
import 'package:app/src/eventstate/get_list_notify_event.dart';
import 'package:app/src/eventstate/get_list_notify_event_success.dart';
import 'package:app/src/eventstate/get_profile_event.dart';
import 'package:app/src/eventstate/get_profile_event_success.dart';
import 'package:app/src/eventstate/get_total_notify_event.dart';
import 'package:app/src/eventstate/get_total_notify_event_success.dart';
import 'package:app/src/eventstate/register_notify_event.dart';
import 'package:app/src/eventstate/register_notify_event_success.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../dataresources/remote/preference_provider.dart';
import '../dataresources/remote/preference_provider.dart';

class MainBloc extends BaseBloc {
  DataRepository _dataRepository;
  final _logOutSubject = BehaviorSubject<String>();
  final _loadedSubject = BehaviorSubject<bool>();
  final _loadedNameSubject = BehaviorSubject<bool>();
  final _loadTotalSubject = BehaviorSubject<bool>();

  Observable<String> get logOutStream => _logOutSubject.stream;
  Sink<String> get logOutSink => _logOutSubject.sink;

  Observable<bool> get loadedStream => _loadedSubject.stream;
  Sink<bool> get loadedSink => _loadedSubject.sink;

  Observable<bool> get loadedNameStream => _loadedNameSubject.stream;
  Sink<bool> get loadedNameSink => _loadedNameSubject.sink;

  Observable<bool> get loadTotalStream => _loadTotalSubject.stream;
  Sink<bool> get loadTotalSink => _loadTotalSubject.sink;

  MainBloc(String username) {
    _dataRepository = DataRepository(username);
  }

  void registerNotify(RegisterNotifyEvent event) async {
    try {
      //showLoading();
      var results = await _dataRepository.registerNotify(event);
      if (results.isSuccess) {
        // hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(RegisterNotifyEventSuccess(
            registerNotifyResponse: results.bodyResponse));
      } else {
        // hideLoading(NetworkServiceResponse(
        //     isSuccess: false, message: StringUtil.errorRegisterNotify));
      }
    } catch (_) {
      print(_);
      // hideLoading(NetworkServiceResponse(
      //     isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void getProfile(GetProfileEvent event) async {
    try {
      showLoading();
      var results = await _dataRepository.getProfile(event);
      if (results.isSuccess) {
        await PreferenceProvider.load();
        PreferenceProvider.setString(SharePrefNames.STAFF_NAME, results.bodyResponse.data.profile.name);
        PreferenceProvider.setInt(SharePrefNames.LOCATION_ID, results.bodyResponse.data.staffInfo.staffLocId);
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(GetProfileEventSuccess(profileResponse: results.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetProfile));
      }
    } catch (_, stacktrace) {
      print(_);
      print(stacktrace);
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void getTotalNotify(GetTotalNotifyEvent event) async {
    try {
      showLoading();
      var results = await _dataRepository.getTotalNotify(event);
      if (results.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(GetTotalNotifyEventSuccess(
            getTotalNotifyResponse: results.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetListNotify));
      }
    } catch (_) {
      print(_);
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void logout() async {
    await PreferenceProvider.load();
    await PreferenceProvider.logOut();
    logOutSink.add("Đăng Xuất Thành Công");
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case GetProfileEvent:
        getProfile(event);
        break;
      case RegisterNotifyEvent:
        registerNotify(event);
        break;  
      case GetTotalNotifyEvent:
        getTotalNotify(event);
        break;
      default:
        break;
    }
  }
}
