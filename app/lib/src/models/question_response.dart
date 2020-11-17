import 'package:app/src/models/survey_request.dart';

class QuestionResponse {
  String message;
  int status;
  int code;
  Data data;

  QuestionResponse({this.message, this.status, this.code, this.data});

  QuestionResponse.fromJson(Map<String, dynamic> json) {
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
  int total;
  List<Question> questions;

  Data({this.total, this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      questions = new List<Question>();
      json['rows'].forEach((v) {
        questions.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.questions != null) {
      data['rows'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  int questionId;
  String questionTitle;
  int groupQuestionId;
  int serviceGroup;
  int serviceSku;
  String createdAt;
  String updatedAt;
  List<Answer> answers;
  int answerId;
  int questionType;
  List<AnswerRequest> answerRequest;

  Question(
      {this.questionId,
      this.questionTitle,
      this.groupQuestionId,
      this.answerId,
      this.serviceGroup,
      this.serviceSku,
      this.createdAt,
      this.answerRequest,
      this.updatedAt,
      this.answers});

  Question.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    questionTitle = json['question_title'];
    groupQuestionId = json['group_question_id'];
    serviceGroup = json['service_group'];
    questionType = json['question_type'];
    serviceSku = json['service_sku'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['answers'] != null) {
      answers = new List<Answer>();
      json['answers'].forEach((v) {
        answers.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['question_title'] = this.questionTitle;
    data['group_question_id'] = this.groupQuestionId;
    data['service_group'] = this.serviceGroup;
    data['service_sku'] = this.serviceSku;
    data['created_at'] = this.createdAt;
    data['question_type'] = this.questionType;
    data['updated_at'] = this.updatedAt;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answer {
  int answerId;
  String answerContent;
  String answerText;
  int questionId;
  int answerPoint;
  bool isChecked;
  int answerType;
  String createdAt;
  String updatedAt;

  Answer(
      {this.answerId,
      this.answerContent,
      this.questionId,
      this.answerPoint,
      this.answerType,
      this.createdAt,
      this.updatedAt});

  Answer.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    answerContent = json['answer_content'];
    questionId = json['question_id'];
    answerPoint = json['answer_point'];
    answerType = json['answer_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_id'] = this.answerId;
    data['answer_content'] = this.answerContent;
    data['question_id'] = this.questionId;
    data['answer_point'] = this.answerPoint;
    data['answer_type'] = this.answerType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}