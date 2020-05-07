class QuestionDetails {
  List<Files> files;
  int like;
  String name;
  String image;
  String createdAt;
  String subjectName;
  String className;
  String question;
  String token;

  QuestionDetails(
      {this.files,
      this.like,
      this.name,
      this.image,
      this.createdAt,
      this.subjectName,
      this.className,
      this.question,
      this.token});

  QuestionDetails.fromJson(Map<String, dynamic> json) {
    if (json['files'] != null) {
      files = new List<Files>();
      json['files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
    like = json['like'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    subjectName = json['subject_name'];
    className = json['class_name'];
    question = json['question'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    data['like'] = this.like;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['subject_name'] = this.subjectName;
    data['class_name'] = this.className;
    data['question'] = this.question;
    data['token'] = this.token;
    return data;
  }
}

class Files {
  String url;

  Files({this.url});

  Files.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
