import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_list_location_response.dart';
import 'package:rxdart/subjects.dart';

import '../dataresources/data_repository.dart';
import '../dataresources/data_repository.dart';
import '../utils/string_util.dart';

class ProfileBloc extends BaseBloc {
  DataRepository _dataRepository;
  final oldPassSubject = BehaviorSubject<String>();
  final newPassSubject = BehaviorSubject<String>();
  final confirmPassSubject = BehaviorSubject<String>();
  final loadListLocationSubject = BehaviorSubject<GetListLocationResponse>();

  ProfileBloc(String username) {
    _dataRepository = DataRepository(username);
  }

  Sink<String> get oldPassSink => oldPassSubject.sink;
  Stream<String> get oldPassStream => oldPassSubject.stream;

  Sink<String> get newPassSink => newPassSubject.sink;
  Stream<String> get newPassStream => newPassSubject.stream;

  Sink<String> get confirmPassSink => confirmPassSubject.sink;
  Stream<String> get confirmPassStream => confirmPassSubject.stream;

  Sink<GetListLocationResponse> get getListLocationSink =>
      loadListLocationSubject.sink;
  Stream<GetListLocationResponse> get getListLocationStream =>
      loadListLocationSubject.stream;

  void getListLocation() async {
    try {
      var results = await _dataRepository.getListLocation();
      if (results.isSuccess) {
        getListLocationSink.add(results.bodyResponse);
      } else {
        loadListLocationSubject.addError(StringUtil.errorGetListLocation);
      }
    } catch (_) {
      loadListLocationSubject.addError(StringUtil.errorConnection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    oldPassSubject.close();
    newPassSubject.close();
    confirmPassSubject.close();
    loadListLocationSubject.close();
  }

  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
  }
}
