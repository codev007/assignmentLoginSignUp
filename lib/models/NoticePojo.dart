class NoticePojo {
  String title;
  String description;
  String time;
  String id;
  String name;
  String image;
  String type;
  String token;
  String commentCount;
  String likeCount;
  String dislikeCount;

  NoticePojo(
      {this.title,
      this.description,
      this.time,
      this.id,
      this.name,
      this.image,
      this.type,
      this.token,
      this.commentCount,
      this.likeCount,
      this.dislikeCount});

  NoticePojo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    time = json['time'];
    id = json['id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    token = json['token'];
    commentCount = json['comment_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['time'] = this.time;
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    data['token'] = this.token;
    data['comment_count'] = this.commentCount;
    data['like_count'] = this.likeCount;
    data['dislike_count'] = this.dislikeCount;
    return data;
  }
}