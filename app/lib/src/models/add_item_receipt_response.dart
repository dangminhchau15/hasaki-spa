class AddItemResponse {
  String message;
  int status;
  int code;
  Data data;

  AddItemResponse({this.message, this.status, this.code, this.data});

  AddItemResponse.fromJson(Map<String, dynamic> json) {
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
  ConsultantAddItem consultant;
  User user;
  Customer customer;

  Data({this.consultant, this.user, this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    consultant = json['consultant'] != null
        ? new ConsultantAddItem.fromJson(json['consultant'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consultant != null) {
      data['consultant'] = this.consultant.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class ConsultantAddItem {
  int id;
  int code;
  int userId;
  int customerId;
  String note;
  int status;
  int storeId;
  String receiptCode;
  String createdAt;
  String updatedAt;
  int editingBy;
  int createBy;
  int type;
  int bookingCode;
  String prescriptionCode;
  String serviceGroup;
  List<ServiceItem> items;

  ConsultantAddItem(
      {this.id,
      this.code,
      this.userId,
      this.customerId,
      this.note,
      this.status,
      this.storeId,
      this.receiptCode,
      this.createdAt,
      this.updatedAt,
      this.editingBy,
      this.createBy,
      this.type,
      this.bookingCode,
      this.prescriptionCode,
      this.serviceGroup,
      this.items});

  ConsultantAddItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    note = json['note'];
    status = json['status'];
    storeId = json['store_id'];
    receiptCode = json['receipt_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    editingBy = json['editing_by'];
    createBy = json['create_by'];
    type = json['type'];
    bookingCode = json['booking_code'];
    prescriptionCode = json['prescription_code'];
    serviceGroup = json['service_group'];
    if (json['items'] != null) {
      items = new List<ServiceItem>();
      json['items'].forEach((v) {
        items.add(new ServiceItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['customer_id'] = this.customerId;
    data['note'] = this.note;
    data['status'] = this.status;
    data['store_id'] = this.storeId;
    data['receipt_code'] = this.receiptCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['editing_by'] = this.editingBy;
    data['create_by'] = this.createBy;
    data['type'] = this.type;
    data['booking_code'] = this.bookingCode;
    data['prescription_code'] = this.prescriptionCode;
    data['service_group'] = this.serviceGroup;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceItem {
  int id;
  int consultantId;
  int sku;
  int qty;
  String note;
  int type;
  int status;
  String createdAt;
  String updatedAt;
  ServiceReceipt service;

  ServiceItem(
      {this.id,
      this.consultantId,
      this.sku,
      this.qty,
      this.note,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.service});

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    consultantId = json['consultant_id'];
    sku = json['sku'];
    qty = json['qty'];
    note = json['note'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    service =
        json['service'] != null ? new ServiceReceipt.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['consultant_id'] = this.consultantId;
    data['sku'] = this.sku;
    data['qty'] = this.qty;
    data['note'] = this.note;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.service != null) {
      data['service'] = this.service.toJson();
    }
    return data;
  }
}

class ServiceReceipt {
  int serviceId;
  String serviceName;
  int serviceSku;
  int servicePrice;
  int serviceTotalTime;
  int serviceRepeat;
  int serviceStaffDiscount;
  int serviceSequence;
  int serviceGroupId;
  int serviceStatus;
  int commission;
  int originalId;
  int type;
  int regularPrice;
  int skillId;
  String serviceOptions;
  String slug;

  ServiceReceipt(
      {this.serviceId,
      this.serviceName,
      this.serviceSku,
      this.servicePrice,
      this.serviceTotalTime,
      this.serviceRepeat,
      this.serviceStaffDiscount,
      this.serviceSequence,
      this.serviceGroupId,
      this.serviceStatus,
      this.commission,
      this.originalId,
      this.type,
      this.regularPrice,
      this.skillId,
      this.serviceOptions,
      this.slug});

  ServiceReceipt.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    serviceSku = json['service_sku'];
    servicePrice = json['service_price'];
    serviceTotalTime = json['service_total_time'];
    serviceRepeat = json['service_repeat'];
    serviceStaffDiscount = json['service_staff_discount'];
    serviceSequence = json['service_sequence'];
    serviceGroupId = json['service_group_id'];
    serviceStatus = json['service_status'];
    commission = json['commission'];
    originalId = json['original_id'];
    type = json['type'];
    regularPrice = json['regular_price'];
    skillId = json['skill_id'];
    serviceOptions = json['service_options'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['service_sku'] = this.serviceSku;
    data['service_price'] = this.servicePrice;
    data['service_total_time'] = this.serviceTotalTime;
    data['service_repeat'] = this.serviceRepeat;
    data['service_staff_discount'] = this.serviceStaffDiscount;
    data['service_sequence'] = this.serviceSequence;
    data['service_group_id'] = this.serviceGroupId;
    data['service_status'] = this.serviceStatus;
    data['commission'] = this.commission;
    data['original_id'] = this.originalId;
    data['type'] = this.type;
    data['regular_price'] = this.regularPrice;
    data['skill_id'] = this.skillId;
    data['service_options'] = this.serviceOptions;
    data['slug'] = this.slug;
    return data;
  }
}

class User {
  int id;
  String name;
  int facebookId;
  String avatar;
  String email;
  String rememberToken;
  int roleId;
  int status;
  int config;
  String twoFactorKey;
  String createdAt;
  String updatedAt;
  String locale;

  User(
      {this.id,
      this.name,
      this.facebookId,
      this.avatar,
      this.email,
      this.rememberToken,
      this.roleId,
      this.status,
      this.config,
      this.twoFactorKey,
      this.createdAt,
      this.updatedAt,
      this.locale});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    facebookId = json['facebook_id'];
    avatar = json['avatar'];
    email = json['email'];
    rememberToken = json['remember_token'];
    roleId = json['role_id'];
    status = json['status'];
    config = json['config'];
    twoFactorKey = json['two_factor_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['facebook_id'] = this.facebookId;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['remember_token'] = this.rememberToken;
    data['role_id'] = this.roleId;
    data['status'] = this.status;
    data['config'] = this.config;
    data['two_factor_key'] = this.twoFactorKey;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['locale'] = this.locale;
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
  String customerAccountingCode;
  int customerStatus;
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
      this.customerAccountingCode,
      this.customerStatus,
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
    customerAccountingCode = json['customer_accounting_code'];
    customerStatus = json['customer_status'];
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
    data['customer_accounting_code'] = this.customerAccountingCode;
    data['customer_status'] = this.customerStatus;
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