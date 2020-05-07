import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:subset/Admin/sendNotification.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';
import 'package:subset/style/style.dart';
import 'package:subset/style/subset_icons.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/ChooseScreen.dart';
import 'package:subset/views/DrawarViews/CoachingDetailsPage.dart';
import 'package:subset/views/StartScreen.dart';
import 'package:subset/views/TeacherViews/classListScreen.dart';
import 'package:subset/views/TeacherViews/subjectListView.dart';
import 'package:subset/views/comman/AdScreen.dart';
import 'package:subset/views/comman/batchList.dart';
import 'package:subset/views/comman/testList.dart';
import 'package:subset/views/student/studentAttendance.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String coachingID;
  String userUID;
  String userType;
  String classID;
  String batchID;
  String userID;
  String dateofbirth;
  String username;
  String doa;
  String school;
  String coachingname;
  String userimage;

  _userdata() async {
    String id = await SharedDatabase().getID();
    String uid = await SharedDatabase().getUID();
    String type = await SharedDatabase().getTypeID();
    String cid = await SharedDatabase().getCoachingID();
    String batchid = await SharedDatabase().getBatchID();
    String classid = await SharedDatabase().getClassID();
    String name = await SharedDatabase().getName();
    String doas = await SharedDatabase().getAdmissionDate();
    String schools = await SharedDatabase().getSchoolSubject();
    String coachingName = await SharedDatabase().getCoachingName();
    String dob = await SharedDatabase().getBirth();
    String img = await SharedDatabase().getImage();

    setState(() {
      userID = id;
      userUID = uid;
      userType = type;
      classID = classid;
      coachingID = cid;
      batchID = batchid;
      username = name;
      doa = doas;
      school = schools;
      coachingname = coachingName;
      dateofbirth = dob;
      userimage = img;
    });
  }

  void _onTapAttendance() {
    //    Navigator.pop(context);
    if (userType == 'T') {
      Navigator.of(context).push(
        FadeRouteBuilder(page: BatchListView(coachingID, 1)),
      );
    } else {
      Navigator.of(context).push(
        FadeRouteBuilder(page: StudentAttendance(userUID)),
      );
    }
  }

  void _onTapSearch() {
    //    Navigator.pop(context);
    Navigator.of(context).push(
      FadeRouteBuilder(page: AdScreenView(true)),
    );
  }

  void _onTapCoachingDetails() {
    //    Navigator.pop(context);

    Navigator.of(context).push(
      FadeRouteBuilder(page: CoachingDetails(coachingID)),
    );
  }

  void _onTapReportCard() {
    if (userType == 'T') {
      Navigator.of(context).push(
        FadeRouteBuilder(page: BatchListView(coachingID, 2)),
      );
    } else {
      Navigator.of(context).push(
        FadeRouteBuilder(page: TextListView(classID, batchID, 2, userUID)),
      );
    }
  }

  void _onTapNotes() {
    if (userType == 'T') {
      Navigator.of(context).push(
        FadeRouteBuilder(page: ClassesListView(coachingID)),
      );
    } else {
      Navigator.of(context).push(
        FadeRouteBuilder(page: SubjectsScreen(classID,coachingID)),
      );
    }
  }

  @override
  void initState() {
    this._userdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(
                    FadeRouteBuilder(page: SendNotification(coachingID, 2)));
              })
        ],
        elevation: 1,
        automaticallyImplyLeading: false,
        //   backgroundColor: CustomColors.Colors.primaryColor,
        title: new Text("Subset",
            style: new TextStyle(
                color: CustomColors.Colors.primaryColor,
                fontFamily: SubsetFonts().toolbarFonts)),
      ),
      body: Container(
        child: _listItemStudent(context),
      ),
    );
  }

  _divider() {
    return Container(
      height: 0.2,
      color: Colors.grey,
    );
  }

  _expandedProfile() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("Current Couching",
                      style: new TextStyle(fontSize: 10.0)),
                ),
                Container(
                  child: Text(coachingname,
                      style: new TextStyle(
                          fontSize: 15.0, fontFamily: SubsetFonts().titleFont)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text("Date of admission",
                      style: new TextStyle(fontSize: 10.0)),
                ),
                Container(
                  child: Text(doa,
                      style: new TextStyle(
                          fontSize: 15.0, fontFamily: SubsetFonts().titleFont)),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            height: 0.3,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: userType == 'T'
                      ? Text("Subjects", style: new TextStyle(fontSize: 10.0))
                      : Text("Current School",
                          style: new TextStyle(fontSize: 10.0)),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(school,
                      style: new TextStyle(
                          fontSize: 15.0, fontFamily: SubsetFonts().titleFont)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _listItemStudent(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Style().spacer(),
          ExpandablePanel(
            header: _header(),
            expanded: _expandedProfile(),
            tapHeaderToExpand: true,
            hasIcon: false,
          ),
          Style().spacer(),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.black54,
            ),
            title: Text('Notes',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: _onTapNotes,
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Subset.my_attendance,
              color: Colors.black54,
            ),
            title: Text('Attendance',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: _onTapAttendance,
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Subset.my_report,
              color: Colors.black54,
            ),
            title: Text('Report Cards',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: _onTapReportCard,
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Subset.my_coaching,
              color: Colors.black54,
            ),
            title: Text('Coaching Details',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: _onTapCoachingDetails,
          ),
          Style().spacer(),
          ListTile(
            leading: Icon(
              Icons.find_in_page,
              color: Colors.black54,
            ),
            title: Text('Find new coaching',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: _onTapSearch,
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Colors.black54,
            ),
            title: Text('Help and Support',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: () {
              _launchURL("https://subset.in/help.html");
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.black54,
            ),
            title: Text('About us',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: () {
              _launchURL("https://subset.in/");
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.black54,
            ),
            title: Text('Rate us',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: () {
              _launchURL(
                  "https://play.google.com/store/apps/details?id=in.subset.subset");
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Icons.compare_arrows,
              color: Colors.black54,
            ),
            title: Text('Switch account',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  FadeRouteBuilder(page: ChooseScreen(userID, userType)));
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
            title: Text('Log out',
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().titleFont)),
            onTap: () async {
              SharedDatabase().userLogout();
              _auth.signOut();
              _firebaseMessaging.unsubscribeFromTopic(coachingID + userType);
              _firebaseMessaging.unsubscribeFromTopic(coachingID);

              if (userType == 'S' || userType == 'P') {
                String batchid = await SharedDatabase().getBatchID();
                String classid = await SharedDatabase().getClassID();
                _firebaseMessaging.unsubscribeFromTopic(batchid);
                _firebaseMessaging.unsubscribeFromTopic(classid);
              }
              Navigator.of(context)
                  .pushReplacement(FadeRouteBuilder(page: StartPage()));
            },
          ),
          Container(
            height: 0.2,
            decoration: BoxDecoration(color: Colors.grey),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: FlatButton(
                    onPressed: () {
                      _launchURL("https://subset.in/privacy_policy.html");
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
                      _launchURL("https://subset.in/terms_and_condition.html");
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
          ),
          Container(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(
                left: 15.0, top: 15.0, bottom: 15.0, right: 5.0),
            width: 55.0,
            height: 55.0,
            decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                image: new NetworkImage(Constants().profileImage + userimage),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
              border: new Border.all(
                color: CustomColors.Colors.primaryColor,
                width: 1.0,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Text(username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: SubsetFonts().titleFont)),
                ),
                Container(
                  child: Text("DATE OF BIRTH : " + dateofbirth,
                      style:
                          new TextStyle(fontSize: 10.0, color: Colors.black45)),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                    top: 3.0,
                  ),
                  child: Text("More details",
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: CustomColors.Colors.primaryColor)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
