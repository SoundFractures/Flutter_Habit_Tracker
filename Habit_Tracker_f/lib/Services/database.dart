import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Models/user.dart';

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

  //Remove Habit (Also Removes Tasks)

  //Get All Habits

  //Tasks

  //Edit Task (On TomorrowView)

  //Generate Adding Task
}
