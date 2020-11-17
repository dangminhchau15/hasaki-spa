class GetServiceGroupResponse {
  String message;
	int status;
	int code;
	Data data;

	GetServiceGroupResponse({this.message, this.status, this.code, this.data});

	GetServiceGroupResponse.fromJson(Map<String, dynamic> json) {
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
	Map<String, Service> services;
	int total;

	Data({this.services, this.total});

	Data.fromJson(Map<String, dynamic> json) {
    if(json['rows'] != null) {
      services = new Map<String, Service>();
      json['rows'].forEach((k, v) => services[k] = new Service.fromJson(v));
    }
		total = json['total'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.services != null) {
      data['rows'] = this.services.map((key, value) => MapEntry(key, value.toJson()));
    }
		data['total'] = this.total;
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
  String skillIds;
  String subSkus;

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