// ignore_for_file: prefer_const_constructors

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:student_handbook/shared/styles/colors.dart';
import 'package:student_handbook/shared/utilities.dart';

class NotificationsHandler {
  static void requestPermission(context) {
    debugPrint('jjjjjjjjjjjjjjjjjjjjjjj');
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you a notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Don't Allow",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then(
                      (_) => Navigator.pop(context),
                    ),
                child: Text(
                  'Allow',
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  static Future<void> createNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.time_watch} It is time for your task!!',
        body: 'Check your task now!!',
        notificationLayout: NotificationLayout.Default,
        backgroundColor: Colors.amber,
        color: Appcolors.purple,
      ),
    );
  }

  static Future<void> createScheduleNotification({
    required int date,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          backgroundColor: Colors.amber,
          color: Appcolors.purple,
        ),
        schedule: NotificationCalendar(
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          day: date,
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
        ));
  }
}
