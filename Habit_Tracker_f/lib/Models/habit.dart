class Habit {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String recurrence;
  final String progress;

  Habit(
      {this.id,
      this.name,
      this.description,
      this.recurrence,
      this.progress,
      this.userId});
}
