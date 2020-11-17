// To parse this JSON data, do
//
//     final getStaffListResponse = getStaffListResponseFromJson(jsonString);

import 'dart:convert';

GetStaffListResponse getStaffListResponseFromJson(String str) => GetStaffListResponse.fromJson(json.decode(str));

String getStaffListResponseToJson(GetStaffListResponse data) => json.encode(data.toJson());

class GetStaffListResponse {
    GetStaffListResponse({
        this.message,
        this.status,
        this.code,
        this.data,
    });

    String message;
    int status;
    int code;
    Data data;

    factory GetStaffListResponse.fromJson(Map<String, dynamic> json) => GetStaffListResponse(
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
    });

    List<Staff> rows;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        rows: json["rows"] == null ? null : List<Staff>.from(json["rows"].map((x) => Staff.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "rows": rows == null ? null : List<dynamic>.from(rows.map((x) => x.toJson())),
    };
}

class Staff {
    Staff({
        this.staffId,
        this.staffName,
        this.staffTitle,
        this.staffPhone,
        this.staffEmail,
        this.staffAddress,
        this.staffDeptId,
        this.staffStatus,
        this.staffDob,
        this.staffHireDate,
        this.persionalEmail,
        this.note,
        this.createdAt,
        this.updatedAt,
        this.staffLocId,
        this.code,
        this.dateContract,
        this.dateIntoCompany,
        this.dateOutCompany,
        this.dateRegister,
        this.cmnd,
        this.dateIssueCard,
        this.placeCard,
        this.dateBirth,
        this.birthPlace,
        this.salaryMode,
        this.divisionId,
        this.gender,
        this.nation,
        this.religion,
        this.degreeCertificate,
        this.taxCode,
        this.dateIssueTax,
        this.peopleCircumtanceNumber,
        this.bankAccount,
        this.bankBranch,
        this.bankName,
        this.majorId,
        this.socialInsuranceNumber,
        this.positionId,
        this.level,
        this.isApproved,
        this.accountingCode,
    });

    int staffId;
    String staffName;
    String staffTitle;
    String staffPhone;
    String staffEmail;
    String staffAddress;
    int staffDeptId;
    int staffStatus;
    dynamic staffDob;
    int staffHireDate;
    dynamic persionalEmail;
    String note;
    String createdAt;
    String updatedAt;
    int staffLocId;
    String code;
    dynamic dateContract;
    int dateIntoCompany;
    int dateOutCompany;
    int dateRegister;
    int cmnd;
    int dateIssueCard;
    String placeCard;
    dynamic dateBirth;
    int birthPlace;
    int salaryMode;
    int divisionId;
    int gender;
    dynamic nation;
    dynamic religion;
    dynamic degreeCertificate;
    dynamic taxCode;
    dynamic dateIssueTax;
    int peopleCircumtanceNumber;
    int bankAccount;
    String bankBranch;
    int bankName;
    int majorId;
    dynamic socialInsuranceNumber;
    int positionId;
    int level;
    int isApproved;
    dynamic accountingCode;

    factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        staffId: json["staff_id"] == null ? null : json["staff_id"],
        staffName: json["staff_name"] == null ? null : json["staff_name"],
        staffTitle: json["staff_title"] == null ? null : json["staff_title"],
        staffPhone: json["staff_phone"] == null ? null : json["staff_phone"],
        staffEmail: json["staff_email"] == null ? null : json["staff_email"],
        staffAddress: json["staff_address"] == null ? null : json["staff_address"],
        staffDeptId: json["staff_dept_id"] == null ? null : json["staff_dept_id"],
        staffStatus: json["staff_status"] == null ? null : json["staff_status"],
        staffDob: json["staff_dob"],
        staffHireDate: json["staff_hire_date"] == null ? null : json["staff_hire_date"],
        persionalEmail: json["persional_email"],
        note: json["note"] == null ? null : json["note"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        staffLocId: json["staff_loc_id"] == null ? null : json["staff_loc_id"],
        code: json["code"] == null ? null : json["code"],
        dateContract: json["date_contract"],
        dateIntoCompany: json["date_into_company"] == null ? null : json["date_into_company"],
        dateOutCompany: json["date_out_company"] == null ? null : json["date_out_company"],
        dateRegister: json["date_register"] == null ? null : json["date_register"],
        cmnd: json["cmnd"] == null ? null : json["cmnd"],
        dateIssueCard: json["date_issue_card"] == null ? null : json["date_issue_card"],
        placeCard: json["place_card"] == null ? null : json["place_card"],
        dateBirth: json["date_birth"],
        birthPlace: json["birth_place"] == null ? null : json["birth_place"],
        salaryMode: json["salary_mode"] == null ? null : json["salary_mode"],
        divisionId: json["division_id"] == null ? null : json["division_id"],
        gender: json["gender"] == null ? null : json["gender"],
        nation: json["nation"],
        religion: json["religion"],
        degreeCertificate: json["degree_certificate"],
        taxCode: json["tax_code"],
        dateIssueTax: json["date_issue_tax"],
        peopleCircumtanceNumber: json["people_circumtance_number"] == null ? null : json["people_circumtance_number"],
        bankAccount: json["bank_account"] == null ? null : json["bank_account"],
        bankBranch: json["bank_branch"] == null ? null : json["bank_branch"],
        bankName: json["bank_name"] == null ? null : json["bank_name"],
        majorId: json["major_id"] == null ? null : json["major_id"],
        socialInsuranceNumber: json["social_insurance_number"],
        positionId: json["position_id"] == null ? null : json["position_id"],
        level: json["level"] == null ? null : json["level"],
        isApproved: json["is_approved"] == null ? null : json["is_approved"],
        accountingCode: json["accounting_code"],
    );

    Map<String, dynamic> toJson() => {
        "staff_id": staffId == null ? null : staffId,
        "staff_name": staffName == null ? null : staffName,
        "staff_title": staffTitle == null ? null : staffTitle,
        "staff_phone": staffPhone == null ? null : staffPhone,
        "staff_email": staffEmail == null ? null : staffEmail,
        "staff_address": staffAddress == null ? null : staffAddress,
        "staff_dept_id": staffDeptId == null ? null : staffDeptId,
        "staff_status": staffStatus == null ? null : staffStatus,
        "staff_dob": staffDob,
        "staff_hire_date": staffHireDate == null ? null : staffHireDate,
        "persional_email": persionalEmail,
        "note": note == null ? null : note,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "staff_loc_id": staffLocId == null ? null : staffLocId,
        "code": code == null ? null : code,
        "date_contract": dateContract,
        "date_into_company": dateIntoCompany == null ? null : dateIntoCompany,
        "date_out_company": dateOutCompany == null ? null : dateOutCompany,
        "date_register": dateRegister == null ? null : dateRegister,
        "cmnd": cmnd == null ? null : cmnd,
        "date_issue_card": dateIssueCard == null ? null : dateIssueCard,
        "place_card": placeCard == null ? null : placeCard,
        "date_birth": dateBirth,
        "birth_place": birthPlace == null ? null : birthPlace,
        "salary_mode": salaryMode == null ? null : salaryMode,
        "division_id": divisionId == null ? null : divisionId,
        "gender": gender == null ? null : gender,
        "nation": nation,
        "religion": religion,
        "degree_certificate": degreeCertificate,
        "tax_code": taxCode,
        "date_issue_tax": dateIssueTax,
        "people_circumtance_number": peopleCircumtanceNumber == null ? null : peopleCircumtanceNumber,
        "bank_account": bankAccount == null ? null : bankAccount,
        "bank_branch": bankBranch == null ? null : bankBranch,
        "bank_name": bankName == null ? null : bankName,
        "major_id": majorId == null ? null : majorId,
        "social_insurance_number": socialInsuranceNumber,
        "position_id": positionId == null ? null : positionId,
        "level": level == null ? null : level,
        "is_approved": isApproved == null ? null : isApproved,
        "accounting_code": accountingCode,
    };
}
