import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:subset/Admin/Pending.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/comman/state.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/ChooseScreen.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/views/ProfileEdit.dart';
import 'package:subset/views/helperViews/successful.dart';
import 'package:subset/widget/parents/ChildrenList.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  final String userType;
  LoginScreen(this.userType, {Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumber = new TextEditingController();
  bool isLoading = false;
  String statusMessage = "";
  String _smsCode;
  bool isVerifing = false;
  String dialogSms = "Please check your phone for the verification code.";
  String verifyStatus = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  bool isSending = false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {}
      _auth.signOut();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1,
        title: Text("Verify",
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
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: Text(
                        "Subset will send you an OTP after you enter your phone number. OTP is only valide for 15 sec. Please do not use (+91) as it is by default.",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                            fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(0.0),
                      margin:
                          EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                      child: TextField(
                        cursorColor: CustomColors.Colors.primaryColor,
                        maxLength: 10,
                        autofocus: true,
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        onChanged: (String value) {
                          setState(() {
                            verifyStatus = "";
                          });
                        },
                        decoration: new InputDecoration(
                            hintText: "  Mobile Number",
                            icon: Icon(
                              Icons.keyboard,
                              color: CustomColors.Colors.primaryColor,
                            )),
                      ),
                    ),
                    isSending
                        ? Container(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0),
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              child: Text(
                                "VERIFY MOBILE NUMBER",
                                style: new TextStyle(
                                    color: CustomColors.Colors.white),
                              ),
                              color: CustomColors.Colors.primaryColor,
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  isSending = true;
                                });

                                _verifyPhoneNumber();
                              },
                            ),
                          ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0),
                      child: Text(
                        verifyStatus,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: FlatButton(
                              onPressed: () {
                                _launchURL(
                                    "https://subset.in/privacy_policy.html");
                              },
                              child: Text(
                                "Privacy policy",
                                style: new TextStyle(
                                    color: CustomColors.Colors.primaryColor,
                                    fontFamily: SubsetFonts().linkFonts),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: FlatButton(
                              onPressed: () async {
                                _launchURL(
                                    "https://subset.in/terms_and_condition.html");
                              },
                              child: Text(
                                "Terms of service",
                                style: new TextStyle(
                                    color: CustomColors.Colors.primaryColor,
                                    fontFamily: SubsetFonts().linkFonts),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  userLogin(String mobileNumber, String userRole) async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    String url = Constants().login;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "mobile_number": mobileNumber,
      "userType": userRole
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
    }
    if (body['error']) {
      Navigator.of(context).pushReplacement(FadeRouteBuilder(
          page: ProfileEditPage(widget.userType, mobileNumber)));
    }

    setState(() {
      isLoading = false;
    });
  }

  adminLogin(String mobileNumber) async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    String url = Constants().adminLogin;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "mobile_number": mobileNumber,
    };
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      if (body['is_active'] == 1) {
        String msg = "You are registered as a subset admin";
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: PendingScreen(msg)));
      } else {
        String msg = "Your request is painding . Please wait...";
        Navigator.of(context)
            .pushReplacement(FadeRouteBuilder(page: PendingScreen(msg)));
      }
    }
    if (body['error']) {
      Navigator.of(context).push(FadeRouteBuilder(
          page: StateListScreen(mobileNumber, widget.userType, mobileNumber)));
    }

    setState(() {
      isLoading = false;
    });
  }

  smsCodeDialog(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  tooltip: "Close",
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setBottomState(() {
                                      isVerifing = false;
                                      dialogSms =
                                          "Please check your phone for the verification code.";
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: CustomColors.Colors.primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.0),
                                topRight: Radius.circular(19.0)),
                          )),
                      isVerifing
                          ? Container(
                              margin: EdgeInsets.all(50.0),
                              child: Center(child: CircularProgressIndicator()))
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Text(
                                      dialogSms.toUpperCase(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                    ),
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 1,
                                      autofocus: false,
                                      maxLength: 6,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        if (value.length > 0) {
                                          setBottomState(() {
                                            this._smsCode = value;
                                          });
                                        } else {}
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Enter 6 digit OTP',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 2.0, 20.0, 2.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    child: RaisedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

                                        setBottomState(() {
                                          isVerifing = true;
                                        });
                                        FirebaseAuth.instance
                                            .currentUser()
                                            .then((user) {
                                          if (user != null) {
                                            Navigator.of(context).pop();
                                            if (widget.userType == "A") {
                                              adminLogin(
                                                  "+91" + phoneNumber.text);
                                            } else if (widget.userType == "P") {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      FadeRouteBuilder(
                                                          page: ChildrenListScreen(
                                                              widget.userType,
                                                              "+91" +
                                                                  phoneNumber
                                                                      .text)));
                                            } else {
                                              userLogin(
                                                  "+91" + phoneNumber.text,
                                                  widget.userType);
                                            }
                                          } else {
                                            _signInWithPhoneNumber();
                                          }
                                        });
                                      },
                                      color: CustomColors.Colors.primaryColor,
                                      child: Text(
                                        "SUBMIT OTP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user; // ...
      final FirebaseUser currentUser = await _auth.currentUser();
      if (user.uid == currentUser.uid) {
        assert(user.uid == currentUser.uid);
        setState(() {
          if (user != null) {
            Navigator.of(context).pop();
            if (widget.userType == "A") {
              adminLogin("+91" + phoneNumber.text);
            } else if (widget.userType == "P") {
              Navigator.of(context).pushReplacement(FadeRouteBuilder(
                  page: ChildrenListScreen(
                      widget.userType, "+91" + phoneNumber.text)));
            } else{
              userLogin("+91" + phoneNumber.text, widget.userType);
            }
          } else {
            setState(() {
              this.verifyStatus = "Invailed OTP";
              isVerifing = false;
            });
          }
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        this.verifyStatus = "Invalid OTP";
        isVerifing = false;
      });
    }
  }

  //  code of  verify phone number
  void _verifyPhoneNumber() async {
    setState(() {});
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        //     _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        isSending = false;
        this.verifyStatus = "invalide phone number";
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        isSending = false;
        smsCodeDialog(context);
        //   _message = "Please check your phone for the verification code.";
      });
      /*    widget._scaffold.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));
      */
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNumber.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
