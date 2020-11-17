class GetListNotifyResponse {
  String message;
  int status;
  Data data;

  GetListNotifyResponse({this.message, this.status, this.data});

  GetListNotifyResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Notify> notifies;

  Data({this.notifies});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      notifies = new List<Notify>();
      json['rows'].forEach((v) {
        notifies.add(new Notify.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifies != null) {
      data['rows'] = this.notifies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notify {
  String sId;
  int staffCode;
  int appId;
  String title;
  String message;
  int locationId;
  int departmentId;
  int type;
  //List<Null> extraData;
  int status;
  int isRead;
  String updatedAt;
  String createdAt;
  int feedbackAt;

  Notify(
      {this.sId,
      this.staffCode,
      this.appId,
      this.title,
      this.message,
      this.locationId,
      this.departmentId,
      this.type,
      //this.extraData,
      this.status,
      this.isRead,
      this.updatedAt,
      this.createdAt,
      this.feedbackAt});

  Notify.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    staffCode = json['staff_code'];
    appId = json['app_id'];
    title = json['title'];
    message = json['message'];
    locationId = json['location_id'];
    departmentId = json['department_id'];
    type = json['type'];
    // if (json['extra_data'] != null) {
    //   extraData = new List<Null>();
    //   json['extra_data'].forEach((v) {
    //     extraData.add(new Null.fromJson(v));
    //   });
    // }
    status = json['status'];
    isRead = json['is_read'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    feedbackAt = json['feedback_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['staff_code'] = this.staffCode;
    data['app_id'] = this.appId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['location_id'] = this.locationId;
    data['department_id'] = this.departmentId;
    data['type'] = this.type;
    // if (this.extraData != null) {
    //   data['extra_data'] = this.extraData.map((v) => v.toJson()).toList();
    // }
    data['status'] = this.status;
    data['is_read'] = this.isRead;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['feedback_at'] = this.feedbackAt;
    return data;
  }
}