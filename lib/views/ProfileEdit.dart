import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/ChooseScreen.dart';
import 'package:subset/views/helperViews/ImageHelper.dart';
import 'package:uuid/uuid.dart';

enum SingingCharacter { M, F, O, N }

class ProfileEditPage extends StatefulWidget {
  final String userType;
  final String mobileNumber;
  ProfileEditPage(this.userType, this.mobileNumber, {Key key})
      : super(key: key);
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  DateTime selectedDate = DateTime.now();
  var myFormat = DateFormat('dd-MM-yyyy');
  var uuid = Uuid();
  bool isLoading = false;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  //------------COMMAN FIELDS IN TECHER AND STUDENT-----------------
  String userImage = "";
  File _logoFile;
  String userID = "";
  String token = "";
  String birth = "";
  String statusMessage = "";
  bool validateError = false;
  SingingCharacter _character = SingingCharacter.N;
  int _radioValue = 1;
  String gender = "N";
  //-----------STUDENT TEXT EDITTING CONTROLLER-----------------------------------
  String _username;
  String _address;
  String _father_name;
  String _school_name;
  String _parents_mobile;
  //-----------TEACHER TEXT EDITTING CONTROLLER-----------------------------------
  String _father_husband;
  String _subjects;
  String _experience;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      _logoFile = selected;
    });
  }

  _mainScreen() {
    if (identical(widget.userType, "S")) {
      return _profileStudent();
    } else if (identical(widget.userType, "T")) {
      return _profileTeacher();
    }
  }

  getToken() async {
    String token_temp = await firebaseMessaging.getToken();
    setState(() {
      token = token_temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 1,
          title: Text("Complete Profile",style: TextStyle(fontFamily: SubsetFonts().toolbarFonts),),
        ),
        body: isLoading
            ? Center(
                child: SpinKitRing(
                size: MediaQuery.of(context).size.width / 2,
                color: CustomColors.Colors.primaryColor,
              ))
            : _mainScreen());
  }

  Widget _profileStudent() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //------PROFILE IMAGE---------------
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50.0,
                  backgroundImage: _logoFile == null
                      ? AssetImage('assets/icons/default.png')
                      : FileImage(_logoFile),
                  child: InkWell(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Icon(
                        Icons.camera_alt,
                        size: 30.0,
                        color: Colors.black87,
                      ))),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  setState(() {
                    this._username = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Student Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    "Date of birth  : ",
                    style: TextStyle(fontFamily: "RobotoMedium"),
                  ),
                  Text("${myFormat.format(selectedDate.toLocal())}"),
                  SizedBox(
                    height: 20.0,
                  ),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.date_range),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  setState(() {
                    this._address = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Student Address',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 1.0),
              child: Text("Gender"),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: _selectGender(),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  setState(() {
                    this._father_name = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Father Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  setState(() {
                    this._parents_mobile = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Father Mobile Number',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  setState(() {
                    this._school_name = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'School Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              child: validateError
                  ? Text(
                      statusMessage,
                      style: TextStyle(color: Colors.red, fontSize: 17.0),
                    )
                  : Text(
                      statusMessage,
                      style: TextStyle(fontSize: 15.0),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                color: CustomColors.Colors.primaryColor,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  if (identical(gender, "N")) {
                    setState(() {
                      statusMessage = 'Please Select Gender';
                    });
                  } else {
                    if (_logoFile != null) {
                      List<int> imageBytesorg = await ImageHelper()
                          .compressImage(_logoFile.readAsBytesSync());
                      userImage = base64Encode(imageBytesorg);
                      if (userImage == "") {
                        setState(() {
                          statusMessage =
                              'Please add profile image to continue';
                        });
                      } else {
                        if (this._username.isNotEmpty &&
                            this._address.isNotEmpty &&
                            this._father_name.isNotEmpty &&
                            this._school_name.isNotEmpty &&
                            this._parents_mobile.isNotEmpty) {
                          this.uploadStudentProfile(
                              uuid.v1().toString(),
                              this._username,
                              widget.mobileNumber,
                              this._address,
                              "${myFormat.format(selectedDate.toLocal())}",
                              gender,
                              this._father_name,
                              userImage,
                              this._school_name,
                              "+91" + this._parents_mobile,
                              token);
                        } else {
                          setState(() {
                            this.validateError = true;
                            this.statusMessage = "Fields are missing !";
                          });
                        }
                      }
                    } else {
                      setState(() {
                        statusMessage =
                            'Please add profile image is null to continue';
                      });
                    }
                  }
                },
                child: Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _profileTeacher() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //------PROFILE IMAGE---------------
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50.0,
                  backgroundImage: _logoFile == null
                      ? AssetImage('assets/icons/default.png')
                      : FileImage(_logoFile),
                  child: InkWell(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Icon(
                        Icons.camera_alt,
                        size: 30.0,
                        color: Colors.black87,
                      ))),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  this._username = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Teacher Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    "Date of birth  : ",
                    style: TextStyle(fontFamily: "RobotoMedium"),
                  ),
                  Text("${myFormat.format(selectedDate.toLocal())}"),
                  SizedBox(
                    height: 20.0,
                  ),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.date_range),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text("Gender"),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: _selectGender(),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  this._address = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Address',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  this._father_husband = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Father or Husband Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  this._subjects = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Subject specialization',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: TextField(
                autofocus: false,
                obscureText: false,
                onChanged: (String value) {
                  this._experience = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Write your work experience',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              child: validateError
                  ? Text(
                      statusMessage,
                      style: TextStyle(color: Colors.red, fontSize: 17.0),
                    )
                  : Text(
                      statusMessage,
                      style: TextStyle(fontSize: 15.0),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                color: CustomColors.Colors.primaryColor,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (identical(gender, "N")) {
                    setState(() {
                      statusMessage = 'Please Select Gender';
                    });
                  } else {
                    List<int> imageBytesorg = await ImageHelper()
                          .compressImage(_logoFile.readAsBytesSync());
                    userImage = base64Encode(imageBytesorg);
                    if (userImage == "") {
                      setState(() {
                        statusMessage = 'Please add profile image to continue';
                      });
                    } else {
                      if (this._username.isNotEmpty &&
                          this._address.isNotEmpty &&
                          this._father_husband.isNotEmpty &&
                          this._subjects.isNotEmpty &&
                          this._experience.isNotEmpty) {
                        uploadTeacherProfile(
                            uuid.v1(),
                            _username,
                            widget.mobileNumber,
                            _address,
                            "${myFormat.format(selectedDate.toLocal())}",
                            gender,
                            _father_husband,
                            userImage,
                            _subjects,
                            _experience,
                            token);
                      } else {
                        setState(() {
                          this.validateError = true;
                          this.statusMessage = "Fields are missing";
                        });
                      }
                    }
                  }
                },
                child: Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadStudentProfile(
      String user_id,
      String username,
      String mobile,
      String address,
      String birth,
      String gender,
      String father_name,
      String image,
      String school_name,
      String parents_mobile,
      String token) async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    String url = Constants().studentProfileUpload;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "user_id": user_id,
      "username": username,
      "mobile": mobile,
      "address": address,
      "birth": birth,
      "gender": gender,
      "father_name": father_name,
      "school_name": school_name,
      "parents_mobile": parents_mobile,
      "token": token,
      "image": image
    };
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      SharedDatabase().setVerified(true);
      SharedDatabase().setLogin(false);
      SharedDatabase().isVerifiedData(body['user_id'], widget.userType);
      Navigator.of(context).pushReplacement(FadeRouteBuilder(
          page: ChooseScreen(body['user_id'], widget.userType)));
    } else {
      setState(() {
        statusMessage = body['message'];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  uploadTeacherProfile(
      String user_id,
      String username,
      String mobile,
      String address,
      String birth,
      String gender,
      String father_husband,
      String image,
      String subjects,
      String experience,
      String token) async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    String url = Constants().teacherProfileUpload;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "user_id": user_id,
      "username": username,
      "mobile": mobile,
      "address": address,
      "birth": birth,
      "gender": gender,
      "father_husband": father_husband,
      "subjects": subjects,
      "experience": experience,
      "token": token,
      "image": image
    };
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      SharedDatabase().setVerified(true);
      SharedDatabase().setLogin(false);
      SharedDatabase().isVerifiedData(body['user_id'], widget.userType);
      Navigator.of(context).pushReplacement(FadeRouteBuilder(
          page: ChooseScreen(body['user_id'], widget.userType)));
    } else {
      setState(() {
        statusMessage = body['message'];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  _selectGender() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Radio(
          value: SingingCharacter.M,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value;
              gender = "M";
            });
          },
        ),
        new Text(
          'Male',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: SingingCharacter.F,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value;
              gender = "F";
            });
          },
        ),
        new Text(
          'Female',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        new Radio(
          value: SingingCharacter.O,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value;
              gender = "O";
            });
          },
        ),
        new Text(
          'Other',
          style: new TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
