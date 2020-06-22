import 'package:flutter/material.dart';

class TodayView extends StatefulWidget {
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Text("Today"),
    );
  }
}
