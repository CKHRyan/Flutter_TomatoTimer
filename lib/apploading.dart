import 'package:flutter/material.dart';
import 'main.dart';
import 'timer.dart';

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
							child: TimerPage()
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