// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
NotificationDetails notifyDeats;
IOSNotificationDetails _iosNoteDetails;
AndroidNotificationDetails _andNoteDetails;
InitializationSettings _initializationSettings;
AndroidInitializationSettings _androidInitializationSettings;
IOSInitializationSettings _iosInitializationSettings;

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