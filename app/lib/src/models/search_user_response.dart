// To parse this JSON data, do
//
//     final searchUserResponse = searchUserResponseFromJson(jsonString);

import 'dart:convert';

SearchUserResponse searchUserResponseFromJson(String str) => SearchUserResponse.fromJson(json.decode(str));

String searchUserResponseToJson(SearchUserResponse data) => json.encode(data.toJson());

class SearchUserResponse {
    SearchUserResponse({
        this.message,
        this.status,
        this.code,
        this.data,
    });

    String message;
    int status;
    int code;
    Data data;

    factory SearchUserResponse.fromJson(Map<String, dynamic> json) => SearchUserResponse(
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
        this.rows,
        this.total,
    });

    List<SearchUser> rows;
    dynamic total;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        rows: json["rows"] == null ? null : List<SearchUser>.from(json["rows"].map((x) => SearchUser.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "rows": rows == null ? null : List<dynamic>.from(rows.map((x) => x.toJson())),
        "total": total,
    };
}

class SearchUser {
    SearchUser({
        this.id,
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
    });

    int id;
    String name;
    int facebookId;
    String avatar;
    String email;
    String rememberToken;
    int roleId;
    int status;
    int config;
    dynamic twoFactorKey;
    DateTime createdAt;
    DateTime updatedAt;
    String locale;

    factory SearchUser.fromJson(Map<String, dynamic> json) => SearchUser(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        facebookId: json["facebook_id"] == null ? null : json["facebook_id"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        email: json["email"] == null ? null : json["email"],
        rememberToken: json["remember_token"] == null ? null : json["remember_token"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        status: json["status"] == null ? null : json["status"],
        config: json["config"] == null ? null : json["config"],
        twoFactorKey: json["two_factor_key"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        locale: json["locale"] == null ? null : json["locale"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "facebook_id": facebookId == null ? null : facebookId,
        "avatar": avatar == null ? null : avatar,
        "email": email == null ? null : email,
        "remember_token": rememberToken == null ? null : rememberToken,
        "role_id": roleId == null ? null : roleId,
        "status": status == null ? null : status,
        "config": config == null ? null : config,
        "two_factor_key": twoFactorKey,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "locale": locale == null ? null : locale,
    };
}
