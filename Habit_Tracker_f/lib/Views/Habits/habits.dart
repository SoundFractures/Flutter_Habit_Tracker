import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditHabitView(title: "Add Habit")),
            );
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
                      return HabitCard(
                        habit: listOfHabits[index],
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
