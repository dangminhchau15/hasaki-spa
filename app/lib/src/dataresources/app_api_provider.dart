import 'package:app/src/dataresources/remote/apisubdomain.dart';
import 'package:app/src/dataresources/remote/network_service.dart';
import 'package:app/src/dataresources/restclient.dart';
import 'package:app/src/eventstate/add_item_event.dart';
import 'package:app/src/eventstate/add_new_customer_event.dart';
import 'package:app/src/eventstate/booking_event.dart';
import 'package:app/src/eventstate/check_customer_phone_event.dart';
import 'package:app/src/eventstate/get_consultant_event.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_profile_event.dart';
import 'package:app/src/eventstate/get_question_event.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_staff_id_event.dart';
import 'package:app/src/eventstate/get_staff_list_event.dart';
import 'package:app/src/eventstate/get_total_notify_event.dart';
import 'package:app/src/eventstate/post_feedback_event.dart';
import 'package:app/src/eventstate/receipt_list_event.dart';
import 'package:app/src/eventstate/register_notify_event.dart';
import 'package:app/src/eventstate/search_booking_event.dart';
import 'package:app/src/eventstate/search_sku_event.dart';
import 'package:app/src/eventstate/search_user_event.dart';
import 'package:app/src/eventstate/sign_in_event.dart';
import 'package:app/src/models/add_item_receipt_response.dart';
import 'package:app/src/models/add_new_customer_response.dart';
import 'package:app/src/models/booking_response.dart';
import 'package:app/src/models/check_customer_phone_response.dart';
import 'package:app/src/models/consultant_detail_response.dart';
import 'package:app/src/models/consultant_response.dart';
import 'package:app/src/models/create_consultant_response.dart';
import 'package:app/src/models/feedback_notify_response.dart';
import 'package:app/src/models/feedback_response.dart';
import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/get_list_booking_response.dart';
import 'package:app/src/models/get_list_location_response.dart';
import 'package:app/src/models/get_list_notify_response.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/models/get_staff_list_response.dart';
import 'package:app/src/models/get_total_notify_response.dart';
import 'package:app/src/models/notify_detail_response.dart';
import 'package:app/src/models/profile_response.dart';
import 'package:app/src/models/question_response.dart';
import 'package:app/src/models/receipt_list_response.dart';
import 'package:app/src/models/receipt_response.dart';
import 'package:app/src/models/register_notify_response.dart';
import 'package:app/src/models/search_booking_response.dart';
import 'package:app/src/models/search_user_response.dart';
import 'package:app/src/models/service_response.dart';
import 'package:app/src/models/sign_in_response.dart';
import 'package:app/src/models/staff_id_response.dart';
import 'package:app/src/models/survey_request.dart';
import 'package:app/src/models/survey_response.dart';

import 'network_service_response.dart';

class AppApiProvider extends NetworkService {
  AppApiProvider(RestClient rest) : super(rest);

