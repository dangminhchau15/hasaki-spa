import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/dataresources/restclient.dart';
import 'package:app/src/eventstate/add_item_event.dart';
import 'package:app/src/eventstate/add_new_customer_event.dart';
import 'package:app/src/eventstate/booking_event.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_profile_event.dart';
import 'package:app/src/eventstate/get_question_event.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_staff_id_event.dart';
import 'package:app/src/eventstate/get_total_notify_event.dart';
import 'package:app/src/eventstate/post_feedback_event.dart';
import 'package:app/src/eventstate/receipt_list_event.dart';
import 'package:app/src/eventstate/register_notify_event.dart';
import 'package:app/src/eventstate/search_booking_event.dart';
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

import 'app_api_provider.dart';

class DataRepository {
  AppApiProvider hasakiAppProvider;

  DataRepository(String username) {
    hasakiAppProvider = AppApiProvider(RestClient(username));
  }

  Future<NetworkServiceResponse<SignInResponse>> signIn(SignInEvent event) =>
      hasakiAppProvider.signIn(event);

  Future<NetworkServiceResponse<ProfileResponse>> getProfile(
          GetProfileEvent event) =>
      hasakiAppProvider.getProfile(event);

  Future<NetworkServiceResponse<QuestionResponse>> getQuestion(
          GetQuestionEvent event) =>
      hasakiAppProvider.getQuestion(event);

  Future<NetworkServiceResponse<SurveyResponse>> submitSurvey(
          SurveyRequest surveyRequest) =>
      hasakiAppProvider.submitSurvey(surveyRequest);

  Future<NetworkServiceResponse<Receipt>> getReceipt(String filter) =>
      hasakiAppProvider.getReceipt(filter);

  Future<ServiceResponse> searchSKU(String serviceId, int isGroupId, int status,
      int offset, int limit, int dataOptions, String keyword) =>
      hasakiAppProvider.searchSKU(serviceId, isGroupId, status, offset, limit, dataOptions, keyword);

  Future<NetworkServiceResponse<AddNewCustomerResponse>> addNewCustomer(
          AddNewCustomerEvent event) =>
      hasakiAppProvider.addNewCustomer(event);

  Future<GetStaffListResponse> searchStaff(String sortId, int limit, String keyword) =>
      hasakiAppProvider.searchStaff(sortId, limit, keyword);

   Future<SearchUserResponse> searchUser(SearchUserEvent event) =>
      hasakiAppProvider.searchUser(event);    

  Future<NetworkServiceResponse<List<Consultant>>> getConsultants(
          String customerPhone,
          String date,
          int limit,
          int offset,
          int status) =>
      hasakiAppProvider.getConsultants(
          customerPhone, date, limit, offset, status);

  Future<NetworkServiceResponse<ConsultantDetailResponse>> getConsultant(
          int id) =>
      hasakiAppProvider.getConsultantDetail(id);

  Future<NetworkServiceResponse<GetListBookingResponse>> getBookings(
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
          String toBookingDate) =>
      hasakiAppProvider.getListBookings(
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
          fromDate,
          toDate,
          fromBookingDate,
          toBookingDate);

  Future<NetworkServiceResponse<CreateConsultantResponse>> createConsultant(
          int customerId) =>
      hasakiAppProvider.createConsultant(customerId);

  Future<NetworkServiceResponse<GetListStoreResponse>> getListStore(
          GetListStoreEvent event) =>
      hasakiAppProvider.getListStore(event);

  Future<NetworkServiceResponse<CheckCustomerPhoneResponse>> checkCustomerPhone(
          String phone) =>
      hasakiAppProvider.checkCustomerPhone(phone);

  Future<NetworkServiceResponse<GetListLocationResponse>> getListLocation() =>
      hasakiAppProvider.getListLocation();

  Future<NetworkServiceResponse<FeedbackResponse>> postFeedback(
          PostFeedbackEvent event) =>
      hasakiAppProvider.postFeedback(event);

  Future<NetworkServiceResponse<AddItemResponse>> addItem(AddItemEvent event) =>
      hasakiAppProvider.addItem(event);

  Future<NetworkServiceResponse<StaffIdResponse>> getStaffId(
          GetStaffIdEvent event) =>
      hasakiAppProvider.getStaffId(event);

  Future<NetworkServiceResponse<BookingResponse>> booking(BookingEvent event) =>
      hasakiAppProvider.booking(event);

  Future<NetworkServiceResponse<ReceiptListResponse>> receiptList(
          ReceiptListEvent event) =>
      hasakiAppProvider.receiptList(event);

  Future<NetworkServiceResponse<SearchBookingResponse>> searchBooking(
          SearchBookingEvent event) =>
      hasakiAppProvider.searchBooking(event);

  Future<NetworkServiceResponse<RegisterNotifyResponse>> registerNotify(
          RegisterNotifyEvent event) =>
      hasakiAppProvider.registerNotify(event);

  Future<NetworkServiceResponse<List<Notify>>> getListNotify(
          int appId, int limit, int offset, int type) =>
      hasakiAppProvider.getListNotify(appId, limit, offset, type);

  Future<NetworkServiceResponse<NotifyDetailResponse>> getDetailNotify(
          String id) =>
      hasakiAppProvider.getDetailNotify(id);

  Future<NetworkServiceResponse<GetTotalNotifyResponse>> getTotalNotify(
          GetTotalNotifyEvent event) =>
      hasakiAppProvider.getTotalNotify(event);

  Future<NetworkServiceResponse<FeedbackNotifyResponse>> feedbackNotify(
          String id) =>
      hasakiAppProvider.feedbackNotify(id);

  Future<NetworkServiceResponse<GetServiceGroupResponse>> getServiceGroup(
          GetServiceGroupEvent event) =>
      hasakiAppProvider.getServiceGroup(event);
}
