import 'package:Habit_Tracker_f/Views/Auth/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Views/Core/menu.dart';
import 'package:flutter/services.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Menu(
        context: context,
      );
    }
  }
}
