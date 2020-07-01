import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Habit_Tracker_f/Models/habit.dart';
import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Models/checkItem.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  //User ID
  final String uid;
  final Task checkTask;
  DatabaseService({this.uid, this.checkTask});

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
          checklist: _checkListFromSnapshot(doc),
          completed: doc.data['completed'],
          edited: doc.data['edited']);
    }).toList();
  }

  //Task Checklist
  List<CheckItem> _checkListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> list = snapshot.data['checklist'];
    if (list == null) {
      return [];
    } else {
      return list.map((item) {
        return CheckItem(text: item['text'], checked: item['checked']);
      }).toList();
    }
  }

  //Update Task
  Future updateTask(String id, String note, List<CheckItem> checklist) async {
    Map<String, dynamic> list;

    list = {'items': checklist.map((e) => e.toJson()).toList()};

    taskCollection.document(id).updateData({'checklist': list['items']});
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
    progress < 0 ? progress = 0 : null;
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

    for (Task task in listOfTasks) {
      if (task.date.isBefore(todayAtZero)) {
        Firestore.instance.collection('Tasks').document(task.id).delete();
      }
    }
  }

  Future addTask({Habit habit}) async {
    await Firestore.instance.collection('Tasks').add({
      'userId': uid,
      'habitId': habit.id,
      'date': DateTime.now(),
      'name': habit.name,
      'checklist': [],
      'notes': "",
      'edited': false,
      'completed': false
    });

    checkHabitsForNewTasks(DateTime.now());
  }
}
