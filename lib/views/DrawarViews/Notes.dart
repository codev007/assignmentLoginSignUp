import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/NotesPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/helperViews/ImageHelper.dart';
import 'package:subset/widget/ExtraWidgets/pdfViewer.dart';

class CoachingNotes extends StatefulWidget {
  final String classID;
  final String subjectID;
  final String coachingID;
  CoachingNotes(this.classID, this.subjectID, this.coachingID, {Key key})
      : super(key: key);

  @override
  _CoachingNotesState createState() => _CoachingNotesState();
}

class _CoachingNotesState extends State<CoachingNotes> {
  bool isLoading = true;
  bool isFound = false;
  var notesList = List<NotesPojo>();
  String userType;
  TextEditingController _notesTitle = new TextEditingController();
  Map<String, String> _paths;
  List<File> images = [];
  List<String> file = [];
  String _extension = "pdf";
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = true;
  FileType _pickingType = FileType.CUSTOM;
  String _fileName;
  String _path = null;
  bool isSubmitting = false;
  bool isActive = false;

  _data() async {
    String type = await SharedDatabase().getTypeID();
    setState(() {
      userType = type;
    });
    this.getNotesFromApi();
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
              fontFamily: SubsetFonts().toolbarFonts,
              color: CustomColors.Colors.primaryColor),
        ),
        actions: <Widget>[
          userType == "T"
              ? IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: CustomColors.Colors.primaryColor,
                  ),
                  onPressed: () {
                    _uploadNotesBottomSheet(context);
                  })
              : Container()
        ],
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isFound
                ? Center(
                    child: Text(
                      "Notes not added yet ! Please contact to teacher"
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            notesList[index].title,
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          subtitle: Text(
                            notesList[index].createdAt,
                            style: TextStyle(
                                fontFamily: SubsetFonts().descriptionFont),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                                  FadeRouteBuilder(page: PdfViewerScreen(notesList[index].pdfUrl)));
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      notesList.clear();
    });
    this.getNotesFromApi();
  }

  getNotesFromApi() async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
      "class_id": widget.classID,
      "subject_id": widget.subjectID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchNotes,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        notesList = (json.decode(response.body) as List)
            .map((data) => new NotesPojo.fromJson(data))
            .toList();
        if (notesList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  uploadNotes(String title, String file) async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
      "class_id": widget.classID,
      "subject_id": widget.subjectID,
      "title": title,
      "file": file
    };

    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().uploadNotes,
        headers: headers, body: json.encode(jsondat));
    print(response.toString());

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: body['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
      if (!body['error']) {
        this._refresh();
      }
      setState(() {

        isSubmitting = false;
        isActive = false;
        _notesTitle.clear();

      });
    }
  }

  _uploadNotesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (contex) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStates) {
            //-----OPEN FILE EXPLORER-----------------------------
            void _openFileExplorer() async {
              if (_pickingType != FileType.CUSTOM || _hasValidMime) {
                setStates(() {
                  _loadingPath = true;
                });
                try {
                  if (_multiPick) {
                    _path = null;
                    _paths = await FilePicker.getMultiFilePath(
                        type: _pickingType, fileExtension: _extension);
                  } else {
                    _paths = null;
                    _path = await FilePicker.getFilePath(
                        type: _pickingType, fileExtension: _extension);
                  }
                } on Exception catch (e) {
                  // print("Unsupported operation" + e.toString());
                }
                if (!mounted) return;
                setStates(() {
                  _loadingPath = false;
                  _fileName = _path != null
                      ? _path.split('/').last
                      : _paths != null ? _paths.keys.toString() : '...';
                });
              }
            }

            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  padding: EdgeInsets.all(5.0),
                                  onPressed: () {
                                    setStates(() {
                                      _paths = null;
                                      _path = null;
                                      images.clear();
                                      _notesTitle.clear();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(""),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: 10.0, top: 5.0, bottom: 5.0),
                                child: isSubmitting
                                    ? Container(
                                        child: SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: Center(
                                            child:
                                                new CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : isActive
                                        ? FlatButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              if (_path != null) {
                                                setStates(() {
                                                  isSubmitting = true;
                                                });
                                                List<int> imageBytesorg =
                                                    File(_path)
                                                        .readAsBytesSync();
                                                String imageorg =
                                                    base64Encode(imageBytesorg);
                                                uploadNotes(
                                                    _notesTitle.text, imageorg);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Notes file not attached",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIos: 1);
                                              }
                                            },
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            //          alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            //            width: MediaQuery.of(context).size.width,
                                            child: Text(
                                              "submit notes".toUpperCase(),
                                              style: new TextStyle(
                                                  color: CustomColors
                                                      .Colors.primaryColor,
                                                  fontSize: 12.0),
                                            ),
                                          )
                                        : Text(""),
                              )
                            ],
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: CustomColors.Colors.primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.0),
                                topRight: Radius.circular(19.0)),
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          "Please add your imaportant notes here for students.",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontFamily: SubsetFonts().titleFont),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                        ),
                        child: TextField(
                          minLines: 1,
                          maxLines: 10,
                          autofocus: false,
                          obscureText: false,
                          controller: _notesTitle,
                          onChanged: (String value) {
                            if (value.length > 0) {
                              setStates(() {
                                isActive = true;
                              });
                            } else {
                              setStates(() {
                                isActive = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Write your notes title here',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Attach Notes PDF file",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 17.0,
                                        fontFamily: SubsetFonts().titleFont),
                                  )),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: IconButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    _openFileExplorer();
                                  },
                                  padding: EdgeInsets.all(10),
                                  icon: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.black54,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      /*  Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 100.0,
                        child: new Builder(
                          builder: (BuildContext context) => _loadingPath
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: const CircularProgressIndicator())
                              : _path != null || _paths != null
                                  ? new Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      //        height: MediaQuery.of(context).size.height * 0.50,
                                      child: new Scrollbar(
                                          child: new ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _paths != null && _paths.isNotEmpty
                                                ? _paths.length
                                                : 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final bool isMultiPath =
                                              _paths != null &&
                                                  _paths.isNotEmpty;
                                          final String name = 'File $index: ' +
                                              (isMultiPath
                                                  ? _paths.keys.toList()[index]
                                                  : _fileName ?? '...');
                                          final path = isMultiPath
                                              ? _paths.values
                                                  .toList()[index]
                                                  .toString()
                                              : _path;
                                          print(path);
                                          images.add(File(_path));
                                          return new ListTile(
                                            title: Text(name),
                                            subtitle: Text(path),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                new Divider(),
                                      )),
                                    )
                                  : new Container(),
                        ),
                      ),*/
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: _path != null
                            ? Text(_path)
                            : Text("Notes not attached yet"),
                      )
                    ],
                  ),
                )));
          },
        );
      },
    );
  }
}
