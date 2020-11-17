// To parse this JSON data, do
//
//     final getListBookingResponse = getListBookingResponseFromJson(jsonString);

import 'dart:convert';

GetListBookingResponse getListBookingResponseFromJson(String str) => GetListBookingResponse.fromJson(json.decode(str));

String getListBookingResponseToJson(GetListBookingResponse data) => json.encode(data.toJson());

class GetListBookingResponse {
    GetListBookingResponse({
        this.message,
        this.status,
        this.code,
        this.data,
    });

    String message;
    int status;
    int code;
    Data data;

    factory GetListBookingResponse.fromJson(Map<String, dynamic> json) => GetListBookingResponse(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    Data({
        this.bookings,
        this.services,
        //this.staffs,
        this.total,
        this.stores,
        this.serviceGroups,
        this.status,
    });

    List<Booking> bookings;
    List<dynamic> services;
    // Staffs staffs;
    int total;
    Map<String, StoreBooking> stores;
    Map<String, ServiceGroup> serviceGroups;
    Map<String, String> status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bookings: json["rows"] == null ? null : List<Booking>.from(json["rows"].map((x) => Booking.fromJson(x))),
        services: json["services"] == null ? null : List<dynamic>.from(json["services"].map((x) => x)),
        // staffs: json["staffs"] == null ? null : Staffs.fromJson(json["staffs"]),
        total: json["total"] == null ? null : json["total"],
        stores: json["stores"] == null ? null : Map.from(json["stores"]).map((k, v) => MapEntry<String, StoreBooking>(k, StoreBooking.fromJson(v))),
        serviceGroups: json["serviceGroups"] == null ? null : Map.from(json["serviceGroups"]).map((k, v) => MapEntry<String, ServiceGroup>(k, ServiceGroup.fromJson(v))),
        status: json["status"] == null ? null : Map.from(json["status"]).map((k, v) => MapEntry<String, String>(k, v)),
    );

    Map<String, dynamic> toJson() => {
        "rows": bookings == null ? null : List<dynamic>.from(bookings.map((x) => x.toJson())),
        "services": services == null ? null : List<dynamic>.from(services.map((x) => x)),
        //"staffs": staffs == null ? null : staffs.toJson(),
        "total": total == null ? null : total,
        "stores": stores == null ? null : Map.from(stores).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "serviceGroups": serviceGroups == null ? null : Map.from(serviceGroups).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "status": status == null ? null : Map.from(status).map((k, v) => MapEntry<String, dynamic>(k, v)),
    };
}

class Booking {
    Booking({
        this.bookingId,
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
        this.user,
        this.staff,
    });

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
    dynamic serviceSku;
    dynamic bookingStaffId;
    int storeId;
    int bookingDate;
    int bookingCode;
    int serviceGroupSku;
    int confirmedBy;
    int importId;
    ResourceCode resourceCode;
    dynamic confirmedAt;
    dynamic service;
    User user;
    dynamic staff;

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json["booking_id"] == null ? null : json["booking_id"],
        bookingPhone: json["booking_phone"] == null ? null : json["booking_phone"],
        bookingServiceId: json["booking_service_id"] == null ? null : json["booking_service_id"],
        bookingDesc: json["booking_desc"] == null ? null : json["booking_desc"],
        bookingUserId: json["booking_user_id"] == null ? null : json["booking_user_id"],
        bookingCustomerId: json["booking_customer_id"] == null ? null : json["booking_customer_id"],
        bookingServiceRepeat: json["booking_service_repeat"] == null ? null : json["booking_service_repeat"],
        bookingStatus: json["booking_status"] == null ? null : json["booking_status"],
        bookingName: json["booking_name"] == null ? null : json["booking_name"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        beginTime: json["begin_time"] == null ? null : json["begin_time"],
        endTime: json["end_time"] == null ? null : json["end_time"],
        serviceSku: json["service_sku"],
        bookingStaffId: json["booking_staff_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        bookingDate: json["booking_date"] == null ? null : json["booking_date"],
        bookingCode: json["booking_code"] == null ? null : json["booking_code"],
        serviceGroupSku: json["service_group_sku"] == null ? null : json["service_group_sku"],
        confirmedBy: json["confirmed_by"] == null ? null : json["confirmed_by"],
        importId: json["import_id"] == null ? null : json["import_id"],
        resourceCode: json["resource_code"] == null ? null : resourceCodeValues.map[json["resource_code"]],
        confirmedAt: json["confirmed_at"],
        service: json["service"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        staff: json["staff"],
    );

    Map<String, dynamic> toJson() => {
        "booking_id": bookingId == null ? null : bookingId,
        "booking_phone": bookingPhone == null ? null : bookingPhone,
        "booking_service_id": bookingServiceId == null ? null : bookingServiceId,
        "booking_desc": bookingDesc == null ? null : bookingDesc,
        "booking_user_id": bookingUserId == null ? null : bookingUserId,
        "booking_customer_id": bookingCustomerId == null ? null : bookingCustomerId,
        "booking_service_repeat": bookingServiceRepeat == null ? null : bookingServiceRepeat,
        "booking_status": bookingStatus == null ? null : bookingStatus,
        "booking_name": bookingName == null ? null : bookingName,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "begin_time": beginTime == null ? null : beginTime,
        "end_time": endTime == null ? null : endTime,
        "service_sku": serviceSku,
        "booking_staff_id": bookingStaffId,
        "store_id": storeId == null ? null : storeId,
        "booking_date": bookingDate == null ? null : bookingDate,
        "booking_code": bookingCode == null ? null : bookingCode,
        "service_group_sku": serviceGroupSku == null ? null : serviceGroupSku,
        "confirmed_by": confirmedBy == null ? null : confirmedBy,
        "import_id": importId == null ? null : importId,
        "resource_code": resourceCode == null ? null : resourceCodeValues.reverse[resourceCode],
        "confirmed_at": confirmedAt,
        "service": service,
        "user": user == null ? null : user.toJson(),
        "staff": staff,
    };
}

enum ResourceCode { EMPTY, THE_11122233344 }

final resourceCodeValues = EnumValues({
    "": ResourceCode.EMPTY,
    "111-222-333-44": ResourceCode.THE_11122233344
});

class User {
    User({
        this.id,
        this.name,
        this.email,
    });

    int id;
    String name;
    String email;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null :email,
    };
}

class ServiceGroup {
    ServiceGroup({
        this.serviceGroupId,
        this.serviceGroupSku,
        this.serviceGroupName,
        this.serviceGroupParent,
        this.serviceGroupStatus,
        this.serviceGroupUtime,
        this.serviceGroupCtime,
        this.skillIds,
        this.subSkus,
    });

