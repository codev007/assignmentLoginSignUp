import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:subset/Admin/Pending.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/style/string.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/validation/formValidation.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class RegisterCoaching extends StatefulWidget {
  final String contact;
  final String stateID;
  final String distID;
  final String areaID;

  RegisterCoaching(this.contact, this.stateID, this.distID, this.areaID,
      {Key key})
      : super(key: key);
  @override
  _RegisterCoachingState createState() => _RegisterCoachingState();
}

class _RegisterCoachingState extends State<RegisterCoaching> {
  bool isLoading = false;
  var uuid = new Uuid();
  GlobalKey<FormState> _applyFormKey = new GlobalKey();
  TextEditingController name = new TextEditingController();
  TextEditingController tagline = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController coaching_description = new TextEditingController();
  TextEditingController registration_no = new TextEditingController();
  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: Text("Register ",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
      ),
      body: isLoading
          ? Center(
              child: SpinKitDoubleBounce(
              color: CustomColors.Colors.primaryColor,
            ))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Form(
                  key: _applyFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          StringData().registrationNote,
                          style: new TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontFamily: "RobotoRegular"),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        child: TextFormField(
                          autofocus: false,
                          obscureText: false,
                          validator: Validate().validateStringText,
                          controller: name,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Institute Name',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        child: TextFormField(
                          autofocus: false,
                          validator: Validate().validateStringText,
                          obscureText: false,
                          controller: tagline,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Institute Tagline',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        child: TextFormField(
                          validator: Validate().validateStringText,
                          autofocus: false,
                          obscureText: false,
                          controller: address,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Institute Address',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        child: TextFormField(
                          autofocus: false,
                          validator: Validate().validateStringText,
                          obscureText: false,
                          controller: email,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Institute E-mail',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        child: TextFormField(
                          validator: Validate().validateStringText,
                          autofocus: false,
                          obscureText: false,
                          controller: coaching_description,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Institute Description',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        child: TextFormField(
                          validator: Validate().validateStringText,
                          autofocus: false,
                          obscureText: false,
                          controller: registration_no,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Number of students',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Date of Establishment  : ",
                              style: TextStyle(fontFamily: "RobotoMedium"),
                            ),
                            Expanded(
                                child: Text(
                                    "${myFormat.format(selectedDate.toLocal())}")),
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
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 15.0, bottom: 40.0),
                        child: RaisedButton(
                          color: CustomColors.Colors.primaryColor,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (_applyFormKey.currentState.validate()) {
                              _registerationRequest(
                                name.text,
                                tagline.text,
                                address.text,
                                email.text,
                                widget.contact,
                                coaching_description.text,
                                registration_no.text,
                                '${myFormat.format(selectedDate.toLocal())}',
                              );
                            } else {}
                          },
                          child: Text(
                            "APPY NOW FOR SUBSET",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _registerationRequest(
      String name,
      String tagline,
      String address,
      String email,
      String contact,
      String description,
      String registrationNo,
      String estd) async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    String url = Constants().coachingapply;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "coaching_id": uuid.v1(),
      "coaching_name": name,
      "tagline": tagline,
      "address": address,
      "email": email,
      "contact": contact,
      "coaching_description": description,
      "registration_no": registrationNo,
      "establishmentat": estd,
      "location_id": widget.stateID + widget.distID + widget.areaID
    };
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);

    Navigator.of(context).pushReplacement(FadeRouteBuilder(
        page: PendingScreen(body['message'])));

    setState(() {
      isLoading = false;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2500));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
