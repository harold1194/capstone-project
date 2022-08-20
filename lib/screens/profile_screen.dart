// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_handbook/auth/sign_in_screen.dart';
import 'package:student_handbook/constant.dart';
import 'package:student_handbook/models/auth_methods.dart';
import 'package:student_handbook/utils.dart';
import 'package:student_handbook/widgets/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool isLoading = false;

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
            appBar: MyAppBar(backGroundColor: kPrimaryColor, title: 'Profile'),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: kTextLightColor,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                        radius: 50,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['bio'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 0,
                  child: ListTile(
                    title: Text(
                      'Themes',
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: ListTile(
                    title: InkWell(
                      onTap: () async {
                        await AuthMethods().signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Out',
                      ),
                    ),
                    trailing: Icon(Icons.logout_rounded),
                  ),
                ),
              ],
            ),
          );
  }
}
