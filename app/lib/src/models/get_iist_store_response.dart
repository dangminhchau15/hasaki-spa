class GetListStoreResponse {
  String message;
  int status;
  int code;
  Data data;

  GetListStoreResponse({this.message, this.status, this.code, this.data});

  GetListStoreResponse.fromJson(Map<String, dynamic> json) {
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
  List<Store> stores;
  int total;

  Data({this.stores, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      stores = new List<Store>();
      json['rows'].forEach((v) {
        stores.add(new Store.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stores != null) {
      data['rows'] = this.stores.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
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
  dynamic storeInvoiceSeries;

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