import 'package:flutter/material.dart';
import 'package:subset/style/string.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:url_launcher/url_launcher.dart';

class PendingScreen extends StatefulWidget {
  final String message;
  PendingScreen(this.message, {Key key}) : super(key: key);
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: Row(
          children: <Widget>[
            
            
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "CANCEL",
                style: TextStyle(color: Colors.white),
              ),
              color: CustomColors.Colors.primaryColor,
            ),
Spacer(),
RaisedButton(
              onPressed: () {
                _launchURL(
                    "https://play.google.com/store/apps/details?id=in.subset.subset_main");
              },
              child: Text(
                "DOWNLOAD NOW",
                style: TextStyle(color: Colors.white),
              ),
              color: CustomColors.Colors.primaryColor,
            ),
          ],
        ),
      ),
      appBar: new AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Image.asset("assets/icons/pending.png"),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20.0, bottom: 5.0),
              child: Text(
                widget.message.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              alignment: Alignment.center,
              child: Text(
                StringData().adminMessage.toUpperCase(),
                style: TextStyle(color: Colors.blue,fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
