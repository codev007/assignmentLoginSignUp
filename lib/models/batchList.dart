class BatchList {
  int batchId;
  String batchName;
  String className;
  int classId;

  BatchList({this.batchId, this.batchName, this.className, this.classId});

  BatchList.fromJson(Map<String, dynamic> json) {
    batchId = json['batch_id'];
    batchName = json['batch_name'];
    className = json['class_name'];
    classId = json['class_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batch_id'] = this.batchId;
    data['batch_name'] = this.batchName;
    data['class_name'] = this.className;
    data['class_id'] = this.classId;
    return data;
  }
}