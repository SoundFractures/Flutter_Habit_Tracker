import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:flutter/material.dart';
import 'package:Habit_Tracker_f/Views/Core/dayInWeek.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  const HabitCard({Key key, this.habit}) : super(key: key);

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  List<DayInWeek> daysInWeek = [
    DayInWeek(0, "M", "Monday", false),
    DayInWeek(1, "T", "Tuesday", false),
    DayInWeek(2, "W", "Wednesday", false),
    DayInWeek(3, "T", "Thursday", false),
    DayInWeek(4, "F", "Friday", false),
    DayInWeek(5, "S", "Saturday", false),
    DayInWeek(6, "S", "Sunday", false)
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
      decoration: BoxDecoration(
          border: Border.all(width: 0.03, color: Colors.grey[700])),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: width * 0.036,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.habit.name,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.028),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: daysInWeek.map((day) {
                  return Padding(
                    padding: EdgeInsets.all(.5),
                    child: Container(
                      width: width * 0.06,
                      height: width * 0.06,
                      child: Container(
                        decoration: new BoxDecoration(
                            color: widget.habit.activeDays
                                    .contains(daysInWeek[day.index].name)
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.green, width: width * 0.005),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Center(
                            child: Text(
                          daysInWeek[day.index].letter,
                          style: TextStyle(
                              color: widget.habit.activeDays
                                      .contains(daysInWeek[day.index].name)
                                  ? Colors.white
                                  : Colors.grey[500],
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          SizedBox(
            height: width * 0.018,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.habit.description,
                    style: TextStyle(
                        color: Colors.grey[400], fontSize: height * 0.022),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: width * 0.016,
          ),
          LinearProgressIndicator(
            value: ((widget.habit.progress * 100) / widget.habit.goal) / 100,
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation(
              Colors.green,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (((widget.habit.progress * 100) / widget.habit.goal)
                                .round())
                            .toString() +
                        "%",
                    style: TextStyle(
                        color: Colors.grey[400], fontSize: height * 0.022),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (widget.habit.progress).toString() +
                        " / " +
                        widget.habit.goal.toString() +
                        " Tasks",
                    style: TextStyle(
                        color: Colors.grey[400], fontSize: height * 0.022),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: width * 0.036,
          ),
        ],
      ),
    );
  }
}
