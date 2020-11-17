class API {
  static String test = 'test-ws.inshasaki.com';

  static String prod = 'ws.inshasaki.com';

  static String signIn = "/api/auth/login";

  static String getProfile = "/api/setting/user/profile";

  static String checkCustomerPhone = "/api/sales/customer/detail";

  static String addNewCustomer = "/api/sales/customer";

  static String getConsultants = "/api/spa/consultant";

  static String getConsultantDetail = "/api/spa/consultant/";

  static String createConsultant = "/api/spa/consultant/";

  static String addItem = "/api/spa/consultant/add-item";

  static String searchUser = "api/setting/user";

  static String getQuestionFeedback = '/api/spa/question-feedback';

  static String submitFeedback = '/api/spa/result-feedback';

  static String getReceipt = '/api/spa/receipt-detail';

  static String searchSKU = '/api/spa/service/search';

  static String customerFeedback = '/api/spa/customer-feedback';

  static String getStaffId = '/api/spa/question-feedback/getStaffId';

  static String booking = '/api/spa/booking';

  static String getBookings = '/api/spa/booking';

  static String receiptList = '/api/report/receipt';

  static String registerNotify = '/api/setting/user/fcm';

  static String getListNotify = '/api/setting/user/notification';

  static String getDetailNotify = '/api/setting/user/notification/';

  static String getTotalNotify = '/api/setting/user/notification/total';

  static String sendFeedbackNotify = '/api/setting/user/notification/feedback/';

  static String getListLocation = '/api/setting/location/search';

  static String getServiceGroup = '/api/spa/servicegroup';

  static String searchStaff = '/api/hr/staff';

  static String getListStore = '/api/setting/store/search';
}
