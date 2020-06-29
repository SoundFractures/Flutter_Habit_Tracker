import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
import 'package:flutter/material.dart';

class TaskCardView extends StatefulWidget {
  final Task task;
  const TaskCardView({Key key, this.task}) : super(key: key);
  @override
  _TaskCardViewState createState() => _TaskCardViewState();
}

class _TaskCardViewState extends State<TaskCardView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
      decoration: BoxDecoration(
          border: Border.all(width: 0.03, color: Colors.grey[700])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: width * 0.036,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.task.name,
                    style: TextStyle(
                        color: widget.task.completed
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        fontSize: height * 0.027),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.036,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  DatabaseService().handleTaskCompletion(
                      widget.task, !widget.task.completed);
                },
                child: widget.task.completed
                    ? Icon(
                        Icons.check_box,
                        color: Colors.grey[300],
                        size: width * 0.08,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey[600],
                        size: width * 0.08,
                      ),
              ),
            ],
          )
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
