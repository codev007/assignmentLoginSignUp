import 'package:flutter/material.dart';

class AlerDialogs {
  profileAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            content: Container(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Outdoors-man-portrait_%28cropped%29.jpg/220px-Outdoors-man-portrait_%28cropped%29.jpg"),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  alignment: Alignment.topLeft,
                                  child: Text('Deepak Patidar zfxgh cjfxz',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: new TextStyle(fontSize: 15.0)),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  alignment: Alignment.topLeft,
                                  child: Text("DOB : 12/12/2050",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black54)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("Current Couching",
                                style: new TextStyle(fontSize: 10.0)),
                          ),
                          Container(
                            child: Text("Gyan Coaching Classes",
                                style: new TextStyle(fontSize: 15.0)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text("Date of admission",
                                style: new TextStyle(fontSize: 10.0)),
                          ),
                          Container(
                            child: Text("11/08/2019",
                                style: new TextStyle(fontSize: 15.0)),
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
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("Current School",
                                style: new TextStyle(fontSize: 10.0)),
                          ),
                          Container(
                            child: Text("Gyan Public School",
                                style: new TextStyle(fontSize: 15.0)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.3,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Privacy policy",
                              style: new TextStyle(
                                  color: Colors.blue, fontSize: 10.0),
                            ),
                          ),
                          Spacer(),
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Terms & condition",
                              style: new TextStyle(
                                  color: Colors.blue, fontSize: 10.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        });
  }
}
