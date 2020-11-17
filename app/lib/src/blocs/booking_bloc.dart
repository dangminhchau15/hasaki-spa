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
import 'package:app/src/eventstate/search_booking_event.dart';
import 'package:app/src/eventstate/search_booking_event_success.dart';
import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/get_list_booking_response.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:rxdart/subjects.dart';

class BookingBloc extends BaseBloc {
  DataRepository dataRepository;
  final loadedListSubject = BehaviorSubject<bool>();
  final loadServiceGroupSubject = BehaviorSubject<GetServiceGroupResponse>();
  final storeListSubject = BehaviorSubject<List<Store>>();
  final serviceGroupSubject = BehaviorSubject<List<Service>>();
  final getListBookingsSubject = BehaviorSubject<GetListBookingResponse>();

  Sink<GetListBookingResponse> get getListBookingSink =>
      getListBookingsSubject.sink;
  Stream<GetListBookingResponse> get getListBookingStream =>
      getListBookingsSubject.stream;

  Sink<bool> get loadedListSink => loadedListSubject.sink;
  Stream<bool> get loadedListStream => loadedListSubject.stream;

  Sink<List<Store>> get getListNameStoreSink => storeListSubject.sink;
  Stream<List<Store>> get getListNameStoreStream => storeListSubject.stream;

  Sink<List<Service>> get getListNameServiceGroupSink =>
      serviceGroupSubject.sink;
  Stream<List<Service>> get getListNameServiceGroupStream =>
      serviceGroupSubject.stream;

  BookingBloc(String username) {
    dataRepository = DataRepository(username);
  }

  @override
  void dispose() {
    loadedListSubject.close();
    loadServiceGroupSubject.close();
    storeListSubject.close();
    serviceGroupSubject.close();
    getListBookingsSubject.close();
    super.dispose();
  }

  void _booking(BookingEvent event) async {
    try {
      showLoading();
      var result = await dataRepository.booking(event);
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

  void _getServiceGroup(GetServiceGroupEvent event) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      showLoading();
      var result = await dataRepository.getServiceGroup(event);
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

  void getBookings(
      String dataServices,
      int limit,
      int offset,
      int storeId,
      int dataType,
      int importId,
      int status,
      String phone,
      int serviceGroupSku,
      int overdue,
      String fromDate,
      String toDate,
      String fromBookingDate,
      String toBookingDate) async {
    try {
      Future.delayed(Duration(microseconds: 500));
      showLoading();
      var result = await dataRepository.getBookings(
          dataServices,
          limit,
          offset,
          storeId,
          dataType,
          importId,
          status,
          phone,
          serviceGroupSku,
          overdue,
          dataType == 1 ? "" : fromDate,
          dataType == 1 ? "" : toDate,
          dataType == 1 ? fromBookingDate : "",
          dataType == 1 ? toBookingDate : "");
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        getListBookingSink.add(result.bodyResponse);
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorGetBookings));
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
      var result = await dataRepository.getListStore(event);
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

  void _searchBooking(SearchBookingEvent event) async {
    try {
      showLoading();
      var result = await dataRepository.searchBooking(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink
            .add(SearchBookingEventSuccess(response: result.bodyResponse));
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false, message: StringUtil.errorSearchBooking));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case BookingEvent:
        _booking(event);
        break;
      case GetListStoreEvent:
        _getListStore(event);
        break;
      case GetServiceGroupEvent:
        _getServiceGroup(event);
        break;
      case SearchBookingEvent:
        _searchBooking(event);
        break;
    }
  }
}
