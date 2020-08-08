import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
	@override
  void initState() {
		super.initState();
	}
	@override
  Widget build(BuildContext context) {
    return Scaffold(
			backgroundColor: MyApp.myConfig.currentTheme.wallColor,
			appBar: AppBar(
				title: Text("About"),
			),
			body: Container(
				margin: EdgeInsets.all(15),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
						Container(
							child: Text(
								"Tomato Timer",
								style: TextStyle(
									color: MyApp.myConfig.currentTheme.textblockColors[0],
									fontSize: 32,
									fontWeight: FontWeight.w600,
								)
							)
						),
						Container(
							margin: EdgeInsets.only(bottom: 15, left: 2),
							child: Text(
								"Version: 0.0.1 beta",
								style: TextStyle(
									color: MyApp.myConfig.currentTheme.textblockColors[0],
									fontSize: 16,
								)
							)
						),
						Container(
							margin: EdgeInsets.only(left: 2),
							child: Text(
								"Author: CHUNG KA HO RYAN",
								style: TextStyle(
									color: MyApp.myConfig.currentTheme.textblockColors[0],
									fontSize: 18,
									fontWeight: FontWeight.w300,
								)
							)
						),
						Container(
							margin: EdgeInsets.only(left: 2),
							child: Row(
								children: <Widget>[
									Text(
										"Enquiry: ",
										style: TextStyle(
												color: MyApp.myConfig.currentTheme.textblockColors[0],
												fontSize: 18,
												fontWeight: FontWeight.w300,
										)
									),
									InkWell(
										onTap: () => launch("mailto:waterho6494@gmail.com?subject=Enquiry%20On%20Tomato%20Timer"),
										child: Text(
											"waterho6494@gmail.com",
											style: TextStyle(
												color: Colors.blue,
												fontSize: 18,
												fontWeight: FontWeight.w300,
												decoration: TextDecoration.underline,
											)
										)
									)
								]
							)
						),
					]
				)
			)
		);
	}
}
