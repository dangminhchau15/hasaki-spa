
import 'dart:async';

import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/utils/fetch_process.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  FetchProcess process;

  BehaviorSubject<FetchProcess> _loadingStreamController = BehaviorSubject<FetchProcess>();
  Observable<FetchProcess> get loadingStream => _loadingStreamController.stream;

  StreamController<BaseEvent> _eventStreamController = StreamController<BaseEvent>();
  Sink<BaseEvent> get event => _eventStreamController.sink;

  StreamController<BaseEvent> _processEventSubject = BehaviorSubject<BaseEvent>();
  Stream<BaseEvent> get processEventStream => _processEventSubject.stream;
  Sink<BaseEvent> get processEventSink => _processEventSubject.sink;

  BaseBloc() {
    process = new FetchProcess();
    _eventStreamController.stream.listen((event) {
      print('--$event');
      if (event is! BaseEvent) {
        throw Exception("Invalid event");
      }
      dispatchEvent(event);
    });
  }

  void showLoading() {
    process.loading = true;
    _loadingStreamController.add(process);
  }

  void hideLoading(NetworkServiceResponse<dynamic> result) {
    process.loading = false;
    process.response = result;
    _loadingStreamController.add(process);
  }

  void dispatchEvent(BaseEvent event);

  void dispose() {
    _eventStreamController.close();
    _loadingStreamController.close();
    _processEventSubject.close();
  }
}