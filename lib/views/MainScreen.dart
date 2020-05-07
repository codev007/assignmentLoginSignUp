import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/views/bottomPages/KeepNotes.dart';
import 'package:subset/views/bottomPages/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'bottomPages/DoubtScreen.dart';
import 'bottomPages/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String coachingID;
  final List<Widget> bootmbarPages = [
    HomeScreen(
      key: PageStorageKey('Page1'),
    ),
    DoubtSreen(
      key: PageStorageKey('Page2'),
    ),
    KeepNotes(
      key: PageStorageKey('Page3'),
    ),
    ProfileScreen(
      key: PageStorageKey('Page4'),
    ),
  ];

  String userType;
  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColors.Colors.white,
        selectedItemColor: CustomColors.Colors.primaryColor,
        unselectedItemColor: Colors.black45,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        elevation: 16.0,
        iconSize: 25.0,
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer), title: Text('Doubt')),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note), title: Text('Notes')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('Profile')),
        ],
      );

  _type() async {
    String type = await SharedDatabase().getTypeID();
    String cid = await SharedDatabase().getCoachingID();
    String year = await SharedDatabase().getYearID();

    setState(() {
      userType = type;
      coachingID = cid;
    });
    _firebaseMessaging.subscribeToTopic(cid+year+ userType);
    _firebaseMessaging.subscribeToTopic(cid+year);
    _firebaseMessaging.subscribeToTopic(cid);
    _firebaseMessaging.subscribeToTopic(cid+userType);

    if (userType == 'S' || userType == 'P') {
      String batchid = await SharedDatabase().getBatchID();
      String classid = await SharedDatabase().getClassID();
      _firebaseMessaging.subscribeToTopic(batchid + year);
      _firebaseMessaging.subscribeToTopic(classid);
    }
  }

  @override
  void initState() {
    super.initState();
    this._type();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        appBar: null,
        bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
        body: IndexedStack(
          index: _selectedIndex,
          children: bootmbarPages,
        ),
      ),
    );
  }
}
