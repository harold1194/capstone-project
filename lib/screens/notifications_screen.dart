import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_handbook/constant.dart';
import 'package:student_handbook/data/firestore_crud.dart';
import 'package:student_handbook/widgets/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? uid;

  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readTask();

  Future<void> getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const MyAppBar(backGroundColor: kPrimaryColor, title: 'Notification'),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            _nodatawidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                      child: Column(children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_on_rounded),
                      title: Text(e["title"]),
                      subtitle: Container(
                        child: (Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Note: " + e['note'],
                                style: const TextStyle(fontSize: 14)),
                            Text("Date: " + e['date'],
                                style: const TextStyle(fontSize: 12)),
                          ],
                        )),
                      ),
                    ),
                  ]));
                }).toList(),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _nodatawidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/clipboard.png',
            height: 299,
          ),
          SizedBox(height: 3),
          Text(
            'There is no task',
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 45),
          ),
        ],
      ),
    );
  }
}
