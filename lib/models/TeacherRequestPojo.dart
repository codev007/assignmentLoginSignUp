class TeacherRequestPojo {
  String userUid;
  String userId;
  String admissionDate;
  String batchName;
  String className;
  String username;
  String mobile;
  String address;
  String birth;
  String gender;
  String fatherHusband;
  String image;
  String subjects;
  String experience;
  String token;

  TeacherRequestPojo(
      {this.userUid,
      this.userId,
      this.admissionDate,
      this.batchName,
      this.className,
      this.username,
      this.mobile,
      this.address,
      this.birth,
      this.gender,
      this.fatherHusband,
      this.image,
      this.subjects,
      this.experience,
      this.token});

  TeacherRequestPojo.fromJson(Map<String, dynamic> json) {
    userUid = json['user_uid'];
    userId = json['user_id'];
    admissionDate = json['admission_date'];
    batchName = json['batch_name'];
    className = json['class_name'];
    username = json['username'];
    mobile = json['mobile'];
    address = json['address'];
    birth = json['birth'];
    gender = json['gender'];
    fatherHusband = json['father_husband'];
    image = json['image'];
    subjects = json['subjects'];
    experience = json['experience'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_uid'] = this.userUid;
    data['user_id'] = this.userId;
    data['admission_date'] = this.admissionDate;
    data['batch_name'] = this.batchName;
    data['class_name'] = this.className;
    data['username'] = this.username;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['birth'] = this.birth;
    data['gender'] = this.gender;
    data['father_husband'] = this.fatherHusband;
    data['image'] = this.image;
    data['subjects'] = this.subjects;
    data['experience'] = this.experience;
    data['token'] = this.token;
    return data;
  }
}
