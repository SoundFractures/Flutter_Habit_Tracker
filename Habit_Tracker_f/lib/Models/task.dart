import 'package:Habit_Tracker_f/Models/checkItem.dart';

class Task {
  String id;
  String userId;
  String habitId;
  DateTime date;
  String name;
  String description;
  List<CheckItem> checklist;
  bool edited;
  bool completed;

  Task(
      {this.id,
      this.userId,
      this.name,
      this.habitId,
      this.date,
      this.description,
      this.edited,
      this.completed,
      this.checklist});
}
