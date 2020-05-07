import 'package:subset/widget/studentWidget/studentTestSeries.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class TestSeries extends StatefulWidget {
  @override
  _TestSeriesState createState() => _TestSeriesState();
}

class _TestSeriesState extends State<TestSeries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Select Exam",
            style: new TextStyle(
                fontFamily: "RobotoRegular",
                color: CustomColors.Colors.primaryColor)),
      ),
      body: StudentTestSeries().studentTestList(context),
    );
  }
}
