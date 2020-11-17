import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_list_store_event_success.dart';
import 'package:app/src/eventstate/receipt_list_event.dart';
import 'package:app/src/eventstate/search_user_event.dart';
import 'package:app/src/models/receipt_list_response.dart';
import 'package:app/src/models/search_user_response.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:rxdart/subjects.dart';

class ReceiptBloc extends BaseBloc {
  DataRepository _dataRepository;
  final loadedSubject = BehaviorSubject<bool>();
  final loadReceiptListSubject = BehaviorSubject<List<ReceiptList>>();

  Stream<bool> get loadedStream => loadedSubject.stream;
  Sink<bool> get loadedSink => loadedSubject.sink;

  Stream<List<ReceiptList>> get loadReceiptListStream =>
      loadReceiptListSubject.stream;
  Sink<List<ReceiptList>> get loadReceiptListSink =>
      loadReceiptListSubject.sink;

  ReceiptBloc(String username) {
    _dataRepository = DataRepository(username);
  }

  Future<List<SearchUser>> searchUser(SearchUserEvent event) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      var result = await _dataRepository.searchUser(event);
      if (result.status == 1) {
        return result.data.rows;
      } else {
        print('searchUser error');
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void _getListStore(GetListStoreEvent event) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      showLoading();
      var result = await _dataRepository.getListStore(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(GetListStoreEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetListShop));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void getReceiptList(ReceiptListEvent event) async {
    try {
      showLoading();
      var result = await _dataRepository.receiptList(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(bodyResponse: result.bodyResponse, isSuccess: result.isSuccess));
        loadReceiptListSink.add(result.bodyResponse.data.rows);
      } else {
        hideLoading(NetworkServiceResponse(
            bodyResponse: result.bodyResponse, isSuccess: result.isSuccess));
        loadReceiptListSubject.addError(StringUtil.errorGetListReceipt);
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse());
      loadReceiptListSubject.addError(StringUtil.errorConnection);
    }
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case GetListStoreEvent:
        _getListStore(event);
        break;
    }
  }
}
