import 'dart:async';

import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/eventstate/booking_event.dart';
import 'package:app/src/eventstate/booking_event_success.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_list_store_event_success.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_service_group_event_success.dart';
import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/get_staff_list_response.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:app/src/utils/validation.dart';
import 'package:rxdart/subjects.dart';

class CreateBookingBloc extends BaseBloc {
  DataRepository _dataRepository;
  final _listStoreSubject = BehaviorSubject<List<Store>>();
  final _listServiceGroupSubject = BehaviorSubject<bool>();
  final _phoneSubject = BehaviorSubject<String>();
  final _nameSubject = BehaviorSubject<String>();

  Stream<String> phoneStream;
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get nameStream => _nameSubject.stream;
  Sink<String> get nameSink => _nameSubject.sink;

  Sink<List<Store>> get getListStoreSink => _listStoreSubject.sink;
  Stream<List<Store>> get getListStoreStream => _listStoreSubject.stream;

  Sink<bool> get getListServiceSink => _listServiceGroupSubject.sink;
  Stream<bool> get getListServiceStream => _listServiceGroupSubject.stream;

  CreateBookingBloc(String username) {
    _dataRepository = DataRepository(username);
    phoneStream = _phoneSubject.stream.transform(StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) async {
      if (phone.length > 0) {
        if (!Validation.isPhoneValid(phone)) {
          sink.add("Số điện thoại không đúng định dạng!");
          return;
        } else {
          var result = await checkCustomerPhone(phone);
          sink.add(null);
          nameSink.add(result);
          return;
        }
      } else {
        sink.add("Số điện thoại không được để trống");
      }
    }));
  }

  var phoneValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.length > 0) {
      sink.add(null);
      return;
    }
    sink.add('Số điện thoại không được để trống');
  });

  var nameValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 0) {
      sink.add(null);
      return;
    }
    sink.add('Tên không được để trống');
  });

  @override
  void dispose() {
    super.dispose();
    _listStoreSubject.close();
    _phoneSubject.close();
    _nameSubject.close();
    _listServiceGroupSubject.close();
  }

  void _getServiceGroup(GetServiceGroupEvent event) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      showLoading();
      var result = await _dataRepository.getServiceGroup(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(GetServiceGroupEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetServiceGroup));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  Future<String> checkCustomerPhone(String phone) async {
    String userName;
    try {
      var result = await _dataRepository.checkCustomerPhone(phone);
      if (result.isSuccess) {
        userName = result.bodyResponse.data.customer.customerName;
      } else {
        userName = "Họ tên khách hàng";
      }
    } catch (_) {}
    return userName;
  }

  void _getListStore(GetListStoreEvent event) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      showLoading();
      var result = await _dataRepository.getListStore(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(GetListStoreEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetListShop));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  Future<List<Staff>> searchStaff(
      String sortId, int limit, String keyword) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      var result = await _dataRepository.searchStaff(sortId, limit, keyword);
      if (result.status == 1) {
        return result.data.rows;
      } else {
        print('searchStaff error');
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void _booking(BookingEvent event) async {
    try {
      showLoading();
      var result = await _dataRepository.booking(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(BookingEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorBooking));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case GetServiceGroupEvent:
        _getServiceGroup(event);
        break;
      case BookingEvent:
        _booking(event);
        break;
      case GetListStoreEvent:
        _getListStore(event);
        break;
    }
  }
}
