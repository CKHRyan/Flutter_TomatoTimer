import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'settings.dart';
import 'constants.dart';

class UserConfig {
	bool isLoadComplete = false;
	String appConfigDir;
	ColorTheme currentTheme;
	int workTimeInterval = 25;
	int restTimeInterval = 5;

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
				print(appdatajson);
				SettingsPageState.uservalues.add(TextEditingController(text: workTimeInterval.toString()));
				SettingsPageState.uservalues.add(TextEditingController(text: restTimeInterval.toString()));
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

	updateUserConfig(int newWI, int newRI, String newUITheme) async {
		parseJsonFromDirectory(appConfigDir)
			.then((appdatajson) async {
				print(appdatajson);
				var appdata = await json.decode(appdatajson);
				appdata['settings']['alarm']['work_interval'] = newWI;
				appdata['settings']['alarm']['rest_interval'] = newRI;
				appdata['settings']['ui_theme'] = newUITheme;
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
				defaultConfigJson['settings']['ui_theme']
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

	void changeUserSettings(List<int> setval) {
		if (setval != null && setval.length >= 3) {
			print("Set working interval to: " + setval[0].toString() + "mins");
			print("Set resting interval to: " + setval[1].toString() + "mins");

			workTimeInterval = setval[0];
			restTimeInterval = setval[1];
			currentTheme = setval[2] == 0 ? lightTheme : darkTheme;
			updateUserConfig(workTimeInterval, restTimeInterval, setval[2] == 0 ? "light" : "dark");

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