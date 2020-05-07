import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/ChooseCoaching.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/views/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class CoachingList {
  coachingList(BuildContext context, List<ChooseCoaching> chooseCoaching) {
    _desableTextDesign() {
      return TextStyle(fontSize: 12.0, color: CustomColors.Colors.primaryColor);
    }

    _desableButtonDesign() {
      return BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ));
    }

    return chooseCoaching.length == 0
        ? Center(
            child: Text("Please Apply for admission to continue"),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: chooseCoaching.length,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        chooseCoaching[index].coachingName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: SubsetFonts().titleFont,fontSize: 17.0,color: Colors.black),
                      ),
                      subtitle: Text("ADMISSION DATE : "+
                        chooseCoaching[index].admissionDate,
                        style: new TextStyle(fontSize: 10.0,fontFamily: SubsetFonts().descriptionFont),
                      ),
                      trailing: chooseCoaching[index].status == "1"
                          ? Icon(Icons.keyboard_arrow_right)
                          : Container(
                              padding: EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: _desableButtonDesign(),
                              child: Text(
                                "Pending..",
                                style: _desableTextDesign(),
                              )),
                      onTap: () {
                        if (chooseCoaching[index].status == "1") {
                          SharedDatabase().setCoachingData(
                              chooseCoaching[index].userUid,
                              chooseCoaching[index].userId,
                              chooseCoaching[index].batchId,
                              chooseCoaching[index].admissionDate,
                              chooseCoaching[index].yearId,
                              chooseCoaching[index].userType,
                              chooseCoaching[index].coachingId,
                              chooseCoaching[index].status,
                              chooseCoaching[index].coachingName,
                              chooseCoaching[index].classId);
                          SharedDatabase().setLogin(true);
                          Navigator.of(context)
                              .push(FadeRouteBuilder(page: MainScreen()));
                        }
                      },
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
