import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({Key key, this.task}) : super(key: key);
  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10),
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
                    widget.task.name,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.03),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: width * 0.016,
          ),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation(
              Colors.green,
            ),
          ),
          SizedBox(
            height: width * 0.036,
          ),
        ],
      ),
    );
  }
}

/*
Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (((widget.task.progress * 100) / widget.task.goal).round())
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
                    (widget.task.progress).toString() +
                        " / " +
                        widget.task.goal.toString() +
                        " Tasks",
                    style: TextStyle(
                        color: Colors.grey[400], fontSize: height * 0.022),
                  ),
                ],
              ),
            ],
          ),
*/
