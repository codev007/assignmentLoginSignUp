class AreaPojo {
  int areaId;
  String areaName;

  AreaPojo({this.areaId, this.areaName});

  AreaPojo.fromJson(Map<String, dynamic> json) {
    areaId = json['area_id'];
    areaName = json['area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area_id'] = this.areaId;
    data['area_name'] = this.areaName;
    return data;
  }
}
