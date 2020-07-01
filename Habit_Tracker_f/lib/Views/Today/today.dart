import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
import 'package:Habit_Tracker_f/Views/Today/editTask.dart';
import 'package:Habit_Tracker_f/Views/Today/taskCard.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Models/user.dart';

class TodayView extends StatefulWidget {
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  List<Task> listOfTasks = [];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 150.0,
                backgroundColor: Colors.green,
                actions: <Widget>[],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Tasks Today",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500)),
                  collapseMode: CollapseMode.parallax,
                )),
            StreamBuilder<List<Task>>(
                stream: DatabaseService(uid: user.uid).tasks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listOfTasks = snapshot.data;
                    return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      return InkWell(
                        onTap: () {
                          listOfTasks[index].completed == false
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTaskView(
                                            title: listOfTasks[index].name,
                                            task: listOfTasks[index],
                                          )),
                                )
                              : null;
                        },
                        child: TaskCardView(task: listOfTasks[index]),
                      );
                    }, childCount: listOfTasks.length));
                  } else {
                    print(snapshot);
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                              height: 50,
                              color: Colors.teal[100 * (index % 9)]);
                        },
                        childCount: 1,
                      ),
                    );
                  }
                })
          ],
        ));
  }
}
