class ProfileResponse {
  String message;
  int status;
  int code;
  Data data;

  ProfileResponse({this.message, this.status, this.code, this.data});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
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
  Profile profile;
  StaffInfo staffInfo;
  List<String> permission;

  Data({this.profile, this.staffInfo, this.permission});

  Data.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    staffInfo = json['staff_info'] != null
        ? new StaffInfo.fromJson(json['staff_info'])
        : null;
    permission = json['permission'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    if (this.staffInfo != null) {
      data['staff_info'] = this.staffInfo.toJson();
    }
    data['permission'] = this.permission;
    return data;
  }
}

class Profile {
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
  int storeId;
  List<Stores> stores;

  Profile(
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
      this.locale,
      this.storeId,
      this.stores});

  Profile.fromJson(Map<String, dynamic> json) {
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
    storeId = json['store_id'];
    if (json['stores'] != null) {
      stores = new List<Stores>();
      json['stores'].forEach((v) {
        stores.add(new Stores.fromJson(v));
      });
    }
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
    data['store_id'] = this.storeId;
    if (this.stores != null) {
      data['stores'] = this.stores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  int id;
  int userId;
  int storeId;
  int status;
  String createdAt;
  String updatedAt;

  Stores(
      {this.id,
      this.userId,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt});

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class StaffInfo {
  int staffId;
  String staffName;
  String staffTitle;
  String staffEmail;
  int staffDeptId;
  // int code;
  int staffLocId;
  int positionId;
  int divisionId;
  int majorId;

  StaffInfo(
      {this.staffId,
      this.staffName,
      this.staffTitle,
      this.staffEmail,
      this.staffDeptId,
      //this.code,
      this.staffLocId,
      this.positionId,
      this.divisionId,
      this.majorId});

  StaffInfo.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    staffTitle = json['staff_title'];
    staffEmail = json['staff_email'];
    staffDeptId = json['staff_dept_id'];
    //code = json['code'];
    staffLocId = json['staff_loc_id'];
    positionId = json['position_id'];
    divisionId = json['division_id'];
    majorId = json['major_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['staff_title'] = this.staffTitle;
    data['staff_email'] = this.staffEmail;
    data['staff_dept_id'] = this.staffDeptId;
    //data['code'] = this.code;
    data['staff_loc_id'] = this.staffLocId;
    data['position_id'] = this.positionId;
    data['division_id'] = this.divisionId;
    data['major_id'] = this.majorId;
    return data;
  }
}