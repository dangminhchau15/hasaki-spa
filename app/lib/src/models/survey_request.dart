class SurveyRequest {
  int customerFeedbackId;
  String receiptCode;
  int staffId;
  List<QuestionRequest> questions;

  SurveyRequest({this.customerFeedbackId, this.questions});

  SurveyRequest.fromJson(Map<String, dynamic> json) {
    customerFeedbackId = json['customer_feedback_id'];
    receiptCode = json['receipt_code'];
    staffId = json['staff_id'];
    if (json['questions'] != null) {
      questions = new List<QuestionRequest>();
      json['questions'].forEach((v) {
        questions.add(new QuestionRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_feedback_id'] = this.customerFeedbackId;
    data['receipt_code'] = this.receiptCode;
    data['staff_id'] = this.staffId;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionRequest {
  int questionId;
  int skuCode;
  List<AnswerRequest> answers = [];

  QuestionRequest({this.questionId, this.skuCode, this.answers});

  QuestionRequest.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    skuCode = json['sku_code'];
    if (json['answers'] != null) {
      answers = new List<AnswerRequest>();
      json['answers'].forEach((v) {
        answers.add(new AnswerRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['sku_code'] = this.skuCode;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerRequest {
  int answerId;
  String answerContent;
  int questionId;
  int answerType;
  bool isChecked;
  int answerPoint;
  String updatedAt;
  String createdAt;
  String answerText;

  int get myAnswerId => answerId;

  set myAnswerId(int answerId) {
    this.answerId = answerId;
  }

  AnswerRequest(
      {this.answerId,
      this.answerContent,
      this.answerPoint,
      this.isChecked,
      this.questionId,
      this.answerType,
      this.updatedAt,
      this.createdAt,
      this.answerText});

  AnswerRequest.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    answerContent = json['answer_content'];
    questionId = json['question_id'];
    answerType = json['answer_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    answerText = json['answer_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_id'] = this.answerId;
    data['answer_content'] = this.answerContent;
    data['question_id'] = this.questionId;
    data['answer_type'] = this.answerType;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['answer_text'] = this.answerText;
    return data;
  }
}
