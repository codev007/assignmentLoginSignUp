import 'package:flutter/material.dart';

class StudentAttendancePage {
  studentAttendancePage(BuildContext context) {
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
                  "12/12/2019",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.local_parking,size: 20.0,),
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
