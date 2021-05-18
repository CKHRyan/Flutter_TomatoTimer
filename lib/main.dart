import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

import 'userconfig.dart';
import 'methods.dart';
import 'apploading.dart';


Future<void> main() async {
	runApp(
		MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Tomato Timer',
			theme: ThemeData(
				primarySwatch: Colors.red,
				visualDensity: VisualDensity.adaptivePlatformDensity,
			),
			home: MyApp(),
		)
	);
}

class MyApp extends StatelessWidget {
	static final UserConfig myConfig = new UserConfig();
	static final LocalNotification myNotification = new LocalNotification();

	@override
	Widget build(BuildContext context)  {
			return FutureBuilder<dynamic>( 
				future: myConfig.loadUserSettings(),
				builder:(context, snapshot) {
					return MaterialApp(home: AppLoadingPage());
				}
			);
	}
}

