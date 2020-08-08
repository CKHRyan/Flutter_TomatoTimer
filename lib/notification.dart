import 'package:flutter/material.dart';
import 'package:tomatotimer/constants.dart';
import 'package:tomatotimer/settings.dart';
import 'main.dart';
import 'settingsitem.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);
  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
	@override
  void initState() {
		super.initState();
	}
	@override
  Widget build(BuildContext context) {
    return Scaffold(
			backgroundColor: MyApp.myConfig.currentTheme.wallColor,
			appBar: AppBar(
				title: Text('Notification'),
        elevation: 10,
				leading: IconButton(
					icon: Icon(Icons.arrow_back, color: Colors.white),
					onPressed: () {
						List<bool> _uservalues = new List<bool>(2);
						try {
							print('Passing user set value in notification...');
							_uservalues[0]  = settingsNotifySwitchKey.currentState.isSwitched;
							_uservalues[1] = settingsVibrateSwitchKey.currentState.isSwitched;
						}
						on FormatException {
							print('The set value is not a valid integer.');
						}
						catch (e) {
							print(e);
						}
						Navigator.of(context).pop(_uservalues);
					},
				),
			),
			body: SingleChildScrollView(
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						children: <Widget>[
							SizedBox(
								height: 5,
							),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Enable Notification'], iteminput: [SettingsPageState.userswitches[1]]),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Enable Vibration'], iteminput: [SettingsPageState.userswitches[2]]),
							DivideLine(),
						],
					),
				),
			)
		);
	}
}
