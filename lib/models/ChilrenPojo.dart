class ChilrenPojo {
  String userId;
  String username;
  String birth;
  String image;

  ChilrenPojo({this.userId, this.username, this.birth, this.image});

  ChilrenPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    birth = json['birth'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['birth'] = this.birth;
    data['image'] = this.image;
    return data;
  }
}