class CoachingCommentsPojo {
  String comment;
  String createdAt;
  String username;
  String image;
  int coachingCommentsId;

  CoachingCommentsPojo(
      {this.comment,
      this.createdAt,
      this.username,
      this.image,
      this.coachingCommentsId});

  CoachingCommentsPojo.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    createdAt = json['created_at'];
    username = json['username'];
    image = json['image'];
    coachingCommentsId = json['coaching_comments_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['username'] = this.username;
    data['image'] = this.image;
    data['coaching_comments_id'] = this.coachingCommentsId;
    return data;
  }
}
