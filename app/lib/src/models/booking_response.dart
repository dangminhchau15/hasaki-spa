class BookingResponse {
  String message;
  int status;
  int code;
  Data data;

  BookingResponse({this.message, this.status, this.code, this.data});

  BookingResponse.fromJson(Map<String, dynamic> json) {
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
  Booking booking;

  Data({this.booking});

  Data.fromJson(Map<String, dynamic> json) {
    booking = json['booking'] != false ? new Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booking != null) {
      data['booking'] = this.booking.toJson();
    }
    return data;
  }
}

class Booking {
  int bookingDate;
  String bookingPhone;
  String bookingName;
  String bookingDesc;
  int bookingUserId;
  String storeId;
  int beginTime;
  int endTime;
  int bookingStatus;
  String updatedAt;
  String createdAt;
  int bookingId;

  Booking(
      {this.bookingDate,
      this.bookingPhone,
      this.bookingName,
      this.bookingDesc,
      this.bookingUserId,
      this.storeId,
      this.beginTime,
      this.endTime,
      this.bookingStatus,
      this.updatedAt,
      this.createdAt,
      this.bookingId});

  Booking.fromJson(Map<String, dynamic> json) {
    bookingDate = json['booking_date'];
    bookingPhone = json['booking_phone'];
    bookingName = json['booking_name'];
    bookingDesc = json['booking_desc'];
    bookingUserId = json['booking_user_id'];
    storeId = json['store_id'];
    beginTime = json['begin_time'];
    endTime = json['end_time'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_date'] = this.bookingDate;
    data['booking_phone'] = this.bookingPhone;
    data['booking_name'] = this.bookingName;
    data['booking_desc'] = this.bookingDesc;
    data['booking_user_id'] = this.bookingUserId;
    data['store_id'] = this.storeId;
    data['begin_time'] = this.beginTime;
    data['end_time'] = this.endTime;
    data['booking_status'] = this.bookingStatus;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['booking_id'] = this.bookingId;
    return data;
  }
}
