import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';

class RequestedSuccessfully extends StatefulWidget {
  final String mMessage;
  final bool error;
  RequestedSuccessfully(this.error, this.mMessage, {Key key}) : super(key: key);
  @override
  _RequestedSuccessfullyState createState() => _RequestedSuccessfullyState();
}

class _RequestedSuccessfullyState extends State<RequestedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.mMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontFamily: SubsetFonts().titleFont),
                ),
              ),
              Container(
                child: !widget.error
                    ? Icon(
                        Icons.check_circle_outline,
                        color: CustomColors.Colors.primaryColor,
                        size: 100.0,
                      )
                    : Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 100.0,
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RaisedButton(
        color: CustomColors.Colors.primaryColor,
        child: Text(
          "CONTINUE",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
