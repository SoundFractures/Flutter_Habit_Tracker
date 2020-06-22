class Task {
  final String id;
  final String userId;
  final String habitId;
  final DateTime dateTime;
  final String description;
  final List<String> checklist;

  Task(
      {this.id,
      this.userId,
      this.habitId,
      this.dateTime,
      this.description,
      this.checklist});
}
