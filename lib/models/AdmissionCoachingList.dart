class AdmissionCoachingList {
  String coachingId;
  String coachingName;
  String tagline;
  String address;
  String coachingDescription;
  String registrationNo;
  String logo;
  String image;
  String yearId;

  AdmissionCoachingList(
      {this.coachingId,
        this.coachingName,
        this.tagline,
        this.address,
        this.coachingDescription,
        this.registrationNo,
        this.logo,
        this.image,
        this.yearId});

  AdmissionCoachingList.fromJson(Map<String, dynamic> json) {
    coachingId = json['coaching_id'];
    coachingName = json['coaching_name'];
    tagline = json['tagline'];
    address = json['address'];
    coachingDescription = json['coaching_description'];
    registrationNo = json['registration_no'];
    logo = json['logo'];
    image = json['image'];
    yearId = json['year_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coaching_id'] = this.coachingId;
    data['coaching_name'] = this.coachingName;
    data['tagline'] = this.tagline;
    data['address'] = this.address;
    data['coaching_description'] = this.coachingDescription;
    data['registration_no'] = this.registrationNo;
    data['logo'] = this.logo;
    data['image'] = this.image;
    data['year_id'] = this.yearId;
    return data;
  }
}