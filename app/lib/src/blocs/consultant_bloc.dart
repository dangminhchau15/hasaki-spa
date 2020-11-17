import 'dart:async';
import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/eventstate/add_item_event.dart';
import 'package:app/src/eventstate/add_item_event_success.dart';
import 'package:app/src/eventstate/add_new_customer_event.dart';
import 'package:app/src/eventstate/add_new_customer_success.dart';
import 'package:app/src/eventstate/check_customer_phone_event.dart';
import 'package:app/src/eventstate/check_customer_phone_success.dart';
import 'package:app/src/eventstate/get_consultant_detail_event.dart';
import 'package:app/src/eventstate/get_consultant_event_detail_success.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_service_group_event_success.dart';
import 'package:app/src/models/consultant_response.dart';
import 'package:app/src/models/create_consultant_response.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/models/service_response.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:app/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ConsultantBloc extends BaseBloc {
  DataRepository _dataRepository;
  final _quantitySubject = BehaviorSubject<String>();
  final _nameSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _loadListSubject = BehaviorSubject<bool>();
  final _loadServiceSubject = BehaviorSubject<bool>();
  final _addCustomerSubject = BehaviorSubject<bool>();
  final _loadListNotifySubject = BehaviorSubject<List<Consultant>>();
  final _createConsultantSubject = BehaviorSubject<CreateConsultantResponse>();
  final _checkCustomerPhoneSubject = BehaviorSubject<bool>();
  final _serviceGroupSubject = BehaviorSubject<GetServiceGroupResponse>();

  @override
  void dispose() {
    super.dispose();
    _quantitySubject.close();
    _nameSubject.close();
    _serviceGroupSubject.close();
    _btnSubject.close();
    _loadListSubject.close();
    _loadServiceSubject.close();
    _addCustomerSubject.close();
    _loadListNotifySubject.close();
    _checkCustomerPhoneSubject.close();
  }

  Stream<String> get quantityStream => _quantitySubject.stream;
  Sink<String> get quantitySink => _quantitySubject.sink;

  Observable<List<Consultant>> get loadListConsultantStream =>
      _loadListNotifySubject.stream;
  Sink<List<Consultant>> get loadListConsultantSink =>
      _loadListNotifySubject.sink;

  Stream<bool> get loadListStream => _loadListSubject.stream;
  Sink<bool> get loadListSink => _loadListSubject.sink;

  Stream<CreateConsultantResponse> get createConsultantStream =>
      _createConsultantSubject.stream;
  Sink<CreateConsultantResponse> get createConsultantSink =>
      _createConsultantSubject.sink;

  Stream<GetServiceGroupResponse> get getServiceGroupStream =>
      _serviceGroupSubject.stream;
  Sink<GetServiceGroupResponse> get getServiceGroupSink =>
      _serviceGroupSubject.sink;

  Stream<bool> get loadServiceStream => _loadServiceSubject.stream;
  Sink<bool> get loadServiceSink => _loadServiceSubject.sink;

  Stream<bool> get addCustomerStream => _addCustomerSubject.stream;
  Sink<bool> get addCustomerSink => _addCustomerSubject.sink;


  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  Stream<bool> get checkCustomerStream => _checkCustomerPhoneSubject.stream;
  Sink<bool> get checkCustomerSink => _checkCustomerPhoneSubject.sink;

  ConsultantBloc(String username) {
    _dataRepository = DataRepository(username);
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case CheckCustomerPhoneEvent:
        _checkCustomerPhone(event);
        break;
      case AddNewCustomerEvent:
        _addNewCustomer(event);
        break;
      case GetConsultantDetailEvent:
        _getConsultantDetail(event);
        break;
      case GetServiceGroupEvent:
        _getServiceGroup(event);
        break;
      case AddItemEvent:
        _addItem(event);
        break;
    }
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

  void _checkCustomerPhone(CheckCustomerPhoneEvent event) async {
    try {
      showLoading();
      var result = await _dataRepository.checkCustomerPhone(event.phone);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(CheckCustomerPhoneEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorCheckPhone));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void createConsultant(int customerId) async {
    try {
      Future.delayed(Duration(milliseconds: 500));
      var result = await _dataRepository.createConsultant(customerId);
      if (result.isSuccess) {
        _createConsultantSubject.add(result.bodyResponse);
      } else {
        _createConsultantSubject.addError(StringUtil.errorCreateConsulant);
      }
    } catch (_) {
      _createConsultantSubject.addError(StringUtil.errorConnection);
    }
  }

  void _getConsultantDetail(GetConsultantDetailEvent event) async {
    try {
      showLoading();
      var result = await _dataRepository.getConsultant(event.id);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(
            GetConsultantEventDetailSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetConsultants));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void getConsultants(String customerPhone, String date, int limit, int offset,
      int status) async {
    try {
      showLoading();
      var result = await _dataRepository.getConsultants(
          customerPhone, date, limit, offset, status);
      if (result.isSuccess) {
        loadListConsultantSink.add(result.bodyResponse);
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetConsultants));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  Future<List<ServiceSearch>> searchSKU(
      String serviceId,
      int isGroupId,
      int status,
      int offset,
      int limit,
      int dataOptions,
      String keyword) async {
    try {
      var result = await _dataRepository.searchSKU(
          serviceId, isGroupId, status, offset, limit, dataOptions, keyword);
      if (result.status == 1) {
        return result.data.services;
      } else {}
    } catch (_) {}
  }

  void _addNewCustomer(AddNewCustomerEvent event) async {
    try {
      showLoading();
      var result = await _dataRepository.addNewCustomer(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(AddNewCustomerSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorAddNewCustomer));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void _addItem(AddItemEvent event) async {
    try {
      showLoading();
      var result = await _dataRepository.addItem(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(AddItemEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorAddItem));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }
}
