class CreateConsultantResponse {
  String message;
  int status;
  int code;
  Data data;

  CreateConsultantResponse({this.message, this.status, this.code, this.data});

  CreateConsultantResponse.fromJson(Map<String, dynamic> json) {
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
  ConsultantDetail consultant;

  Data({this.consultant});

  Data.fromJson(Map<String, dynamic> json) {
    consultant = json['consultant'] != null
        ? new ConsultantDetail.fromJson(json['consultant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consultant != null) {
      data['consultant'] = this.consultant.toJson();
    }
    return data;
  }
}

class ConsultantDetail {
  int userId;
  int editingBy;
  int storeId;
  String code;
  String customerId;
  int createBy;
  int status;
  int type;
  String updatedAt;
  String createdAt;
  int id;

  ConsultantDetail(
      {this.userId,
      this.editingBy,
      this.storeId,
      this.code,
      this.customerId,
      this.createBy,
      this.status,
      this.type,
      this.updatedAt,
      this.createdAt,
      this.id});

  ConsultantDetail.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    editingBy = json['editing_by'];
    storeId = json['store_id'];
    code = json['code'];
    customerId = json['customer_id'];
    createBy = json['create_by'];
    status = json['status'];
    type = json['type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['editing_by'] = this.editingBy;
    data['store_id'] = this.storeId;
    data['code'] = this.code;
    data['customer_id'] = this.customerId;
    data['create_by'] = this.createBy;
    data['status'] = this.status;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}