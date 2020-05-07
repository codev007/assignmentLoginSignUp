class StudentRequestPojo {
  String userId;
  String username;
  String mobile;
  String address;
  String birth;
  String gender;
  String fatherName;
  String image;
  String schoolName;
  String parentsMobile;
  String token;
  String userUid;
  String admissionDate;
  String batchName;
  int batchId;
  String className;
  int classId;

  StudentRequestPojo(
      {this.userId,
      this.username,
      this.mobile,
      this.address,
      this.birth,
      this.gender,
      this.fatherName,
      this.image,
      this.schoolName,
      this.parentsMobile,
      this.token,
      this.userUid,
      this.admissionDate,
      this.batchName,
      this.batchId,
      this.className,
      this.classId});

  StudentRequestPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    mobile = json['mobile'];
    address = json['address'];
    birth = json['birth'];
    gender = json['gender'];
    fatherName = json['father_name'];
    image = json['image'];
    schoolName = json['school_name'];
    parentsMobile = json['parents_mobile'];
    token = json['token'];
    userUid = json['user_uid'];
    admissionDate = json['admission_date'];
    batchName = json['batch_name'];
    batchId = json['batch_id'];
    className = json['class_name'];
    classId = json['class_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['birth'] = this.birth;
    data['gender'] = this.gender;
    data['father_name'] = this.fatherName;
    data['image'] = this.image;
    data['school_name'] = this.schoolName;
    data['parents_mobile'] = this.parentsMobile;
    data['token'] = this.token;
    data['user_uid'] = this.userUid;
    data['admission_date'] = this.admissionDate;
    data['batch_name'] = this.batchName;
    data['batch_id'] = this.batchId;
    data['class_name'] = this.className;
    data['class_id'] = this.classId;
    return data;
  }
}