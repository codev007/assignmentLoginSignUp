class AttendanceBatchPojo {
  int batchId;
  String batchName;
  String className;
  int classId;
  bool value;

  AttendanceBatchPojo(
      {this.batchId, this.batchName, this.className, this.classId, this.value});

  AttendanceBatchPojo.fromJson(Map<String, dynamic> json) {
    batchId = json['batch_id'];
    batchName = json['batch_name'];
    className = json['class_name'];
    classId = json['class_id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batch_id'] = this.batchId;
    data['batch_name'] = this.batchName;
    data['class_name'] = this.className;
    data['class_id'] = this.classId;
    data['value'] = this.value;
    return data;
  }
}