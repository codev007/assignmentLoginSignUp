class DistrictPojo {
  int distId;
  String distName;

  DistrictPojo({this.distId, this.distName});

  DistrictPojo.fromJson(Map<String, dynamic> json) {
    distId = json['dist_id'];
    distName = json['dist_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dist_id'] = this.distId;
    data['dist_name'] = this.distName;
    return data;
  }
}