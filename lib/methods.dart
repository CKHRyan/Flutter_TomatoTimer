import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum direction {
	fromTop,
	fromRight,
	fromBottom,
	fromLeft,
}

class CommonMethod {

	static Route pageBasicRoute(dynamic page) {
		return MaterialPageRoute(builder: (context) => page);
	}

	static Route pageSlideRoute(dynamic page, direction dir) {
		return PageRouteBuilder(
			pageBuilder: (context, animation, secondaryAnimation) => page,
			transitionsBuilder: (context, animation, secondaryAnimation, child) {
				var begin = Offset(0, 0);
				switch(dir) {
					case direction.fromTop:
						begin = Offset(0, -1);
						break;
					case direction.fromRight:
						begin = Offset(1, 0);
						break;
					case direction.fromBottom:
						begin = Offset(0, 1);
						break;
					case direction.fromLeft:
						begin = Offset(-1, 0);
						break;
				}
				var end = Offset.zero;
				var curve = Curves.ease;
				var tween =
						Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
				return SlideTransition(
					position: animation.drive(tween),
					child: child,
				);
			},
		);
	}
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class LocalNotification {

	final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
			FlutterLocalNotificationsPlugin();

	NotificationAppLaunchDetails notificationAppLaunchDetails;

	final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
			BehaviorSubject<ReceivedNotification>();

	final BehaviorSubject<String> selectNotificationSubject =
			BehaviorSubject<String>();

	LocalNotification() {
		setupNotification();
	}	

	Future<void> setupNotification() async {
		WidgetsFlutterBinding.ensureInitialized();
		notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
		var initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
		// Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
		// of the `IOSFlutterLocalNotificationsPlugin` class
		var initializationSettingsIOS = IOSInitializationSettings(
				requestAlertPermission: false,
				requestBadgePermission: false,
				requestSoundPermission: false,
				onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
					didReceiveLocalNotificationSubject.add(ReceivedNotification(
							id: id, title: title, body: body, payload: payload));
				});
		var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
		await flutterLocalNotificationsPlugin.initialize(initializationSettings,
		onSelectNotification: (String payload) async {
			if (payload != null) {
				debugPrint('notification payload: ' + payload);
			}
			selectNotificationSubject.add(payload);
		});
	}

	Future<void> sendNotification(String action, message) async {
	var androidPlatformChannelSpecifics = AndroidNotificationDetails(
			'com.rchungkh.tomatotimer', 'Tomato Timer', 'Notification for time alarm.',
			importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
	var iOSPlatformChannelSpecifics = IOSNotificationDetails();
	var platformChannelSpecifics = NotificationDetails(
			androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
	await flutterLocalNotificationsPlugin.show(
			0, action, message, platformChannelSpecifics,
			payload: 'item x');
}

	Future<void> cancelNotification() async {
		await flutterLocalNotificationsPlugin.cancelAll();
	}
}