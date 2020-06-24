class Habit {
  String id; //From DB
  String userId; //From DB
  String name;
  String description;
  List<String> activeDays;
  int progress; //From DB
  int goal;
  DateTime date;

  Habit({
    this.id,
    this.name,
    this.description,
    this.activeDays,
    this.progress,
    this.goal,
    this.userId,
    this.date,
  });
}
