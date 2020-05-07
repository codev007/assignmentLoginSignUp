class NotificationPojo {
  int notificationId;
  String title;
  String description;
  String coachingId;
  String createdAt;

  NotificationPojo(
      {this.notificationId,
      this.title,
      this.description,
      this.coachingId,
      this.createdAt});

  NotificationPojo.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    title = json['title'];
    description = json['description'];
    coachingId = json['coaching_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['coaching_id'] = this.coachingId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
