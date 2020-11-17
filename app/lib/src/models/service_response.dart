class ServiceResponse {
  String message;
  int status;
  int code;
  Data data;

  ServiceResponse({this.message, this.status, this.code, this.data});

  ServiceResponse.fromJson(Map<String, dynamic> json) {
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
  List<ServiceSearch> services;
  int total;

  Data({this.services, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      services = new List<ServiceSearch>();
      json['rows'].forEach((v) {
        services.add(new ServiceSearch.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['rows'] = this.services.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ServiceSearch {
  int serviceId;
  String serviceName;
  int serviceSku;
  int servicePrice;
  int serviceTotalTime;
  int serviceRepeat;
  int serviceStaffDiscount;
  dynamic serviceSequence;
  int serviceGroupId;
  int serviceStatus;
  dynamic commission;
  dynamic originalId;
  int type;
  dynamic regularPrice;
  int skillId;
  dynamic serviceOptions;
  dynamic slug;

  ServiceSearch(
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

  ServiceSearch.fromJson(Map<String, dynamic> json) {
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