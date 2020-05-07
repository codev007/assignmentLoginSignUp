import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:subset/Admin/sendNotification.dart';
import 'package:subset/KeepNotesFiles/models/note.dart';
import 'package:subset/KeepNotesFiles/services/database.dart';
import 'package:subset/KeepNotesFiles/widgets/main_screen/note_tile.dart';
import 'package:subset/KeepNotesFiles/widgets/note_screen/note_screen.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';

class KeepNotes extends StatefulWidget {
  const KeepNotes({Key key}) : super(key: key);

  @override
  _KeepNotesState createState() => _KeepNotesState();
}

class _KeepNotesState extends State<KeepNotes> {
  String coachingID;

  _userdata() async {
    String cid = await SharedDatabase().getCoachingID();
    setState(() {
      coachingID = cid;
    });
  }

  @override
  void initState() {
    this._userdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          'Notes',
          style: new TextStyle(
              fontFamily: SubsetFonts().toolbarFonts,
              color: CustomColors.Colors.primaryColor),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(
                    FadeRouteBuilder(page: SendNotification(coachingID, 2)));
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: FutureBuilder(
          future: Database.instance.getAllNotes(),
          builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
            if (snapshot.hasData) {
              return StaggeredGridView.countBuilder(
                physics: ScrollPhysics(),
                crossAxisCount: 2,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  child: NoteTile(note: snapshot.data[index]),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NoteScreen(note: snapshot.data[index]),
                      ),
                    );
                  },
                ),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onTap,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: CustomColors.Colors.primaryColor,
          size: 30.0,
        ),
      ),
    );
  }

  _onTap() async {
    final note = await Database.instance.createNote();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteScreen(note: note),
      ),
    );
  }
}
