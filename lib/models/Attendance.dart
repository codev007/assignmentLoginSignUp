class AttendancePojo {
  String username;
  String userUid;
  String fatherName;
  String value;

  AttendancePojo({this.username, this.userUid, this.fatherName, this.value});

  AttendancePojo.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userUid = json['user_uid'];
    fatherName = json['father_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['user_uid'] = this.userUid;
    data['father_name'] = this.fatherName;
    data['value'] = this.value;
    return data;
  }
}
