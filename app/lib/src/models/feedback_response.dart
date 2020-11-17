class FeedbackResponse {
  String message;
  int status;
  int code;
  Data data;

  FeedbackResponse({this.message, this.status, this.code, this.data});

  FeedbackResponse.fromJson(Map<String, dynamic> json) {
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
  Feedback feedback;

  Data({this.feedback});

  Data.fromJson(Map<String, dynamic> json) {
    feedback = json['feedback'] != null
        ? new Feedback.fromJson(json['feedback'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feedback != null) {
      data['feedback'] = this.feedback.toJson();
    }
    return data;
  }
}

class Feedback {
  String customerId;
  String customerPhone;
  String receiptCode;
  String skuCode;
  String content;
  String staffId;
  String methodFeedback;
  String updatedAt;
  String createdAt;
  int customerFeedbackId;

  Feedback(
      {this.customerId,
      this.customerPhone,
      this.receiptCode,
      this.skuCode,
      this.content,
      this.staffId,
      this.methodFeedback,
      this.updatedAt,
      this.createdAt,
      this.customerFeedbackId});

  Feedback.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerPhone = json['customer_phone'];
    receiptCode = json['receipt_code'];
    skuCode = json['sku_code'];
    content = json['content'];
    staffId = json['staff_id'];
    methodFeedback = json['method_feedback'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    customerFeedbackId = json['customer_feedback_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_phone'] = this.customerPhone;
    data['receipt_code'] = this.receiptCode;
    data['sku_code'] = this.skuCode;
    data['content'] = this.content;
    data['staff_id'] = this.staffId;
    data['method_feedback'] = this.methodFeedback;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['customer_feedback_id'] = this.customerFeedbackId;
    return data;
  }
}