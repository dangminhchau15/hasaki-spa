class SearchBookingResponse {
  String message;
  int status;
  int code;
  Booking data;

  SearchBookingResponse({this.message, this.status, this.code, this.data});

  SearchBookingResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Booking.fromJson(json['data']) : null;
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

class Booking {
  List<Bookings> bookings;
  int total;
  Service service;
  Store store;

  Booking({this.bookings, this.total, this.service, this.store});

  Booking.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      bookings = new List<Bookings>();
      json['rows'].forEach((v) {
        bookings.add(new Bookings.fromJson(v));
      });
    }
    total = json['total'];

    // map key value from list store data
    // Map<String, dynamic> listStore = json['stores'];
    // Map<String, Store> listStoreByModel = Map.from(listStore.map((key, value) {
    //   List<dynamic> values = List.from(value);
    //   return MapEntry(
    //       key.toString(),
    //       values.map((store) {
    //         return Store.fromJson(store);
    //       }).toList());
    // }));

    // listStoreByModel.values.forEach((element) {
    //   store = element;
    // });

    //map key value from service group data
    // Map<String, dynamic> listService = json['serviceGroups'];
    // Map<String, Service> listServiceByModel =
    //     Map.from(listService.map((key, value) {
    //   List<dynamic> values = List.from(value);
    //   return MapEntry(key.toString(), values.map((service) {
    //     return Service.fromJson(service);
    //   }));
    // }));

    // listServiceByModel.values.forEach((element) {
    //   service = element;
    // });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookings != null) {
      data['rows'] = this.bookings.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    if (this.store != null) {
      data['stores'] = this.store.toJson();
    }
    if (this.service != null) {
      data['serviceGroups'] = this.service.toJson();
    }
    return data;
  }
}

class Service {
  int serviceGroupId;
  int serviceGroupSku;
  String serviceGroupName;
  int serviceGroupParent;
  int serviceGroupStatus;
  int serviceGroupUtime;
  int serviceGroupCtime;
  int skillIds;
  int subSkus;

  Service(
      {this.serviceGroupId,
      this.serviceGroupSku,
      this.serviceGroupName,
      this.serviceGroupParent,
      this.serviceGroupStatus,
      this.serviceGroupUtime,
      this.serviceGroupCtime,
      this.skillIds,
      this.subSkus});

  Service.fromJson(Map<String, dynamic> json) {
    serviceGroupId = json['service_group_id'];
    serviceGroupSku = json['service_group_sku'];
    serviceGroupName = json['service_group_name'];
    serviceGroupParent = json['service_group_parent'];
    serviceGroupStatus = json['service_group_status'];
    serviceGroupUtime = json['service_group_utime'];
    serviceGroupCtime = json['service_group_ctime'];
    skillIds = json['skill_ids'];
    subSkus = json['sub_skus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_group_id'] = this.serviceGroupId;
    data['service_group_sku'] = this.serviceGroupSku;
    data['service_group_name'] = this.serviceGroupName;
    data['service_group_parent'] = this.serviceGroupParent;
    data['service_group_status'] = this.serviceGroupStatus;
    data['service_group_utime'] = this.serviceGroupUtime;
    data['service_group_ctime'] = this.serviceGroupCtime;
    data['skill_ids'] = this.skillIds;
    data['sub_skus'] = this.subSkus;
    return data;
  }
}

class Store {
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

  Store(
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

  Store.fromJson(Map<String, dynamic> json) {
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

class Bookings {
  int bookingId;
  String bookingPhone;
  int bookingServiceId;
  String bookingDesc;
  int bookingUserId;
  int bookingCustomerId;
  int bookingServiceRepeat;
  int bookingStatus;
  String bookingName;
  String createdAt;
  String updatedAt;
  int beginTime;
  int endTime;
  int serviceSku;
  int bookingStaffId;
  int storeId;
  int bookingDate;
  int bookingCode;
  int serviceGroupSku;
  int confirmedBy;
  int importId;
  String resourceCode;
  String confirmedAt;
  String service;
  User user;

  Bookings(
      {this.bookingId,
      this.bookingPhone,
      this.bookingServiceId,
      this.bookingDesc,
      this.bookingUserId,
      this.bookingCustomerId,
      this.bookingServiceRepeat,
      this.bookingStatus,
      this.bookingName,
      this.createdAt,
      this.updatedAt,
      this.beginTime,
      this.endTime,
      this.serviceSku,
      this.bookingStaffId,
      this.storeId,
      this.bookingDate,
      this.bookingCode,
      this.serviceGroupSku,
      this.confirmedBy,
      this.importId,
      this.resourceCode,
      this.confirmedAt,
      this.service,
      this.user});

  Bookings.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingPhone = json['booking_phone'];
    bookingServiceId = json['booking_service_id'];
    bookingDesc = json['booking_desc'];
    bookingUserId = json['booking_user_id'];
    bookingCustomerId = json['booking_customer_id'];
    bookingServiceRepeat = json['booking_service_repeat'];
    bookingStatus = json['booking_status'];
    bookingName = json['booking_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    beginTime = json['begin_time'];
    endTime = json['end_time'];
    serviceSku = json['service_sku'];
    bookingStaffId = json['booking_staff_id'];
    storeId = json['store_id'];
    bookingDate = json['booking_date'];
    bookingCode = json['booking_code'];
    serviceGroupSku = json['service_group_sku'];
    confirmedBy = json['confirmed_by'];
    importId = json['import_id'];
    resourceCode = json['resource_code'];
    confirmedAt = json['confirmed_at'];
    service = json['service'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_phone'] = this.bookingPhone;
    data['booking_service_id'] = this.bookingServiceId;
    data['booking_desc'] = this.bookingDesc;
    data['booking_user_id'] = this.bookingUserId;
    data['booking_customer_id'] = this.bookingCustomerId;
    data['booking_service_repeat'] = this.bookingServiceRepeat;
    data['booking_status'] = this.bookingStatus;
    data['booking_name'] = this.bookingName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['begin_time'] = this.beginTime;
    data['end_time'] = this.endTime;
    data['service_sku'] = this.serviceSku;
    data['booking_staff_id'] = this.bookingStaffId;
    data['store_id'] = this.storeId;
    data['booking_date'] = this.bookingDate;
    data['booking_code'] = this.bookingCode;
    data['service_group_sku'] = this.serviceGroupSku;
    data['confirmed_by'] = this.confirmedBy;
    data['import_id'] = this.importId;
    data['resource_code'] = this.resourceCode;
    data['confirmed_at'] = this.confirmedAt;
    data['service'] = this.service;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
