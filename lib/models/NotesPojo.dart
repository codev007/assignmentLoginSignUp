class NotesPojo {
  int notesId;
  String title;
  String pdfUrl;
  String createdAt;

  NotesPojo({this.notesId, this.title, this.pdfUrl, this.createdAt});

  NotesPojo.fromJson(Map<String, dynamic> json) {
    notesId = json['notes_id'];
    title = json['title'];
    pdfUrl = json['pdf_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes_id'] = this.notesId;
    data['title'] = this.title;
    data['pdf_url'] = this.pdfUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}