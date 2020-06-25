import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
import 'package:Habit_Tracker_f/Views/Habits/addHabit.dart';
import 'package:Habit_Tracker_f/Views/Habits/editHabit.dart';
import 'package:Habit_Tracker_f/Views/Habits/habitCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Models/user.dart';

class HabitsView extends StatefulWidget {
  @override
  _HabitsViewState createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  List<Habit> listOfHabits;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DatabaseService(uid: user.uid).checkHabits(DateTime.now());
            /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHabitView(title: "Add Habit")),
            );*/
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                backgroundColor: Colors.green,
                expandedHeight: 150.0,
                actions: <Widget>[],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Habits",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500)),
                  collapseMode: CollapseMode.parallax,
                )),
            StreamBuilder<List<Habit>>(
                stream: DatabaseService(uid: user.uid).habits,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listOfHabits = snapshot.data;
                    return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      return InkWell(
                        onLongPress: () async {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.050)),
                                  title: Text(
                                    "Delete ${listOfHabits[index].name}?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "This will delete ...",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Cancel",
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        DatabaseService(uid: user.uid)
                                            .removeHabit(listOfHabits[index]);
                                        Navigator.of(context).pop();
                                        setState(() {
                                          listOfHabits.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditHabitView(
                                      title: listOfHabits[index].name,
                                      habit: listOfHabits[index],
                                    )),
                          );
                        },
                        child: HabitCard(
                          habit: listOfHabits[index],
                        ),
                      );
                    }, childCount: listOfHabits.length));
                  } else {
                    print(snapshot);
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                              height: 50,
                              color: Colors.teal[100 * (index % 9)]);
                        },
                        childCount: 50,
                      ),
                    );
                  }
                })
          ],
        ));
  }
}
