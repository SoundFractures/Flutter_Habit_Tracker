import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Models/user.dart';

class TomorrowView extends StatefulWidget {
  @override
  _TomorrowViewState createState() => _TomorrowViewState();
}

class _TomorrowViewState extends State<TomorrowView> {
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
                backgroundColor: Colors.red,
                expandedHeight: 150.0,
                actions: <Widget>[],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Tomorrow",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500)),
                  collapseMode: CollapseMode.parallax,
                )),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 3.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container();
                },
                childCount: 10,
              ),
            ),
          ],
        ));
  }
}
