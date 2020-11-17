class SurveyResponse {
  String message;
  int status;
  int code;
  Data data;

  SurveyResponse({this.message, this.status, this.code, this.data});

  SurveyResponse.fromJson(Map<String, dynamic> json) {
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
  Result result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  int customerFeedbackId;
  List<Questions> questions;

  Result({this.customerFeedbackId, this.questions});

  Result.fromJson(Map<String, dynamic> json) {
    customerFeedbackId = json['customer_feedback_id'];
    if (json['questions'] != null) {
      questions = new List<Questions>();
      json['questions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_feedback_id'] = this.customerFeedbackId;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int questionId;
  List<Answers> answers;

  Questions({this.questionId, this.answers});

  Questions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    if (json['answers'] != null) {
      answers = new List<Answers>();
      json['answers'].forEach((v) {
        answers.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int answerId;
  String answerContent;
  String answerText;
  int questionId;
  int answerType;
  String updatedAt;
  String createdAt;

  Answers(
      {this.answerId,
      this.answerContent,
      this.questionId,
      this.answerType,
      this.updatedAt,
      this.createdAt});

  Answers.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    answerContent = json['answer_content'];
    questionId = json['question_id'];
    answerText = json['answer_text'];
    answerType = json['answer_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_id'] = this.answerId;
    data['answer_content'] = this.answerContent;
    data['question_id'] = this.questionId;
    data['answer_type'] = this.answerType;
    data['answer_text'] = this.answerText;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}