class CommentPojo {
  String id;
  String comment;
  String time;
  String name;
  String image;
  String userID;

  CommentPojo({this.id, this.comment, this.time, this.name, this.image,this.userID});

  CommentPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    time = json['time'];
    name = json['name'];
    image = json['image'];
    userID = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['time'] = this.time;
    data['name'] = this.name;
    data['image'] = this.image;
    data['user_id'] = this.userID;
    return data;
  }
}