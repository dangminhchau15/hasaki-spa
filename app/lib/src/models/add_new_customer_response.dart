class AddNewCustomerResponse {
  String message;
  int status;
  int code;
  Data data;

  AddNewCustomerResponse({this.message, this.status, this.code, this.data});

  AddNewCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  Customer customer;

  Data({this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  String customerName;
  String customerPhone;
  String customerEmail;
  String customerAddress;
  int customerDistrict;
  int customerCity;
  int customerType;
  int customerWard;
  String customerNote;
  String customerFacebook;
  String customerAccountingCode;
  int customerStatus;
  String code;
  String updatedAt;
  String createdAt;
  int customerId;

  Customer(
      {this.customerName,
      this.customerPhone,
      this.customerEmail,
      this.customerAddress,
      this.customerDistrict,
      this.customerCity,
      this.customerType,
      this.customerWard,
      this.customerNote,
      this.customerFacebook,
      this.customerAccountingCode,
      this.customerStatus,
      this.code,
      this.updatedAt,
      this.createdAt,
      this.customerId});

  Customer.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];
    customerAddress = json['customer_address'];
    customerDistrict = json['customer_district'];
    customerCity = json['customer_city'];
    customerType = json['customer_type'];
    customerWard = json['customer_ward'];
    customerNote = json['customer_note'];
    customerFacebook = json['customer_facebook'];
    customerAccountingCode = json['customer_accounting_code'];
    customerStatus = json['customer_status'];
    code = json['code'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['customer_address'] = this.customerAddress;
    data['customer_district'] = this.customerDistrict;
    data['customer_city'] = this.customerCity;
    data['customer_type'] = this.customerType;
    data['customer_ward'] = this.customerWard;
    data['customer_note'] = this.customerNote;
    data['customer_facebook'] = this.customerFacebook;
    data['customer_accounting_code'] = this.customerAccountingCode;
    data['customer_status'] = this.customerStatus;
    data['code'] = this.code;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['customer_id'] = this.customerId;
    return data;
  }
}