class NoticeDetails {
  List<Files> files;
  String title;
  String description;
  String createdAt;
  String batchName;
  String name;
  String image;
  String type;
  int like;
  String token;

  NoticeDetails(
      {this.files,
      this.title,
      this.description,
      this.createdAt,
      this.batchName,
      this.name,
      this.image,
      this.type,
      this.like,
      this.token});

  NoticeDetails.fromJson(Map<String, dynamic> json) {
    if (json['files'] != null) {
      files = new List<Files>();
      json['files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    batchName = json['batch_name'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    like = json['like'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['batch_name'] = this.batchName;
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    data['like'] = this.like;
    data['token'] = this.token;
    return data;
  }
}

class Files {
  String url;
  String type;

  Files({this.url, this.type});

  Files.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}
