class ReceiptResponse {
  String message;
  int status;
  int code;
  Data data;

  ReceiptResponse({this.message, this.status, this.code, this.data});

  ReceiptResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int total;
  Receipt receipt;

  Data({this.total, this.receipt});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    receipt = json['rows'] != null ? new Receipt.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.receipt != null) {
      data['rows'] = this.receipt.toJson();
    }
    return data;
  }
}

class Receipt {
  List<int> serviceCodes;
  Customer customer;
  int receiptCode;

  Receipt({this.serviceCodes, this.customer});

  Receipt.fromJson(Map<String, dynamic> json) {
    receiptCode = json['receipt_code'];
    serviceCodes = json['services'].cast<int>();
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['services'] = this.serviceCodes;
    data['receipt_code'] = this.receiptCode;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  int customerId;
  String customerName;
  String customerPhone;
  String customerEmail;
  String customerAddress;
  int customerDistrict;
  int customerCity;
  String customerNote;
  String customerFacebook;
  int customerType;
  int customerStatus;
  String customerAccountingCode;
  int customerWard;
  int customerOrderPoint;
  int customerReceiptPoint;
  int customerInitOrderPoint;
  int customerInitReceiptPoint;
  int customerLevel;
  String customerAvatar;
  int usedPoint;
  String createdAt;
  String updatedAt;
  int rate;
  int totalOrder;
  int totalReceipt;
  int totalAmountOrder;
  int totalAmountReceipt;
  String code;

  Customer(
      {this.customerId,
      this.customerName,
      this.customerPhone,
      this.customerEmail,
      this.customerAddress,
      this.customerDistrict,
      this.customerCity,
      this.customerNote,
      this.customerFacebook,
      this.customerType,
      this.customerStatus,
      this.customerAccountingCode,
      this.customerWard,
      this.customerOrderPoint,
      this.customerReceiptPoint,
      this.customerInitOrderPoint,
      this.customerInitReceiptPoint,
      this.customerLevel,
      this.customerAvatar,
      this.usedPoint,
      this.createdAt,
      this.updatedAt,
      this.rate,
      this.totalOrder,
      this.totalReceipt,
      this.totalAmountOrder,
      this.totalAmountReceipt,
      this.code});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];
    customerAddress = json['customer_address'];
    customerDistrict = json['customer_district'];
    customerCity = json['customer_city'];
    customerNote = json['customer_note'];
    customerFacebook = json['customer_facebook'];
    customerType = json['customer_type'];
    customerStatus = json['customer_status'];
    customerAccountingCode = json['customer_accounting_code'];
    customerWard = json['customer_ward'];
    customerOrderPoint = json['customer_order_point'];
    customerReceiptPoint = json['customer_receipt_point'];
    customerInitOrderPoint = json['customer_init_order_point'];
    customerInitReceiptPoint = json['customer_init_receipt_point'];
    customerLevel = json['customer_level'];
    customerAvatar = json['customer_avatar'];
    usedPoint = json['used_point'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rate = json['rate'];
    totalOrder = json['total_order'];
    totalReceipt = json['total_receipt'];
    totalAmountOrder = json['total_amount_order'];
    totalAmountReceipt = json['total_amount_receipt'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['customer_address'] = this.customerAddress;
    data['customer_district'] = this.customerDistrict;
    data['customer_city'] = this.customerCity;
    data['customer_note'] = this.customerNote;
    data['customer_facebook'] = this.customerFacebook;
    data['customer_type'] = this.customerType;
    data['customer_status'] = this.customerStatus;
    data['customer_accounting_code'] = this.customerAccountingCode;
    data['customer_ward'] = this.customerWard;
    data['customer_order_point'] = this.customerOrderPoint;
    data['customer_receipt_point'] = this.customerReceiptPoint;
    data['customer_init_order_point'] = this.customerInitOrderPoint;
    data['customer_init_receipt_point'] = this.customerInitReceiptPoint;
    data['customer_level'] = this.customerLevel;
    data['customer_avatar'] = this.customerAvatar;
    data['used_point'] = this.usedPoint;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['rate'] = this.rate;
    data['total_order'] = this.totalOrder;
    data['total_receipt'] = this.totalReceipt;
    data['total_amount_order'] = this.totalAmountOrder;
    data['total_amount_receipt'] = this.totalAmountReceipt;
    data['code'] = this.code;
    return data;
  }
}