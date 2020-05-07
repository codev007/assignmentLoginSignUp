class CoachingInfoPojo {
  String coachingId;
  String coachingName;
  String tagline;
  String address;
  String email;
  String contact;
  String coachingDescription;
  String achievements;
  String establishmentat;
  String logo;
  String image;
  int scount;
  int tcount;
  List<Staff> staff;

  CoachingInfoPojo(
      {this.coachingId,
        this.coachingName,
        this.tagline,
        this.address,
        this.email,
        this.contact,
        this.coachingDescription,
        this.achievements,
        this.establishmentat,
        this.logo,
        this.image,
        this.scount,
        this.tcount,
        this.staff});

  CoachingInfoPojo.fromJson(Map<String, dynamic> json) {
    coachingId = json['coaching_id'];
    coachingName = json['coaching_name'];
    tagline = json['tagline'];
    address = json['address'];
    email = json['email'];
    contact = json['contact'];
    coachingDescription = json['coaching_description'];
    achievements = json['achievements'];
    establishmentat = json['establishmentat'];
    logo = json['logo'];
    image = json['image'];
    scount = json['scount'];
    tcount = json['tcount'];
    if (json['staff'] != null) {
      staff = new List<Staff>();
      json['staff'].forEach((v) {
        staff.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coaching_id'] = this.coachingId;
    data['coaching_name'] = this.coachingName;
    data['tagline'] = this.tagline;
    data['address'] = this.address;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['coaching_description'] = this.coachingDescription;
    data['achievements'] = this.achievements;
    data['establishmentat'] = this.establishmentat;
    data['logo'] = this.logo;
    data['image'] = this.image;
    data['scount'] = this.scount;
    data['tcount'] = this.tcount;
    if (this.staff != null) {
      data['staff'] = this.staff.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  String username;
  String image;
  String subjects;
  String experience;

  Staff({this.username, this.image, this.subjects, this.experience});

  Staff.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    image = json['image'];
    subjects = json['subjects'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['image'] = this.image;
    data['subjects'] = this.subjects;
    data['experience'] = this.experience;
    return data;
  }
}