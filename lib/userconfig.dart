import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tomatotimer/settingsitem.dart';

import 'settings.dart';
import 'constants.dart';

class UserConfig {
	bool isLoadComplete = false;
	String appConfigDir;
	ColorTheme currentTheme;
	int workTimeInterval = 25;
	int restTimeInterval = 5;
	bool isNotificationEnable;
	bool isVibrationEnable;


	getAppConfigDir() async {
		var dbDir = await getDatabasesPath();
		appConfigDir = join(dbDir, "userconfig.json");
	}

	getAppDefaultConfigDir() {
		return "assets/data/settings.json";
	}

	Future<void> loadUserSettings() async {
		await getAppConfigDir();
		bool isGetConfig = await setupUserConfig(getAppDefaultConfigDir(), appConfigDir);
		if (isGetConfig) {
			print("Get the User Config successfully.");
			await parseJsonFromDirectory(appConfigDir)
			.then((appdatajson) async {
				final appdata = await json.decode(appdatajson);
				workTimeInterval = await appdata['settings']['alarm']['work_interval'];
				restTimeInterval= await appdata['settings']['alarm']['rest_interval'];
				currentTheme = await appdata['settings']['ui_theme'] == "dark" ? darkTheme : lightTheme;
				isNotificationEnable = await appdata['settings']['notification'];
				isVibrationEnable = await appdata['settings']['vibration'];
				print(appdatajson);
				SettingsPageState.uservalues.add(TextEditingController(text: workTimeInterval.toString()));
				SettingsPageState.uservalues.add(TextEditingController(text: restTimeInterval.toString()));
				SettingsPageState.userswitches.add(SettingsSwitch(key: settingsThemeSwitchKey, switchName: 'ThemeSwitch')); // theme
				SettingsPageState.userswitches.add(SettingsSwitch(key: settingsNotifySwitchKey, switchName: 'NotifySwitch'));
				SettingsPageState.userswitches.add(SettingsSwitch(key: settingsVibrateSwitchKey, switchName: 'VibrateSwitch')); // noti
				await Future.delayed(
					const Duration(milliseconds: 1500), 
					(){ isLoadComplete = true; }
				);
			});
		}
		else {
			print("Failed to get the User Config.");
			isLoadComplete = false;
		}
	}

	Future<bool> setupUserConfig(String assetspath, String dirpath) async {
		try {
			final userconfig = new File(dirpath);
			if (!await userconfig.exists()) {
				print('Copying json from assets to ' + dirpath + ' ...');
				ByteData data = await rootBundle.load(assetspath);
				List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
				await File(dirpath).writeAsBytes(bytes).then((value) => print('Write file successfully.'));
			}
			else {
				print('User config is founded from ' + dirpath);
			}
			return true;
		} catch(err) {
			print(err);
			return false;
		}
	}

	updateUserConfig(int newWI, int newRI, String newUITheme, [bool newNoti, bool newVbr]) async {
		parseJsonFromDirectory(appConfigDir)
			.then((appdatajson) async {
				print(appdatajson);
				var appdata = await json.decode(appdatajson);
				appdata['settings']['alarm']['work_interval'] = newWI;
				appdata['settings']['alarm']['rest_interval'] = newRI;
				appdata['settings']['ui_theme'] = newUITheme;
				if (newNoti != null) {
					appdata['settings']['notification'] = newNoti;
				}
				if (newVbr != null) {
					appdata['settings']['vibration'] = newVbr;
				}
				print("User settings is updated.");
				print(appdata);
				writeJsonToDirectory(appdata);
		});
	}

	removeUserConfig() async {
		var dbDir = await getDatabasesPath();
		var dbPath = join(dbDir, "userconfig.json");
		final userconfig = new File(dbPath);
		if(await userconfig.exists()) {
			File(dbPath).deleteSync(recursive: true);
			print("User config is removed successfully.");
		}
		else {
			print("No user config is founded for removing.");
		}
	}

	Future<List<String>> getDefaultUserConfig() async {
		var defaultConfigJson;
		List<String> defaultConfigStr;
		await rootBundle.loadString(getAppDefaultConfigDir())
		.then((deafaultConfigJsonStr){
			defaultConfigJson = json.decode(deafaultConfigJsonStr);
			defaultConfigStr = 
			[
				defaultConfigJson['settings']['alarm']['work_interval'].toString(),
				defaultConfigJson['settings']['alarm']['rest_interval'].toString(),
				defaultConfigJson['settings']['ui_theme'],
			];
		});
		return defaultConfigStr;
	}

	static Future<String> parseJsonFromDirectory(String dirpath) async {
		String configJsonStr = '';
		try {
			final File file = File(dirpath);
			configJsonStr = await file.readAsString();
		} catch (e) {
			print("Fail to read file.");
		}
		return configJsonStr;
  }

	writeJsonToDirectory(dynamic configjson) {
		print('Saving user settings to user config at ' + appConfigDir + ' ...');
		File(appConfigDir).writeAsStringSync(json.encode(configjson), mode: FileMode.write);
	}

	void changeUserSettings(List<String> setval) {
		if (setval != null && setval.length >= 3) {
			print("Set working interval to: " + setval[0] + "mins");
			print("Set resting interval to: " + setval[1] + "mins");
			print("Set current theme to: " + setval[2] + " theme");
			if (setval.length >= 5) {
				print("Set notification availability to: " + setval[3]);
				print("Set vibration availability to: " + setval[4]);
			}

			workTimeInterval = int.parse(setval[0]);
			restTimeInterval = int.parse(setval[1]);
			currentTheme = setval[2] == "dark" ? darkTheme : lightTheme;
			if (setval.length >= 5) {
				isNotificationEnable = setval[3].toLowerCase()=='true';
				isVibrationEnable = setval[4].toLowerCase()=='true';
			}
			
			updateUserConfig(
				workTimeInterval, 
				restTimeInterval, 
				setval[2], 
				setval.length >= 4 ? setval[3].toLowerCase()=='true' : null, 
				setval.length >= 5 ? setval[4].toLowerCase()=='true' : null
			);

		}
	}

	List<int> getUserInterval() {
		List<int> timeInterval = [workTimeInterval, restTimeInterval];
		return timeInterval;
	}

	setCurrentTheme(String theme) {
		switch(theme) {
			case "dark":
				currentTheme = darkTheme;
				break;
			case "light":
				currentTheme = lightTheme;
				break;
		}
	}

}