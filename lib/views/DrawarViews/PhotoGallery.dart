import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class PhotoGallery extends StatefulWidget {
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Photo Corner",
            style: new TextStyle(
                fontFamily: "RobotoRegular",
                color: CustomColors.Colors.primaryColor)),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
                          child: CircleAvatar(
                            backgroundColor: CustomColors.Colors.primaryColor,
                            child: new Text("A"),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: Text(
                                "Deoraj Poudyal",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    fontFamily: "RobotoRegular",
                                    color: CustomColors.Colors.primaryColor,
                                    fontSize: 17.0),
                              ),
                            ),
                            Container(
                              child: Text(
                                "1 month ago.",
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                    child: Text(
                      "Now that you have a Drawer in place, add content to it. For this example, use a ListView.",
                      style: TextStyle(color: Colors.black54, fontSize: 15.0),
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Image.network(
                            "https://www.journal-news.com/rf/image_lowres/Pub/p10/JournalNews/2019/02/21/Images/newsEngin.23827897_hjn082709firsthamiltonp3.jpg"),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.thumb_up,
                            color: Colors.grey,
                          ),
                        ),
                        Text("1.5k", style: TextStyle(color: Colors.grey)),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.thumb_down,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "11",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Spacer(),
                        Text(
                          "50",
                          style: TextStyle(color: Colors.grey),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.comment,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
