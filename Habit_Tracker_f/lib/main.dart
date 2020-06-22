import 'package:flutter/material.dart';
import 'package:Habit_Tracker_f/Services/auth.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
import 'package:Habit_Tracker_f/Views/wrapper.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user, child: MaterialApp(home: Wrapper()));
  }
}