  Future<NetworkServiceResponse<SignInResponse>> signIn(
      SignInEvent event) async {
    Map<String, String> query = {
      "email": event.email.toString(),
      "password": event.password.toString(),
    };
    var result = await rest.postAsync(API.signIn, query);
    try {
      if (result.mappedResult != null) {
        var responseData = SignInResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<ProfileResponse>> getProfile(
      GetProfileEvent event) async {
    Map<String, String> query = {"data_stores": event.dataStore.toString()};
    var result = await rest.getAsyncToken(API.getProfile, query);
    try {
      if (result.mappedResult != null) {
        var responseData = ProfileResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<RegisterNotifyResponse>> registerNotify(
      RegisterNotifyEvent event) async {
    Map<String, String> query = {
      "token": event.token.toString(),
      "device_type": event.deviceType.toString(),
      "app_id": event.appId.toString()
    };
    var result = await rest.postAsyncWithToken(API.registerNotify, query);
    try {
      if (result.mappedResult != null) {
        var responseData = RegisterNotifyResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<List<Notify>>> getListNotify(
      int appId, int limit, int offset, int type) async {
    Map<String, String> query = {
      "app_id": appId.toString(),
      "limit": limit.toString(),
      "offset": offset.toString(),
      "type": type.toString()
    };
    var result = await rest.getAsyncToken(API.getListNotify, query);
    try {
      if (result.mappedResult != null) {
        var responseData = GetListNotifyResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData.data.notifies,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<NotifyDetailResponse>> getDetailNotify(
      String id) async {
    var result = await rest.getAsyncToken(API.getDetailNotify + "$id");
    try {
      if (result.mappedResult != null) {
        var responseData = NotifyDetailResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<FeedbackNotifyResponse>> feedbackNotify(
      String id) async {
    var result =
        await rest.postAsyncWithToken(API.sendFeedbackNotify + "$id", "");
    try {
      if (result.mappedResult != null) {
        var responseData = FeedbackNotifyResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<CheckCustomerPhoneResponse>> checkCustomerPhone(
      String phone) async {
    Map<String, String> query = {"phone": phone.toString()};
    var result = await rest.getAsyncToken(API.checkCustomerPhone, query);
    try {
      if (result.mappedResult != null) {
        var responseData =
            CheckCustomerPhoneResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<List<Consultant>>> getConsultants(
      String customerPhone,
      String date,
      int limit,
      int offset,
      int status) async {
    Map<String, String> query = {
      "customer_phone": customerPhone,
      "from_date": date,
      "to_date": date,
      "limit": limit.toString(),
      "offset": offset.toString(),
      "status": status.toString()
    };
    var result = await rest.getAsyncToken(API.getConsultants, query);
    try {
      if (result.mappedResult != null) {
        var responseData = ConsultantResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData.data.consultants,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<GetListBookingResponse>> getListBookings(
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
    Map<String, String> query = {
      "data_services": dataServices.toString(),
      "limit": limit.toString(),
      "offset": offset.toString(),
      "store_id": storeId.toString(),
      "date_type": dataType.toString(),
      "import_id": importId.toString(),
      "status": status.toString(),
      "phone": phone.toString(),
      "service_group_sku": serviceGroupSku.toString(),
      "overdue": overdue.toString(),
      "from_date": fromDate.toString(),
      "to_date": toDate.toString(),
      "from_bookingdate": fromBookingDate.toString(),
      "to_bookingdate": toBookingDate.toString(),
    };
    var result = await rest.getAsyncToken(API.getBookings, query);
    try {
      if (result.mappedResult != null) {
        var responseData = GetListBookingResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<GetListLocationResponse>>
      getListLocation() async {
    var result = await rest.getAsyncToken(API.getListLocation);
    try {
      if (result.mappedResult != null) {
        var responseData =
            GetListLocationResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<ConsultantDetailResponse>> getConsultantDetail(
      int id) async {
    var result = await rest.getAsyncToken(API.getConsultantDetail + "$id");
    try {
      if (result.mappedResult != null) {
        var responseData =
            ConsultantDetailResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<GetServiceGroupResponse>> getServiceGroup(
      GetServiceGroupEvent event) async {
    Map<String, String> query = {
      "sort": event.sort.toString(),
      "service_group_parent": event.serviceGroupParent.toString(),
      "service_group_status": event.serviceGroupStatus.toString()
    };
    var result = await rest.getAsyncToken(API.getServiceGroup, query);
    try {
      if (result.mappedResult != null) {
        var responseData =
            GetServiceGroupResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<GetStaffListResponse> searchStaff(
      String sort, int limit, String keyword) async {
    Map<String, String> query = {
      "sort": sort.toString(),
      "limit": limit.toString(),
      "q": keyword.toString()
    };
    var result = await rest.getAsyncToken(API.searchStaff, query);
    try {
      if (result.mappedResult != null) {
        var responseData = GetStaffListResponse.fromJson(result.mappedResult);
        return GetStaffListResponse(
            data: responseData.data,
            code: responseData.code,
            status: responseData.status,
            message: responseData.message);
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return GetStaffListResponse(
        message: result.networkServiceResponse.message,
        status: result.networkServiceResponse.statusCode);
  }

  Future<NetworkServiceResponse<GetListStoreResponse>> getListStore(
      GetListStoreEvent event) async {
    var result = await rest.getAsyncToken(API.getListStore);
    try {
      if (result.mappedResult != null) {
        var responseData = GetListStoreResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<CreateConsultantResponse>> createConsultant(
      int customerId) async {
    Map<String, String> query = {"customer_id": customerId.toString()};
    var result = await rest.postAsyncWithToken(API.createConsultant, query);
    try {
      if (result.mappedResult != null) {
        var responseData =
            CreateConsultantResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<AddNewCustomerResponse>> addNewCustomer(
      AddNewCustomerEvent event) async {
    Map<String, String> query = {
      "customer_phone": event.phone.toString(),
      "customer_name": event.name.toString()
    };
    var result = await rest.postAsyncWithToken(API.addNewCustomer, query);
    try {
      if (result.mappedResult != null) {
        var responseData = AddNewCustomerResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<BookingResponse>> booking(
      BookingEvent event) async {
    Map<String, String> query = {
      "store_id": event.storeId.toString(),
      "booking_date": event.bookingDate.toString(),
      "booking_desc": event.decs.toString(),
      "booking_name": event.name.toString(),
      "booking_phone": event.phone.toString(),
      "booking_status": event.status.toString(),
      "service_group_sku": event.serviceGroupSku.toString(),
      "staff_id": event.staffId.toString(),
    };
    print(query);
    var result = await rest.postAsyncWithToken(API.booking, query);
    try {
      if (result.mappedResult != null) {
        var responseData = BookingResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<StaffIdResponse>> getStaffId(
      GetStaffIdEvent event) async {
    Map<String, String> query = {
      "receipt_code": event.receiptCode.toString(),
      "extra_id": event.extraId.toString()
    };
    var result = await rest.getAsyncToken(API.getStaffId, query);
    try {
      if (result.mappedResult != null) {
        var responseData = StaffIdResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<GetTotalNotifyResponse>> getTotalNotify(
      GetTotalNotifyEvent event) async {
    Map<String, String> query = {
      "app_id": event.appId.toString(),
    };
    var result = await rest.getAsyncToken(API.getTotalNotify, query);
    try {
      if (result.mappedResult != null) {
        var responseData = GetTotalNotifyResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<ReceiptListResponse>> receiptList(
      ReceiptListEvent event) async {
    Map<String, String> query = {
      "data_customers": event.dataCustomer.toString(),
      "total": event.total.toString(),
      "limit": event.limit.toString(),
      "offset": event.offset.toString(),
      "customer_phone": event.customerPhone.toString(),
      "receipt_balance": event.receiptBalance.toString(),
      "receipt_code": event.receiptCode.toString(),
      "receipt_type": event.receiptType.toString(),
      "status": event.status.toString(),
      "user_id": event.userId.toString(),
      "from_date": event.fromDate.toString(),
      "to_date": event.toDate.toString()
    };
    var result = await rest.getAsyncToken(API.receiptList, query);
    try {
      if (result.mappedResult != null) {
        var responseData = ReceiptListResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<QuestionResponse>> getQuestion(
      GetQuestionEvent event) async {
    Map<String, String> query = {"receipt_code": event.receiptCode.toString()};
    var result = await rest.getAsyncToken(API.getQuestionFeedback, query);
    try {
      if (result.mappedResult != null) {
        var responseData = QuestionResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<SearchBookingResponse>> searchBooking(
      SearchBookingEvent event) async {
    Map<String, String> query = {
      "store_id": event.storeId.toString(),
      "staff_id": event.staffId.toString(),
      "status": event.status.toString(),
      "import_id": event.importId.toString(),
    };
    var result = await rest.getAsyncToken(API.booking, query);
    try {
      if (result.mappedResult != null) {
        var responseData = SearchBookingResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<ServiceResponse> searchSKU(String serviceId, int isGroupId, int status,
      int offset, int limit, int dataOptions, String keyword) async {
    Map<String, String> query = {
      "sort": serviceId.toString(),
      "is_group_id": isGroupId.toString(),
      "status": status.toString(),
      "offset": offset.toString(),
      "limit": limit.toString(),
      "data_options": dataOptions.toString(),
      "q": keyword
    };
    var result = await rest.getAsyncToken(API.searchSKU, query);
    try {
      if (result.mappedResult != null) {
        var responseData = ServiceResponse.fromJson(result.mappedResult);
        return ServiceResponse(
            data: responseData.data,
            status: responseData.status,
            code: responseData.code,
            message: responseData.message);
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return ServiceResponse(
        message: result.networkServiceResponse.message,
        status: result.networkServiceResponse.statusCode);
  }

  Future<NetworkServiceResponse<Receipt>> getReceipt(String filter) async {
    Map<String, String> query = {"receipt_code": filter.toString()};
    var result = await rest.getAsyncToken(API.getReceipt, query);
    try {
      if (result.mappedResult != null) {
        var responseData = ReceiptResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData.data.receipt,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<SurveyResponse>> submitSurvey(
      SurveyRequest surveyRequest) async {
    var result =
        await rest.postAsyncWithToken(API.submitFeedback, surveyRequest);
    try {
      if (result.mappedResult != null) {
        var responseData = SurveyResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<NetworkServiceResponse<AddItemResponse>> addItem(
      AddItemEvent event) async {
    Map<String, String> query = {
      "consultant_id": event.consultantId.toString(),
      "sku": event.sku.toString(),
      "qty": event.quantity.toString(),
      "note": event.note.toString()
    };
    var result = await rest.postAsyncWithToken(API.addItem, query);
    try {
      if (result.mappedResult != null) {
        var responseData = AddItemResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }

  Future<SearchUserResponse> searchUser(SearchUserEvent event) async {
    Map<String, String> query = {
      "sort": event.sortId.toString(),
      "offset": event.offset.toString(),
      "limit": event.limit.toString(),
      "q": event.keyword.toString()
    };
    var result = await rest.getAsyncToken(API.searchUser, query);
    try {
      if (result.mappedResult != null) {
        var responseData = SearchUserResponse.fromJson(result.mappedResult);
        return SearchUserResponse(
            data: responseData.data,
            code: responseData.code,
            message: responseData.message,
            status: responseData.status);
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return SearchUserResponse(
        message: result.networkServiceResponse.message,
        status: result.networkServiceResponse.statusCode);
  }

  Future<NetworkServiceResponse<FeedbackResponse>> postFeedback(
      PostFeedbackEvent event) async {
    Map<String, String> query = {
      "customer_id": event.customerId.toString(),
      "customer_phone": event.customerPhone.toString(),
      "receipt_code": event.receiptCode.toString(),
      "method_feedback": event.methodFeedback.toString()
    };
    var result = await rest.postAsyncWithToken(API.customerFeedback, query);
    try {
      if (result.mappedResult != null) {
        var responseData = FeedbackResponse.fromJson(result.mappedResult);
        return NetworkServiceResponse(
          bodyResponse: responseData,
          isSuccess: result.networkServiceResponse.isSuccess,
        );
      }
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    return NetworkServiceResponse(
        isSuccess: result.networkServiceResponse.isSuccess,
        message: result.networkServiceResponse.message);
  }
}
