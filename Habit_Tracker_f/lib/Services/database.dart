import 'dart:convert';

import 'package:Habit_Tracker_f/Views/Core/dayInWeek.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
import 'package:Habit_Tracker_f/Models/checkItem.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  //User ID
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference habitCollection =
      Firestore.instance.collection('Habits');
  final CollectionReference taskCollection =
      Firestore.instance.collection('Tasks');

  //Habits
  List<Habit> _habitsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Timestamp t = doc.data['date'];
      DateTime d = t.toDate();
      return Habit(
          id: doc.documentID,
          name: doc.data['name'],
          description: doc.data['description'],
          activeDays: List.from(doc.data['activeDays']),
          progress: doc.data['progress'],
          goal: doc.data['goal'],
          date: d,
          userId: doc.data['user_id']);
    }).toList();
  }

  Stream<List<Habit>> get habits {
    return habitCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_habitsFromSnapshot);
  }

  //Add Habit
  Future addHabit(Habit habit) {
    Firestore.instance.collection('Habits').add({
      'name': habit.name,
      'description': habit.description,
      'userId': uid,
      'activeDays': habit.activeDays,
      'goal': habit.goal,
      'date': habit.date,
      'progress': 0,
    });
    checkHabitsForNewTasks(DateTime.now());
  }

  //Edit Habit
  Future updateHabit(Habit habit) {
    Firestore.instance.collection('Habits').document(habit.id).updateData({
      'name': habit.name,
      'description': habit.description,
    });
  }

  //Remove Habit (Also Removes Tasks)
  Future removeHabit(Habit habit) async {
    Firestore.instance.collection('Habits').document(habit.id).delete();
    await taskCollection
        .where('habitId', isEqualTo: habit.id)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  //Tasks
  List<Task> _tasksFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Timestamp t = doc.data['date'];
      DateTime d = t.toDate();
      return Task(
          id: doc.documentID,
          name: doc.data['name'],
          description: doc.data['description'],
          habitId: doc.data['habitId'],
          userId: doc.data['userId'],
          date: d,
          checklist: List.from(doc.data['checklist']),
          completed: doc.data['completed'],
          edited: doc.data['edited']);
    }).toList();
  }

  Stream<List<Task>> get tasks {
    return taskCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_tasksFromSnapshot);
  }

  // Task Complete
  Future handleTaskCompletion(Task task, bool completed) async {
    await taskCollection.document(task.id).updateData({'completed': completed});
    DocumentSnapshot documentSnapshot =
        await habitCollection.document(task.habitId).get();
    int progress = documentSnapshot.data['progress'];
    completed ? progress = progress + 1 : progress = progress - 1;
    habitCollection.document(task.habitId).updateData({'progress': progress});
  }

  //Check Habits
  Future checkHabitsForNewTasks(DateTime today) async {
    final String day = DateFormat('EEEE').format(today);

    List<Task> listOfTasks = [];
    await taskCollection
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      listOfTasks = _tasksFromSnapshot(snapshot);
    });

    await habitCollection
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      List<Habit> listOfHabits = _habitsFromSnapshot(snapshot);
      print(DayInWeek);
      for (Habit habit in listOfHabits) {
        if (habit.activeDays.contains(day)) {
          if (listOfTasks.length == 0) {
            addTask(habit: habit);
            continue;
          }
          if ((listOfTasks.singleWhere(
                  (task) =>
                      task.habitId == habit.id && task.date.day == today.day,
                  orElse: () => null)) ==
              null) {
            addTask(habit: habit);
          } else {}
        }
      }
    });
  }

  Future checkOverdooTasks(DateTime today) async {
    DateTime todayAtZero =
        DateTime(today.year, today.month, today.day, 0, 0, 0, 0);
    List<Task> listOfTasks = [];
    await taskCollection
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      listOfTasks = _tasksFromSnapshot(snapshot);
    });
    print("Today at ZERO is: " + todayAtZero.toString());
    for (Task task in listOfTasks) {
      if (task.date.isBefore(todayAtZero)) {
        print("OVERDOO Task: " + task.name);
        Firestore.instance.collection('Tasks').document(task.id).delete();
      } else {
        print(task.name + " date is OK");
      }
    }
  }

  Future addTask({Habit habit}) async {
    await Firestore.instance.collection('Tasks').add({
      'userId': uid,
      'habitId': habit.id,
      'date': DateTime.now(),
      'name': habit.name,
      'description': habit.description,
      'checklist': [],
      'notes': "",
      'edited': false,
      'completed': false
    });

    checkHabitsForNewTasks(DateTime.now());
  }

  Future updateTaskChecklist(List<CheckItem> checklist, String taskId) {
    //Map data = {'Banana': {'checked':true,'text'}};
    //taskCollection.document(taskId).updateData({'checklist': data});
  }
}

/*

*/
//Get All habits: 1
//Check if habit has "today" in activeDays: 1
//  Check if habit task is already created && Check if habit date is equal to this date (then don't create task): 0
//

//Check if habit has "tomorrow" in activeDays: 1

//ds.reference.updateData({'iconCode': iconCode});

/*
for (DocumentSnapshot doc in snapshot.documents) {
        Timestamp t = doc.data['date'];
        DateTime d = t.toDate();
        Task task = Task(
            id: doc.documentID,
            name: doc.data['name'],
            description: doc.data['description'],
            habitId: doc.data['habitId'],
            userId: doc.data['userId'],
            date: d,
            checklist: doc.data['checklist'],
            completed: doc.data['completed'],
            edited: doc.data['edited']);
        listOfTasks.add(task);
      }


Future checkForOverdooTasks(DateTime dateTime) {
    print(dateTime);
  }

  Future addTask({Habit habit}) async {
    await Firestore.instance.collection('Tasks').add({
      'userId': uid,
      'habitId': habit.id,
      'date': DateTime.now(),
      'name': habit.name + " #" + (habit.progress + 1).toString(),
      'description': habit.description,
      'checklist': [],
      'edited': false,
      'completed': false
    });
  }

  

  //Edit Task (On TomorrowView)
  Future checkHabits(DateTime today) async {
    checkForOverdooTasks(today.subtract(new Duration(days: 1)));
    //Settings Tomorrow and Today
    String todayDay = DateFormat('EEEE').format(today);
    DateTime tomorrow = today.add(new Duration(days: 1));
    String tomorrowDay =
        DateFormat('EEEE').format(today.add(new Duration(days: 1)));
    //
    //Getting all Tasks
    List<Task> listOfTasks = [];
    await Firestore.instance
        .collection('Tasks')
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      List<Task> listofTasks1 = _tasksFromSnapshot(snapshot);
      print(listofTasks1.length);
    });
    await Firestore.instance
        .collection('Habits')
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      List<Habit> listOfHabits = _habitsFromSnapshot(snapshot);

      for (Habit habit in listOfHabits) {
        if (habit.activeDays.contains(todayDay)) {
          //Check if user-edited task in present for that habit, if not create a default task

        }
        //Create
        else if (habit.activeDays.contains(tomorrowDay)) {
          if (listOfTasks.length == 0) {
            print(habit.name);
            //addTask(habit: habit);
          }
          for (Task task in listOfTasks) {
            if (task.date.day == tomorrow.day && task.habitId == habit.id) {
            } else {
              print(habit.name);
              //addTask(habit: habit);
            }
          }
        }
      }
    });
  }
*/
