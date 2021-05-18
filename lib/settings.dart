import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:tomatotimer/constants.dart';
import 'main.dart';
import 'settingsitem.dart';
import 'methods.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
	static List<TextEditingController> uservalues = [];
	static List<SettingsSwitch> userswitches = [];
	static List<bool> lastNotiSettings;

	@override
  void initState() {
		super.initState();
		KeyboardVisibilityNotification().addNewListener(
			onChange: (bool visible) {
				if (!visible) {
					FocusScope.of(context).unfocus();
				}
			},
		);
	}

	static void resetDefaultSettings(BuildContext context) async {
		MyApp.myConfig.getDefaultUserConfig()
		.then((defaultsettings) {
			uservalues[0].text = defaultsettings[0];
			uservalues[1].text = defaultsettings[1];
			settingsThemeSwitchKey.currentState.setSwitchValue(defaultsettings[2]=="dark");
			print("Reset to default settings succesfully.");
		});
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.myConfig.currentTheme.wallColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Settings'),
        elevation: 10,
				leading: IconButton(
					icon: Icon(Icons.arrow_back, color: Colors.white),
					onPressed: () {
						List<String> _uservalues = [];
						try {
							print('Passing user set value in settings...');
							_uservalues.add(uservalues[0].text);
							_uservalues.add(uservalues[1].text);
							_uservalues.add(settingsThemeSwitchKey.currentState.isSwitched == false ? "light" : "dark");
							if (lastNotiSettings != null && lastNotiSettings.length >= 2) {
								_uservalues.add(lastNotiSettings[0].toString().toLowerCase());
								_uservalues.add(lastNotiSettings[1].toString().toLowerCase());
							}
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
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Dark theme'], iteminput: [userswitches[0]]),
							SettingsItem(itemheight:120, itemcount: 2, itemname: ['Work Interval (min)', 'Rest Interval (min)'], iteminput: [new SettingsValueBox(uservalues[0]), new SettingsValueBox(uservalues[1])]),
							DivideLine(),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Notification'], itemfunction: () => PageManager.openNotificationPage(context)),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['About'], itemfunction: () => PageManager.openAboutPage(context),),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Reset to Default'], itemfunction: () => SettingsPageState.resetDefaultSettings(context),),
							DivideLine(),
						],
					),
				),
			)
    );
  }
}


