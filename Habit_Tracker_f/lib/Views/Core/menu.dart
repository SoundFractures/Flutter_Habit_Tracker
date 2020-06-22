import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:Habit_Tracker_f/Views/Habits/habits.dart';
import 'package:Habit_Tracker_f/Views/Today/today.dart';
import 'package:Habit_Tracker_f/Views/Tomorrow/tomorrow.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int bottomSelectedIndex = 1;

  List<Widget> buildBottomNavBarItems() {
    return [
      Icon(
        Icons.home,
        size: 20,
        color: Colors.white,
      ),
      Icon(
        Icons.search,
        size: 20,
        color: Colors.white,
      ),
      Icon(
        Icons.info,
        size: 20,
        color: Colors.white,
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HabitsView(),
        TodayView(),
        TomorrowView(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        color: Colors.blue,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        height: 50,
        items: buildBottomNavBarItems(),
        animationDuration: Duration(milliseconds: 150),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          debugPrint("Current Index:" + index.toString());
          bottomTapped(index);
        },
      ),
    );
  }
}
