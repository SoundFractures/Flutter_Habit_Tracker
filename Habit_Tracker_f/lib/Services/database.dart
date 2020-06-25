import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
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
  }

  //Edit Habit
  Future updateHabit(Habit habit) {
    Firestore.instance.collection('Habits').document(habit.id).updateData({
      'name': habit.name,
      'description': habit.description,
    });
  }

  //Remove Habit (Also Removes Tasks)
  Future removeHabit(Habit habit) {
    print(habit.id);
    Firestore.instance.collection('Habits').document(habit.id).delete();
  }

  //Tasks
  //Check if any tasks are overdoo
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
          checklist: doc.data['checklist'],
          completed: doc.data['completed'],
          edited: doc.data['edited']);
    }).toList();
  }

  Stream<List<Task>> get tasks {
    return taskCollection
        .where('user_id', isEqualTo: uid)
        .snapshots()
        .map(_tasksFromSnapshot);
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
}

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
*/
