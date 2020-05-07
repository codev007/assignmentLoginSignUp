import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subset/KeepNotesFiles/models/note.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';

/// A widget which displays the note as an expandable tile
class NoteTile extends StatelessWidget {
  /// The note to display
  final Note note;

  /// Constructs a new NoteTile
  const NoteTile({@required this.note, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (note.title.isNotEmpty)
              Text(
                note.title,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black,fontFamily: SubsetFonts().titleFont,fontSize: 17.0),
              ),
            if (note.title.isNotEmpty && note.contents.isNotEmpty) Divider(),
            if (note.contents.isNotEmpty)
              Text(
                note.contents,
                style: TextStyle(color: Colors.black45,fontSize: 15.0,fontFamily: SubsetFonts().descriptionFont),
              ),
          ],
        ),
      ),
    );
  }
}
