// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manage_budget/data.dart';



FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

NotificationDetails notifyDeats;
IOSNotificationDetails _iosNoteDetails;
AndroidNotificationDetails _andNoteDetails;
InitializationSettings _initializationSettings;
AndroidInitializationSettings _androidInitializationSettings;
IOSInitializationSettings _iosInitializationSettings;

int _notificationCounter = 1;

void notifyInit(){
  _iosNoteDetails = IOSNotificationDetails();
  _andNoteDetails = AndroidNotificationDetails("id", "name", "description");
  _androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  _iosInitializationSettings = IOSInitializationSettings();
  notifyDeats = NotificationDetails(_andNoteDetails, _iosNoteDetails);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  _initializationSettings = InitializationSettings(_androidInitializationSettings, _iosInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(_initializationSettings);
}

void approachingLimitNotify(String key, int value){
  String title = "Approaching ";
  title += key;
  title +=" Budget Limit";
  String body = "You have reached ";
  body += value.toString();
  body += "% of your \$";
  body += budgetsMax[key].toStringAsFixed(2);
  body += " budget for ";
  body += key;
  flutterLocalNotificationsPlugin.show(_notificationCounter, title, body, notifyDeats);
  _notificationCounter++;
}