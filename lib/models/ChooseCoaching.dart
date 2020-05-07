class ChooseCoaching {
  String userUid;
  String userId;
  String batchId;
  String admissionDate;
  String yearId;
  String userType;
  String coachingId;
  String status;
  String coachingName;
  String classId;

  ChooseCoaching(
      {this.userUid,
      this.userId,
      this.batchId,
      this.admissionDate,
      this.yearId,
      this.userType,
      this.coachingId,
      this.status,
      this.coachingName,
      this.classId});

  ChooseCoaching.fromJson(Map<String, dynamic> json) {
    userUid = json['user_uid'];
    userId = json['user_id'];
    batchId = json['batch_id'];
    admissionDate = json['admission_date'];
    yearId = json['year_id'];
    userType = json['user_type'];
    coachingId = json['coaching_id'];
    status = json['status'];
    coachingName = json['coaching_name'];
    classId = json['class_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_uid'] = this.userUid;
    data['user_id'] = this.userId;
    data['batch_id'] = this.batchId;
    data['admission_date'] = this.admissionDate;
    data['year_id'] = this.yearId;
    data['user_type'] = this.userType;
    data['coaching_id'] = this.coachingId;
    data['status'] = this.status;
    data['coaching_name'] = this.coachingName;
    data['class_id'] = this.classId;
    return data;
  }
}
