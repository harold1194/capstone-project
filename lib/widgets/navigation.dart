// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_handbook/constant.dart';
import 'package:student_handbook/screens/dictionary_screen.dart';
import 'package:student_handbook/screens/home_screen.dart';
import 'package:student_handbook/screens/profile_screen.dart';
import 'package:student_handbook/screens/task_screen.dart';

class NavigationForScreen extends StatefulWidget {
  const NavigationForScreen({Key? key}) : super(key: key);

  @override
  State<NavigationForScreen> createState() => _NavigationForScreenState();
}

class _NavigationForScreenState extends State<NavigationForScreen> {
  int selectedIndex = 0;
  static List<Widget> _widgetOption = <Widget>[
    HomeScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
    const DictionaryScreen(),
    const TaskScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_sharp),
                label: 'Dictionary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: selectedIndex,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedItemColor: Colors.white,
            onTap: onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