    int serviceGroupId;
    int serviceGroupSku;
    String serviceGroupName;
    int serviceGroupParent;
    int serviceGroupStatus;
    int serviceGroupUtime;
    int serviceGroupCtime;
    dynamic skillIds;
    dynamic subSkus;

    factory ServiceGroup.fromJson(Map<String, dynamic> json) => ServiceGroup(
        serviceGroupId: json["service_group_id"] == null ? null : json["service_group_id"],
        serviceGroupSku: json["service_group_sku"] == null ? null : json["service_group_sku"],
        serviceGroupName: json["service_group_name"] == null ? null : json["service_group_name"],
        serviceGroupParent: json["service_group_parent"] == null ? null : json["service_group_parent"],
        serviceGroupStatus: json["service_group_status"] == null ? null : json["service_group_status"],
        serviceGroupUtime: json["service_group_utime"] == null ? null : json["service_group_utime"],
        serviceGroupCtime: json["service_group_ctime"] == null ? null : json["service_group_ctime"],
        skillIds: json["skill_ids"],
        subSkus: json["sub_skus"],
    );

    Map<String, dynamic> toJson() => {
        "service_group_id": serviceGroupId == null ? null : serviceGroupId,
        "service_group_sku": serviceGroupSku == null ? null : serviceGroupSku,
        "service_group_name": serviceGroupName == null ? null : serviceGroupName,
        "service_group_parent": serviceGroupParent == null ? null : serviceGroupParent,
        "service_group_status": serviceGroupStatus == null ? null : serviceGroupStatus,
        "service_group_utime": serviceGroupUtime == null ? null : serviceGroupUtime,
        "service_group_ctime": serviceGroupCtime == null ? null : serviceGroupCtime,
        "skill_ids": skillIds,
        "sub_skus": subSkus,
    };
}

class Staffs {
    Staffs({
        this.empty,
    });

    dynamic empty;

    factory Staffs.fromJson(Map<String, dynamic> json) => Staffs(
        empty: json[""],
    );

    Map<String, dynamic> toJson() => {
        "": empty,
    };
}

class StoreBooking {
    StoreBooking({
        this.storeId,
        this.storeName,
        this.storeLocationId,
        this.storeServiceId,
        this.storeStockId,
        this.storeStatus,
        this.accountId,
        this.locationId,
        this.storeConfig,
        this.properties,
        this.storeInvoiceSeries,
    });

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
    dynamic storeInvoiceSeries;

    factory StoreBooking.fromJson(Map<String, dynamic> json) => StoreBooking(
        storeId: json["store_id"] == null ? null : json["store_id"],
        storeName: json["store_name"] == null ? null : json["store_name"],
        storeLocationId: json["store_location_id"] == null ? null : json["store_location_id"],
        storeServiceId: json["store_service_id"] == null ? null : json["store_service_id"],
        storeStockId: json["store_stock_id"] == null ? null : json["store_stock_id"],
        storeStatus: json["store_status"] == null ? null : json["store_status"],
        accountId: json["account_id"] == null ? null : json["account_id"],
        locationId: json["location_id"] == null ? null : json["location_id"],
        storeConfig: json["store_config"] == null ? null : json["store_config"],
        properties: json["properties"] == null ? null : json["properties"],
        storeInvoiceSeries: json["store_invoice_series"],
    );

    Map<String, dynamic> toJson() => {
        "store_id": storeId == null ? null : storeId,
        "store_name": storeName == null ? null : storeName,
        "store_location_id": storeLocationId == null ? null : storeLocationId,
        "store_service_id": storeServiceId == null ? null : storeServiceId,
        "store_stock_id": storeStockId == null ? null : storeStockId,
        "store_status": storeStatus == null ? null : storeStatus,
        "account_id": accountId == null ? null : accountId,
        "location_id": locationId == null ? null : locationId,
        "store_config": storeConfig == null ? null : storeConfig,
        "properties": properties == null ? null : properties,
        "store_invoice_series": storeInvoiceSeries,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
