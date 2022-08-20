import 'package:flutter/material.dart';
import 'package:student_handbook/constant.dart';
import 'package:student_handbook/screens/notifications_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backGroundColor;
  const MyAppBar({Key? key, required this.backGroundColor, required this.title})
      : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()));
              },
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
