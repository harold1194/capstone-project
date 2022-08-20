import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_handbook/services/response.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
String? uid = user?.uid;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference collectionReference =
    firestore.collection('tasks').doc(uid).collection('mytask');

class FirebaseCrud {
  // add task data
  static Future<Response> addTask({
    required String title,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required int reminder,
    required int colorIndex,
  }) async {
    Response response = Response();
    DocumentReference documentReference = collectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "note": note,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "reminder": reminder,
      "colorIndex": colorIndex,
    };

    var result = await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully added";
    }).catchError((e) {
      response.code = 500;
      response.code = e;
    });
    return response;
  }

  // read data
  static Stream<QuerySnapshot> readTask() {
    CollectionReference notesItemCollection = collectionReference;

    return notesItemCollection.snapshots();
  }

  // update task
  static Future<Response> updateTask({
    required String title,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required int reminder,
    required int colorIndex,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReference = collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "note": note,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "reminder": reminder,
      "colorIndex": colorIndex,
    };

    return response;
  }

  // delete data
  static Future<Response> deleteTask({required String docId}) async {
    Response response = Response();
    DocumentReference documentReference = collectionReference.doc(docId);

    await documentReference.delete().whenComplete(() {
      response.code = 200;
      response.message = "Successfully Deleted.";
    });
    return response;
  }
}
