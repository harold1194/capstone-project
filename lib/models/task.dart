class Task {
  final String uid;
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int reminder;
  final int colorIndex;

  Task({
    required this.uid,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.colorIndex,
  });
}
