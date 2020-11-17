import 'package:connectivity/connectivity.dart';

class GetListLocationResponse {
  String message;
  int status;
  int code;
  Data data;

  GetListLocationResponse({this.message, this.status, this.code, this.data});

  GetListLocationResponse.fromJson(Map<String, dynamic> json) {
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
  List<Location> rows;
  int total;

  Data({this.rows, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      rows = new List<Location>();
      json['rows'].forEach((v) {
        rows.add(new Location.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Location {
  int id;
  String name;
  int status;
  String createdAt;
  String updatedAt;
  String properties;
  String address;
  String alias;

  Location(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.properties,
      this.address,
      this.alias});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    properties = json['properties'];
    address = json['address'];
    alias = json['alias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['properties'] = this.properties;
    data['address'] = this.address;
    data['alias'] = this.alias;
    return data;
  }
}