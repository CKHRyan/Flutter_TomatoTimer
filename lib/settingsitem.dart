import 'dart:core';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'main.dart';
import 'settings.dart';
import 'constants.dart';

class SettingsItem extends StatefulWidget {
	final double itemheight;
	final int itemcount;
	final List<String> itemname;
	final List<dynamic> iteminput;
	final Function itemfunction;

	SettingsItem({
		Key key, 
		this.itemheight, 
		this.itemcount, 
		this.itemname, 
		this.iteminput, 
		this.itemfunction
		}) : super(key: key);

	@override
	SettingsItemState createState() => SettingsItemState();
}

class SettingsItemState extends State<SettingsItem> {

  @override
  Widget build(BuildContext context) {
		List<Widget> itemlist = [];
    for(var i = 0; i < widget.itemcount; i++){
        itemlist.add(
					Container(
						margin: EdgeInsets.symmetric(vertical: 5),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
									Text(
										widget.itemname[i],
										style: TextStyle(
											fontSize: 20,
											color: MyApp.myConfig.currentTheme.textblockColors[0],
										),
									),
									if (widget.iteminput != null) 
										widget.iteminput[i]
							],
						)
					)
				);
    }
    return GestureDetector(
			onTap:
				widget.itemfunction != null 
				? widget.itemfunction
				: ()=>{}
			,
			child: Container(
				height: widget.itemheight,
				width: 500,
				decoration: BoxDecoration(
					color: MyApp.myConfig.currentTheme.textblockColors[1],
					borderRadius: BorderRadius.circular(10),
					boxShadow: [
						if (widget.iteminput==null) 
							BoxShadow(
								color: Colors.black.withOpacity(0.3),
								spreadRadius: 1,
								blurRadius: 5,
								offset: Offset(2, 2), // changes position of shadow
							)
					],
				),
				margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
				padding: EdgeInsets.symmetric(horizontal: 30),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: itemlist
				)
			)
		);
  }
}

class SettingsSwitch extends StatefulWidget {
	final String switchName;
	SettingsSwitch({Key key, this.switchName}) : super(key: key);

	@override
	SettingsSwitchState createState() => SettingsSwitchState();//switchState
}

class SettingsSwitchState extends State<SettingsSwitch> {
	bool isSwitched;

	@override
  void initState() {
    super.initState();
		bool initValue;
		switch(widget.switchName) {
			case "ThemeSwitch":
				initValue = MyApp.myConfig.currentTheme==darkTheme;
				break;
			case "NotifySwitch":
				try {
					initValue = SettingsPageState.lastNotiSettings[0];
				} 
				catch(err) {
					initValue = MyApp.myConfig.isNotificationEnable;
				}
				break;
			case "VibrateSwitch":
				try {
					initValue = SettingsPageState.lastNotiSettings[1];
				} 
				catch(err) {
					initValue = MyApp.myConfig.isVibrationEnable;
				}
				break;
			default:
				initValue = true;
		}
		this.isSwitched = initValue;
	}

	void setSwitchValue(bool value) {
		setState(() {
		  this.isSwitched = value;
		});
	}

	@override
  Widget build(BuildContext context) { 
    return Switch(
      activeColor: Colors.red,
      value: this.isSwitched,
      onChanged: (bool value) {
        setState(() {
          this.isSwitched = value;
        });
        print("The switch turns to " + value.toString());
      },
		);
	}
}

class SettingsValueBox extends StatelessWidget {
	final TextEditingController valcontroller;

	SettingsValueBox(this.valcontroller);

	@override
  Widget build(BuildContext context) {
    return Center (
			child: Container(
				height: 35,
				width: 60,
				decoration: BoxDecoration(color: MyApp.myConfig.currentTheme.wallColor),
				child: TextField(
					controller: this.valcontroller,
					maxLength: 3,
					keyboardType: TextInputType.number,
					autofocus: false,
					decoration: InputDecoration(
						border: OutlineInputBorder(),
						contentPadding: EdgeInsets.zero,
						counterText: "",
					),
					style: TextStyle(
						fontSize: 25,
						color: MyApp.myConfig.currentTheme.textblockColors[0],
					),
					textAlign: TextAlign.center,
				)
			)
		);
	}
}

class DivideLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
			children: <Widget>[
				SizedBox(height: 15),
				Divider(
					color: Color(0xCCCCCCCC),
					height: 20,
					thickness: 1,
					indent: 20,
					endIndent: 20,
				),
				]
		);
  }
}