class AnswerPojo {
  String id;
  String answer;
  String time;
  String name;
  String image;
  List<Files> files;
  String userID;

  AnswerPojo(
      {this.id, this.answer, this.time, this.name, this.image, this.files,this.userID});

  AnswerPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
    time = json['time'];
    name = json['name'];
    image = json['image'];
    if (json['files'] != null) {
      files = new List<Files>();
      json['files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
    userID = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer'] = this.answer;
    data['time'] = this.time;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    data['user_id'] = this.userID;
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