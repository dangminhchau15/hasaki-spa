class CheckCustomerPhoneResponse {
  String message;
  int status;
  int code;
  Data data;

  CheckCustomerPhoneResponse({this.message, this.status, this.code, this.data});

  CheckCustomerPhoneResponse.fromJson(Map<String, dynamic> json) {
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
  //AccountBalance accountBalance;

   Data({this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    // accountBalance = json['account_balance'] != null
    //     ? new AccountBalance.fromJson(json['account_balance'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    // if (this.accountBalance != null) {
    //   data['account_balance'] = this.accountBalance.toJson();
    // }
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

// class AccountBalance {
//   Account account;
//   List<Balance> balance;

//   AccountBalance({this.account, this.balance});

//   AccountBalance.fromJson(Map<String, dynamic> json) {
//     account = json['account'] != null ? new Account.fromJson(json['account']) : null;
//     if (json['balance'] != null) {
//       balance = new List<Balance>();
//       json['balance'].forEach((v) {
//         balance.add(new Balance.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.account != null) {
//       data['account'] = this.account.toJson();
//     }
//     if (this.balance != null) {
//       data['balance'] = this.balance.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Account {
//   int id;
//   int groupId;
//   String accountCode;
//   int locationId;
//   int type;
//   String name;
//   String note;
//   int status;
//   String createdAt;
//   String updatedAt;

//   Account(
//       {this.id,
//       this.groupId,
//       this.accountCode,
//       this.locationId,
//       this.type,
//       this.name,
//       this.note,
//       this.status,
//       this.createdAt,
//       this.updatedAt});

//   Account.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     groupId = json['group_id'];
//     accountCode = json['account_code'];
//     locationId = json['location_id'];
//     type = json['type'];
//     name = json['name'];
//     note = json['note'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['group_id'] = this.groupId;
//     data['account_code'] = this.accountCode;
//     data['location_id'] = this.locationId;
//     data['type'] = this.type;
//     data['name'] = this.name;
//     data['note'] = this.note;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// class Balance {
//   int id;
//   int balanceType;
//   int debit;
//   int credit;
//   int accountId;
//   int status;
//   String createdAt;
//   String updatedAt;

//   Balance(
//       {this.id,
//       this.balanceType,
//       this.debit,
//       this.credit,
//       this.accountId,
//       this.status,
//       this.createdAt,
//       this.updatedAt});

//   Balance.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     balanceType = json['balance_type'];
//     debit = json['debit'];
//     credit = json['credit'];
//     accountId = json['account_id'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['balance_type'] = this.balanceType;
//     data['debit'] = this.debit;
//     data['credit'] = this.credit;
//     data['account_id'] = this.accountId;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }