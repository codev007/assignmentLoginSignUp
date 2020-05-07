import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class StudentTestSeries {
  studentTestList(BuildContext context) {
    
    _enableButtonDesign() {
      return BoxDecoration(
          color: CustomColors.Colors.primaryColor,
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ));
    }

    _enableTextDesign() {
      return TextStyle(fontSize: 12.0, color: CustomColors.Colors.white);
    }

    _desableTextDesign() {
      return TextStyle(fontSize: 12.0, color: CustomColors.Colors.primaryColor);
    }

    _desableButtonDesign() {
      return BoxDecoration(
          color: Colors.black12,
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Mathematics",
                  style: TextStyle(color: CustomColors.Colors.primaryColor,fontFamily: "RobotoRegular"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "Accounce date : 12/12/2019",
                  style: new TextStyle(fontSize: 12.0),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
                  decoration: _desableButtonDesign(),
                  child: Text(
                    "CLOSED",
                    style: _desableTextDesign(),
                  ),
                ),
              ),
              Container(
                height: 0.3,
                color: Colors.grey,
              )
            ],
          ),
        );
      },
    );
  }
}
