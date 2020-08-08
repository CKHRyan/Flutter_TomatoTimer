import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'topheader.dart';
import 'statustitle.dart';
import 'userconfig.dart';
import 'methods.dart';

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
						return AppLoadingPage();
				}
			);
	}
}

class AppLoadingPage extends StatefulWidget {
	AppLoadingPage({Key key}) : super(key: key);
	@override
	AppLoadingPageState createState() => AppLoadingPageState();
}

class AppLoadingPageState extends State<AppLoadingPage> with TickerProviderStateMixin {
	AnimationController fadeController;
	Animation animation;

	@override
	void initState() {
		super.initState();
		fadeController = AnimationController(vsync: this, duration: Duration(seconds: 2));
		fadeController.forward();
	}

	@override
		Widget build(BuildContext context) {
			final size =  MediaQuery.of(context).size;
			return Scaffold(
				backgroundColor: !MyApp.myConfig.isLoadComplete 
				? 
					Colors.redAccent.shade200
				: 
					MyApp.myConfig.currentTheme.wallColor,
				body: Center(
					child: MyApp.myConfig.isLoadComplete 
					? 
						FadeTransition(
								opacity: fadeController.drive(CurveTween(curve: Curves.ease)),
							child: MyHomePage()
						)
					:
						Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								Stack(
									alignment: Alignment.center,
									children: <Widget>[
										Container(
											height: size.width * 0.8,
											width: size.width * 0.8,
											decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
											child: Container(
												padding: EdgeInsets.all(size.width*0.1),
												child: Image(image: AssetImage('assets/image/icon.png')),
											),
										),
										Container(
											height: size.width * 0.9,
											width: size.width * 0.9, 
											child: CircularProgressIndicator(
												valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade900),
											),
										),
									],
								),
								Container(
									margin: EdgeInsets.only(top: 30),
									child: Text(
										"Welcome to\nTomato Timer 🍅",
										textAlign: TextAlign.center,
										style: TextStyle(
											color: Colors.white,
											fontSize: 36,
											fontWeight: FontWeight.w500,
										),
									)
								),
								Container(
									margin: EdgeInsets.only(top: 5),
									child: Text(
										"version: 0.0.1 beta",
										style: TextStyle(
											color: Colors.grey.shade300,
											fontSize: 16,
											fontWeight: FontWeight.w300,
										),
									)
								),
							]
						)
				)
			);
		}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key}) : super(key: key);
	static ValueNotifier isMainPage = ValueNotifier(false);
	@override
	MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
	int currentsec = 10;
	int workInterval = 25;
	int restInterval = 5;
	bool isCounting = false;
	String status = 'Pre_Work'; 

	void initState() {
		super.initState();
		updateIntervaltoAlarm(MyApp.myConfig.getUserInterval());
		MyHomePage.isMainPage.addListener(() {
			if (MyHomePage.isMainPage.value == true) {
				print("Go back to the timer page.");
				setState(() {});
				updateIntervaltoAlarm(MyApp.myConfig.getUserInterval());
				MyHomePage.isMainPage.value = false;
			}
		});
	}


	updateIntervaltoAlarm(List<int> intervals) {
		this.workInterval = intervals[0];
		this.restInterval = intervals[1];
	}

	isPrepare() {
		if (status == 'Pre_Work' || status == 'Pre_Rest') {
			return true;
		} else {
			return false;
		}
	}

	startAlarm() {
		print('Requesting to start alarm...');
		if (!this.isCounting) {
			switch (status) {
				case 'Pre_Work':
					startWork();
					print("Start Working!");
					break;
				case 'Pre_Rest':
					startRest();
					print("Start Resting!");
					break;
			}
		}
	}
	
	stopAlarm() async {
		this.isCounting = false;
		String action, message;
		switch (this.status) {
			case 'Work':
				action = "Pause Working";
				message = "It is time to take a rest!";
				setState(() {
					this.status = 'Pre_Rest';
				});
				break;
			case 'Rest':
				action = "Stop Resting";
				message = "It is time to work hard again!";
				setState(() {
					this.status = 'Pre_Work';
				});
				break;
		}
		if (action != null && message != null) {
			showAlertDialog(this.context, action, message);
		}
		if (await Vibration.hasVibrator()) {
			Vibration.vibrate(duration: 1000);
		}
		await MyApp.myNotification.sendNotification(action, message);
	}

	startWork() {
		setState(() {
			status = 'Work';
			currentsec = workInterval;
		});
		this.startTimer();
	}

	startRest() {
		setState(() {
			status = 'Rest';
			currentsec = restInterval;
		});
		this.startTimer();
	}

	startTimer() {
		this.isCounting = true;
		const count_interval = const Duration(seconds: 1);
		new Timer.periodic(
			count_interval,
			(Timer timer) => setState(
				() {
					if (currentsec < 1) {
						stopAlarm();
						timer.cancel();
					} else {
						currentsec--;
					}
				},
			),
		);
	}

	getCountTime(int cursec) {
		int min = (cursec / 60).floor();
		int sec = cursec % 60;
		return min.toString().padLeft(2, '0') +
				' : ' +
				sec.toString().padLeft(2, '0');
	}

	showAlertDialog(BuildContext context, String act, String msg) {
		// set up the button
		Widget okButton = FlatButton(
			child: Text("OK"),
			onPressed: () {
				MyApp.myNotification.cancelNotification();
				Navigator.of(context).pop();
			},
		);

		// set up the AlertDialog
		AlertDialog alert = AlertDialog(
			title: Text(act),
			content: Text(msg),
			actions: [
				okButton,
			],
		);

		// show the dialog
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return alert;
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		Size size = MediaQuery.of(context).size;
		return Scaffold(
			backgroundColor: MyApp.myConfig.currentTheme.wallColor,
			body: SingleChildScrollView(
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						children: <Widget>[
							Header(),
							StatusTitle(this.status),
							SizedBox(height: 10),
							Stack(
								children: <Widget>[
									GestureDetector(
										child: Container(
											child: SvgPicture.asset(
												'assets/image/TomatoImg.svg',
												height: 290,
												width: size.width,
											),
										),
										onTap: this.startAlarm,
									),
									Positioned.fill(
										bottom: -180,
										child: Align(
											alignment: Alignment.center,
											child: Container(
												child: Text(
													isPrepare() ? '' : getCountTime(currentsec),
													style: TextStyle(
														color: Colors.white,
														fontSize: 40,
														fontWeight: FontWeight.bold,
													),
													textAlign: TextAlign.center,
												),
											),
										),
									),
								]
							),
						],
					),
				),
			)
		);
	}
}
				

