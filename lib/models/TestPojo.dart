class TestPojo {
  int testId;
  String testName;
  String createdAt;

  TestPojo({this.testId, this.testName, this.createdAt});

  TestPojo.fromJson(Map<String, dynamic> json) {
    testId = json['test_id'];
    testName = json['test_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['test_id'] = this.testId;
    data['test_name'] = this.testName;
    data['created_at'] = this.createdAt;
    return data;
  }
}
