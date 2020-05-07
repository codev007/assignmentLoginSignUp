import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/helperViews/ImageHelper.dart';
import 'package:subset/views/helperViews/nointernet.dart';

class UpdateCoaching extends StatefulWidget {
  final String coachingID;
  final int typeID;
  UpdateCoaching(this.coachingID, this.typeID, {Key key}) : super(key: key);
  @override
  _UpdateCoachingState createState() => _UpdateCoachingState();
}

class _UpdateCoachingState extends State<UpdateCoaching> {
  File _image;
  bool isLoading = false;
  TextEditingController _acievement = new TextEditingController();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Update",
          style: TextStyle(fontFamily: SubsetFonts().toolbarFonts),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : widget.typeID == 3
              ? Container(
                  margin: EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: _acievement,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Write Acievements',
                                fillColor: Colors.black12),
                            //      style: Theme.of(context).textTheme.subhead,
                            autofocus: true,
                            maxLines: 10,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                            color: CustomColors.Colors.primaryColor,
                            onPressed: () {
                              if (_acievement.text.length > 0) {
                                updateCoaching(_acievement.text);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Text",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1);
                              }
                            },
                            child: Text(
                              "UPDATE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
              : Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          onPressed: () {
                            getImage();
                          },
                          child: widget.typeID == 1
                              ? Text("CHOOSE LOGO IMAGE")
                              : Text("CHOOSE IMAGE"),
                        ),
                      ),
                      _image == null
                          ? Text('No image selected.')
                          : Container(
                              decoration: BoxDecoration(color: Colors.grey),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.file(_image),
                                ),
                              ),
                            ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                          color: CustomColors.Colors.primaryColor,
                          onPressed: () async {
                            if (_image != null) {
                              String imageorg = await compressImages(_image);
                              updateCoaching(imageorg);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please Select Image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1);
                            }
                          },
                          child: Text(
                            "UPDATE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Future<String> compressImages(File _file) async {
    List<int> imageBytesorg =
        await ImageHelper().compressImage(_file.readAsBytesSync());
    String imageorg = base64Encode(imageBytesorg);
    
    return imageorg;
  }

  updateCoaching(String data) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> jsondat = {
      "type": widget.typeID,
      "data": data,
      "coaching_id": widget.coachingID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      final response = await http.post(Constants().updateCoaching,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (!body['error']) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: body['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1);
        }
      }
    } on SocketException {
      Navigator.of(context).push(FadeRouteBuilder(page: NoInternetScreen()));
    }
    setState(() {
      isLoading = false;
    });
  }
}
