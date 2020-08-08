import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'main.dart';
import 'settingsitem.dart';
import "about.dart";
import 'methods.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
	static List<TextEditingController> uservalues = new List<TextEditingController>();

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

	static void resetDefaultSettings() async {
		MyApp.myConfig.getDefaultUserConfig()
		.then((defaultsettings) {
			uservalues[0].text = defaultsettings[0];
			uservalues[1].text = defaultsettings[1];
			SettingsSwitch.changeSwitchVal.value = defaultsettings[2] == "dark";
			print("Reset to default settings succesfully.");
		});
	}

	static void openAboutPage(BuildContext context) async {
		Navigator.push(
			context,
			CommonMethod.pageBasicRoute(AboutPage())
		);
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.myConfig.currentTheme.wallColor,
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 10,
				leading: IconButton(
					icon: Icon(Icons.arrow_back, color: Colors.white),
					onPressed: () {
						List<int> _uservalues = new List<int>(3);
						try {
							print('Passing user set value in settings...');
							_uservalues[0]  = int.parse(uservalues[0].text);
							_uservalues[1] = int.parse(uservalues[1].text);
							_uservalues[2] = SettingsSwitchState.isSwitched == false ? 0 : 1;
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
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Dark theme'], iteminput: [SettingsSwitch()]),
							SettingsItem(itemheight:120, itemcount: 2, itemname: ['Work Interval (min)', 'Rest Interval (min)'], iteminput: [SettingsValueBox(uservalues[0]), SettingsValueBox(uservalues[1])]),
							DivideLine(),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Notification']),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['About'], itemfunction: ()=>openAboutPage(context),),
							SettingsItem(itemheight: 60, itemcount: 1, itemname: ['Reset to Default'], itemfunction: ()=>SettingsPageState.resetDefaultSettings(),),
							DivideLine(),
						],
					),
				),
			)
    );
  }
}


