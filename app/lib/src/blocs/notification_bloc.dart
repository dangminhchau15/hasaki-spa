import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/eventstate/get_list_notify_event.dart';
import 'package:app/src/eventstate/get_list_notify_event_success.dart';
import 'package:app/src/eventstate/get_notify_detail_event.dart';
import 'package:app/src/eventstate/get_notify_detail_event_success.dart';
import 'package:app/src/eventstate/register_notify_event.dart';
import 'package:app/src/eventstate/register_notify_event_success.dart';
import 'package:app/src/eventstate/send_detail_notify_event.dart';
import 'package:app/src/eventstate/send_notify_event_success.dart';
import 'package:app/src/models/get_list_notify_response.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:rxdart/rxdart.dart';

import '../models/get_list_notify_response.dart';
import '../models/notify_detail_response.dart';
import '../utils/string_util.dart';

class NotificationBloc extends BaseBloc {
  DataRepository _dataRepository;
  final _loadListNotifySubject = BehaviorSubject<List<Notify>>();
  final _loadNotifyDetailSubject = BehaviorSubject<Detail>();

  Observable<List<Notify>> get loadListNotifyStream =>
      _loadListNotifySubject.stream;
  Sink<List<Notify>> get loadListNotifySink => _loadListNotifySubject.sink;

  Observable<Detail> get loadNotifyDetailStream =>
      _loadNotifyDetailSubject.stream;
  Sink<Detail> get loadNotifyDetailSink => _loadNotifyDetailSubject.sink;

  NotificationBloc(String username) {
    _dataRepository = DataRepository(username);
  }

  void getListNotify(int appId, int limit, int offset, int type) async {
    try {
      Future.delayed(Duration(milliseconds: 300));
      var results =
          await _dataRepository.getListNotify(appId, limit, offset, type);
      if (results.isSuccess) {
        loadListNotifySink.add(results.bodyResponse);
      } else {
        _loadListNotifySubject.addError(StringUtil.errorGetListNotify);
      }
    } catch (e) {
      _loadListNotifySubject.addError(StringUtil.errorConnection);
    }
  }

  void getDetailNotify(String id) async {
    try {
      Future.delayed(Duration(milliseconds: 300));
      var results = await _dataRepository.getDetailNotify(id);
      if (results.isSuccess) {
        loadNotifyDetailSink.add(results.bodyResponse.data.detail);
      } else {
        _loadListNotifySubject.addError(StringUtil.errorGetDetailNotify);
      }
    } catch (_) {
      _loadListNotifySubject.addError(StringUtil.errorConnection);
    }
  }

  void sendNotifyNotify(SendDetailNotityEvent event) async {
    try {
      showLoading();
      var results = await _dataRepository.feedbackNotify(event.id);
      if (results.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(SendNotifyEventSuccess(
            feedbackNotifyResponse: results.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorSendDetailNotify));
      }
    } catch (_) {
      print(_);
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loadListNotifySubject.close();
    _loadNotifyDetailSubject.close();
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SendDetailNotityEvent:
        sendNotifyNotify(event);
        break;
    }
  }
}
