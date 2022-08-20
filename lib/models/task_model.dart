// import 'package:cloud_firestore/cloud_firestore.dart';
// scrap model
class TaskModel {
  final String id;
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int reminder;
  final int colorIndex;

  const TaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.colorIndex,
  });

  factory TaskModel.fromjson(Map<String, dynamic> json, String id) {
    return TaskModel(
      id: id,
      title: json['title'],
      note: json['note'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      reminder: json['reminder'],
      colorIndex: json['colorIndex'],
    );
  }

  // get colorindex => null;
  // static TaskModel fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return TaskModel(
  //     uid: snapshot['uid'],
  //     taskId: snapshot['taskId'],
  //     title: snapshot['title'],
  //     note: snapshot['note'],
  //     date: snapshot['date'],
  //     startTime: snapshot['startTime'],
  //     endTime: snapshot['endTime'],
  //     reminder: snapshot['reminder'],
  //     colorIndex: snapshot['colorIndex'],
  //   );
  // }

  Map<String, dynamic> tojson() => {
        "title": title,
        "note": note,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "reminder": reminder,
        "colorIndex": colorIndex,
      };
}
