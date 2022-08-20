// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_handbook/constant.dart';
import 'package:student_handbook/utils.dart';
import 'package:student_handbook/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userData = {};
  bool isLoading = false;
  final TextEditingController _usercontroller = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  @override
  void dispose() {
    super.dispose();
    _usercontroller.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: MyAppBar(backGroundColor: kPrimaryColor, title: "Home"),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' Welcome ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      userData['username'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Table of Contents',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ),
                _buildPartone(context),
                _buildPartwo(context),
                _buildParthree(context),
                _buildPartfour(context),
                _buildPartfive(context),
                _buildPartsix(context),
              ],
            ),
          );
  }

  ListTile _buildPartone(BuildContext context) {
    return ListTile(
      title: Text('Part 1: About CARD-MRI Development Institute, INC'),
      leading: Image.asset(
        'assets/icons/parchment.png',
        scale: 15,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
    );
  }

  ListTile _buildPartwo(BuildContext context) {
    return ListTile(
      title:
          Text('Part 2: School General Information, Policies, and Guidelines'),
      leading: Image.asset(
        'assets/icons/search.png',
        scale: 15,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
    );
  }

  ListTile _buildParthree(BuildContext context) {
    return ListTile(
      title: Text('Part 3: Academic Policies'),
      leading: Image.asset(
        'assets/icons/policy.png',
        scale: 15,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
    );
  }

  ListTile _buildPartfour(BuildContext context) {
    return ListTile(
      title: Text('Part 4: Student Affairs & Services'),
      leading: Image.asset(
        'assets/icons/schedule.png',
        scale: 15,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
    );
  }

  ListTile _buildPartfive(BuildContext context) {
    return ListTile(
      title: Text('Part 5: Student Regulations & Services'),
      leading: Image.asset(
        'assets/icons/regulations-book.png',
        scale: 15,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
    );
  }

  ListTile _buildPartsix(BuildContext context) {
    return ListTile(
      title: Text('Part 6: Appendices'),
      leading: Image.asset(
        'assets/icons/attached.png',
        scale: 15,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
    );
  }
}
