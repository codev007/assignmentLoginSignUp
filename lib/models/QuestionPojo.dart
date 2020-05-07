class QuestionPojo {
  String id;
  String question;
  String time;
  String subjectName;
  String image;
  String name;
  String answerCount;
  String likeCount;
  String dislikeCount;

  QuestionPojo(
      {this.id,
      this.question,
      this.time,
      this.subjectName,
      this.image,
      this.name,
      this.answerCount,
      this.likeCount,
      this.dislikeCount});

  QuestionPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    time = json['time'];
    subjectName = json['subject_name'];
    image = json['image'];
    name = json['name'];
    answerCount = json['answer_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['time'] = this.time;
    data['subject_name'] = this.subjectName;
    data['image'] = this.image;
    data['name'] = this.name;
    data['answer_count'] = this.answerCount;
    data['like_count'] = this.likeCount;
    data['dislike_count'] = this.dislikeCount;
    return data;
  }
}