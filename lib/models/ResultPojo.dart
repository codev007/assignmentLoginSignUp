class ResultPojo {
  String name;
  String image;
  String testName;
  String createdAt;
  List<Result> result;

  ResultPojo(
      {this.name, this.image, this.testName, this.createdAt, this.result});

  ResultPojo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    testName = json['test_name'];
    createdAt = json['created_at'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['test_name'] = this.testName;
    data['created_at'] = this.createdAt;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String marks;
  String subjectName;
  String total;

  Result({this.marks, this.subjectName,this.total});

  Result.fromJson(Map<String, dynamic> json) {
    marks = json['marks'];
    subjectName = json['subject_name'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marks'] = this.marks;
    data['subject_name'] = this.subjectName;
    data['total'] = this.total;
    return data;
  }
}




