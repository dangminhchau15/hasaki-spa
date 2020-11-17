class ReceiptListResponse {
  String message;
  int status;
  int code;
  Data data;

  ReceiptListResponse({this.message, this.status, this.code, this.data});

  ReceiptListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Stores> stores;
  dynamic sum;
  List<ReceiptList> rows;
  dynamic total;

  Data({this.stores, this.sum, this.rows, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = new List<Stores>();
      json['stores'].forEach((v) {
        stores.add(new Stores.fromJson(v));
      });
    }
    sum = json['sum'];
    if (json['rows'] != null) {
      rows = new List<ReceiptList>();
      json['rows'].forEach((v) {
        rows.add(new ReceiptList.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stores != null) {
      data['stores'] = this.stores.map((v) => v.toJson()).toList();
    }
    data['sum'] = this.sum;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Stores {
  int storeId;
  String storeName;
  int storeLocationId;
  int storeServiceId;
  int storeStockId;
  int storeStatus;
  int accountId;
  int locationId;
  int storeConfig;
  String properties;
  String storeInvoiceSeries;

  Stores(
      {this.storeId,
      this.storeName,
      this.storeLocationId,
      this.storeServiceId,
      this.storeStockId,
      this.storeStatus,
      this.accountId,
      this.locationId,
      this.storeConfig,
      this.properties,
      this.storeInvoiceSeries});

  Stores.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeLocationId = json['store_location_id'];
    storeServiceId = json['store_service_id'];
    storeStockId = json['store_stock_id'];
    storeStatus = json['store_status'];
    accountId = json['account_id'];
    locationId = json['location_id'];
    storeConfig = json['store_config'];
    properties = json['properties'];
    storeInvoiceSeries = json['store_invoice_series'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['store_location_id'] = this.storeLocationId;
    data['store_service_id'] = this.storeServiceId;
    data['store_stock_id'] = this.storeStockId;
    data['store_status'] = this.storeStatus;
    data['account_id'] = this.accountId;
    data['location_id'] = this.locationId;
    data['store_config'] = this.storeConfig;
    data['properties'] = this.properties;
    data['store_invoice_series'] = this.storeInvoiceSeries;
    return data;
  }
}

class ReceiptList {
  int receiptId;
  int receiptCode;
  int receiptUserId;
  int receiptCustomerId;
  int receiptCdate;
  int receiptUdate;
  int receiptCompletedDate;
  String receiptDesc;
  int receiptTotalItem;
  int receiptPayment;
  int receiptBankaccId;
  int receiptSubtotal;
  int receiptDiscount;
  int receiptTotal;
  int receiptStoreId;
  int receiptCash;
  int receiptCard;
  int receiptCustomerBalance;
  int receiptStatus;
  int receiptType;
  int receiptBalance;
  int receiptVoucherId;
  int receiptTotalDiscount;
  int netRevenue;
  int grossRevenue;
  int referenceCode;
  int config;
  User user;
  Customer customer;

  ReceiptList(
      {this.receiptId,
      this.receiptCode,
      this.receiptUserId,
      this.receiptCustomerId,
      this.receiptCdate,
      this.receiptUdate,
      this.receiptCompletedDate,
      this.receiptDesc,
      this.receiptTotalItem,
      this.receiptPayment,
      this.receiptBankaccId,
      this.receiptSubtotal,
      this.receiptDiscount,
      this.receiptTotal,
      this.receiptStoreId,
      this.receiptCash,
      this.receiptCard,
      this.receiptCustomerBalance,
      this.receiptStatus,
      this.receiptType,
      this.receiptBalance,
      this.receiptVoucherId,
      this.receiptTotalDiscount,
      this.netRevenue,
      this.grossRevenue,
      this.referenceCode,
      this.config,
      this.user,
      this.customer});

  ReceiptList.fromJson(Map<String, dynamic> json) {
    receiptId = json['receipt_id'];
    receiptCode = json['receipt_code'];
    receiptUserId = json['receipt_user_id'];
    receiptCustomerId = json['receipt_customer_id'];
    receiptCdate = json['receipt_cdate'];
    receiptUdate = json['receipt_udate'];
    receiptCompletedDate = json['receipt_completed_date'];
    receiptDesc = json['receipt_desc'];
    receiptTotalItem = json['receipt_total_item'];
    receiptPayment = json['receipt_payment'];
    receiptBankaccId = json['receipt_bankacc_id'];
    receiptSubtotal = json['receipt_subtotal'];
    receiptDiscount = json['receipt_discount'];
    receiptTotal = json['receipt_total'];
    receiptStoreId = json['receipt_store_id'];
    receiptCash = json['receipt_cash'];
    receiptCard = json['receipt_card'];
    receiptCustomerBalance = json['receipt_customer_balance'];
    receiptStatus = json['receipt_status'];
    receiptType = json['receipt_type'];
    receiptBalance = json['receipt_balance'];
    receiptVoucherId = json['receipt_voucher_id'];
    receiptTotalDiscount = json['receipt_total_discount'];
    netRevenue = json['net_revenue'];
    grossRevenue = json['gross_revenue'];
    referenceCode = json['reference_code'];
    config = json['config'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receipt_id'] = this.receiptId;
    data['receipt_code'] = this.receiptCode;
    data['receipt_user_id'] = this.receiptUserId;
    data['receipt_customer_id'] = this.receiptCustomerId;
    data['receipt_cdate'] = this.receiptCdate;
    data['receipt_udate'] = this.receiptUdate;
    data['receipt_completed_date'] = this.receiptCompletedDate;
    data['receipt_desc'] = this.receiptDesc;
    data['receipt_total_item'] = this.receiptTotalItem;
    data['receipt_payment'] = this.receiptPayment;
    data['receipt_bankacc_id'] = this.receiptBankaccId;
    data['receipt_subtotal'] = this.receiptSubtotal;
    data['receipt_discount'] = this.receiptDiscount;
    data['receipt_total'] = this.receiptTotal;
    data['receipt_store_id'] = this.receiptStoreId;
    data['receipt_cash'] = this.receiptCash;
    data['receipt_card'] = this.receiptCard;
    data['receipt_customer_balance'] = this.receiptCustomerBalance;
    data['receipt_status'] = this.receiptStatus;
    data['receipt_type'] = this.receiptType;
    data['receipt_balance'] = this.receiptBalance;
    data['receipt_voucher_id'] = this.receiptVoucherId;
    data['receipt_total_discount'] = this.receiptTotalDiscount;
    data['net_revenue'] = this.netRevenue;
    data['gross_revenue'] = this.grossRevenue;
    data['reference_code'] = this.referenceCode;
    data['config'] = this.config;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
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
