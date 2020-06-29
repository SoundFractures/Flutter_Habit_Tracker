import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
import 'package:Habit_Tracker_f/Views/Core/dayInWeek.dart';

class EditHabitView extends StatefulWidget {
  final String title;
  final Habit habit;
  const EditHabitView({Key key, this.title, this.habit}) : super(key: key);

  @override
  _EditHabitViewState createState() => _EditHabitViewState();
}

class _EditHabitViewState extends State<EditHabitView> {
  List<DayInWeek> daysInWeek = [
    DayInWeek(0, "M", "Monday", false),
    DayInWeek(1, "T", "Tuesday", false),
    DayInWeek(2, "W", "Wednesday", false),
    DayInWeek(3, "T", "Thursday", false),
    DayInWeek(4, "F", "Friday", false),
    DayInWeek(5, "S", "Saturday", false),
    DayInWeek(6, "S", "Sunday", false)
  ];

  List<String> activeDays = [];

  int progress = 0;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();
  int goal = 10;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _controllerName.text = widget.habit.name;
      _controllerDesc.text = widget.habit.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_controllerDesc.text.isNotEmpty &&
                _controllerName.text.isNotEmpty) {
              widget.habit.name = _controllerName.text;
              widget.habit.description = _controllerDesc.text;

              DatabaseService(uid: user.uid).updateHabit(widget.habit);
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.green,
        ),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: width * 1,
                  padding: EdgeInsets.all(width * 0.055),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _controllerName,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: Colors.green,
                              maxLength: 20,
                              style: TextStyle(
                                  fontSize: width * 0.05, color: Colors.black),
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Give your habit a name',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _controllerDesc,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: Colors.green,
                              maxLength: 40,
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 5,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Describe your habit',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Reacurrance: ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: daysInWeek.map((day) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Container(
                                width: width * 0.11,
                                height: width * 0.11,
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: widget.habit.activeDays.contains(
                                              daysInWeek[day.index].name)
                                          ? Colors.green
                                          : Colors.white,
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: Colors.green,
                                          width: width * 0.005),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Center(
                                      child: Text(
                                    daysInWeek[day.index].letter,
                                    style: TextStyle(
                                        color: widget.habit.activeDays.contains(
                                                daysInWeek[day.index].name)
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: width * 0.066,
                      ),
                      LinearProgressIndicator(
                        value: ((widget.habit.progress * 100) /
                                widget.habit.goal) /
                            100,
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
                                (((widget.habit.progress * 100) /
                                                widget.habit.goal)
                                            .round())
                                        .toString() +
                                    "%",
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: height * 0.022),
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
                                    color: Colors.grey[400],
                                    fontSize: height * 0.022),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
