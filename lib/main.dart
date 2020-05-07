import 'package:subset/views/FlashScreen.dart';
import 'package:subset/views/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'KeepNotesFiles/services/database.dart';

/// App entry point
void main() async {
  // then render the app on screen
  runApp(MyApp());
  // wait for the database to initialize
  await Database.instance.init();
}

final routes = {
  '/home': (BuildContext context) => new MainScreen(),
  '/': (BuildContext context) => new FlashScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //    routes: routes,
      routes: routes,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: CustomColors.Colors.white,
        accentColor: CustomColors.Colors.primaryColor,
        primaryColorDark: CustomColors.Colors.primaryColor,
        primaryIconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: CustomColors.Colors.primaryColor),
      ),
    );
  }
}

/*
Keep pace with digital transition otherwise you will be replaced by someone who will.
ALTER TABLE `result_table` ADD `total` VARCHAR(5) NOT NULL AFTER `marks`; 
*/
