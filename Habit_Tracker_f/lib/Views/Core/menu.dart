import 'package:Habit_Tracker_f/Views/Profile/profile.dart';
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
  int bottomSelectedIndex = 0;
  Color bottomSelectedColor = Colors.green;
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        title: Text("Habits"),
        icon: Icon(
          Icons.home,
        ),
      ),
      BottomNavigationBarItem(
        title: Text("Today"),
        icon: Icon(
          Icons.check_box,
        ),
      ),
      BottomNavigationBarItem(
        title: Text("Tomorrow"),
        icon: Icon(
          Icons.schedule,
        ),
      ),
      BottomNavigationBarItem(
        title: Text("Profile"),
        icon: Icon(
          Icons.account_circle,
        ),
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
        ProfileView()
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
      if (index == 0) {
        bottomSelectedColor = Colors.green;
      } else if (index == 1) {
        bottomSelectedColor = Colors.blue;
      } else if (index == 2) {
        bottomSelectedColor = Colors.red;
      } else if (index == 3) {
        bottomSelectedColor = Colors.yellow;
      }
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomSelectedIndex,
        selectedItemColor: bottomSelectedColor,
        //color: Colors.blue,
        backgroundColor: Colors.white,
        //buttonBackgroundColor: Colors.blue,
        //height: 50,
        items: buildBottomNavBarItems(),
        //animationDuration: Duration(milliseconds: 100),
        //animationCurve: Curves.bounceInOut,
        onTap: (index) {
          debugPrint("Current Index:" + index.toString());
          bottomTapped(index);
        },
      ),
    );
  }
}
