import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
import 'package:Habit_Tracker_f/Views/Core/dayInWeek.dart';

class AddHabitView extends StatefulWidget {
  final String title;

  const AddHabitView({Key key, this.title}) : super(key: key);

  @override
  _AddHabitViewState createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
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
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Navigator.pop(context);
            if (_controllerDesc.text.isNotEmpty &&
                _controllerName.text.isNotEmpty &&
                activeDays.length != 0) {
              Habit endHabit = Habit();

              endHabit.name = _controllerName.text;
              endHabit.description = _controllerDesc.text;
              endHabit.activeDays = activeDays;
              endHabit.goal = goal;
              endHabit.date = DateTime.now();

              DatabaseService(uid: user.uid).addHabit(endHabit);
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
                        "Select Reacurrance: ",
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
                            onTap: () {
                              setState(() {
                                daysInWeek[day.index].checked =
                                    !daysInWeek[day.index].checked;

                                if (daysInWeek[day.index].checked) {
                                  activeDays.add(day.name);
                                } else {
                                  activeDays.remove(day.name);
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Container(
                                width: width * 0.11,
                                height: width * 0.11,
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: daysInWeek[day.index].checked
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
                                        color: daysInWeek[day.index].checked
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
                        height: 20.0,
                      ),
                      Text(
                        "Select amount of Days: ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: NumberPicker.integer(
                            decoration: new BoxDecoration(
                              border: new Border(
                                top: new BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black26,
                                ),
                                bottom: new BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                            initialValue: goal,
                            minValue: 0,
                            maxValue: 100,
                            highlightSelectedValue: false,
                            onChanged: (value) {
                              setState(() {
                                goal = value;
                              });
                            }),
                      )
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
