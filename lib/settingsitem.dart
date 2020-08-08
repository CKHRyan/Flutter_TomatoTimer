import 'dart:core';
import 'package:flutter/material.dart';
import 'main.dart';
import 'constants.dart';

class SettingsItem extends StatefulWidget {
	SettingsItem({
		Key key, 
		this.itemheight, 
		this.itemcount, 
		this.itemname, 
		this.iteminput, 
		this.itemfunction
		}) : super(key: key);

	final double itemheight;
	final int itemcount;
	final List<String> itemname;
	final List<dynamic> iteminput;
	final Function itemfunction;

	@override
	SettingsItemState createState() => SettingsItemState();
}

class SettingsItemState extends State<SettingsItem> {

  SettingsItemState();

  @override
  Widget build(BuildContext context) {
		List<Widget> itemlist = new List<Widget>();
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
	SettingsSwitch({Key key}) : super(key: key);
	static ValueNotifier changeSwitchVal = ValueNotifier(false);
	@override
	SettingsSwitchState createState() => SettingsSwitchState();
}

class SettingsSwitchState extends State<SettingsSwitch> {
	static bool isSwitched;
	
	@override
  void initState() {
    super.initState();
		setState(() {
		  SettingsSwitchState.isSwitched = MyApp.myConfig.currentTheme == darkTheme;
		});
		SettingsSwitch.changeSwitchVal.addListener(() {
			if (mounted) {
				setState(() {
					isSwitched = SettingsSwitch.changeSwitchVal.value;
				});
				print("Switch value listener responds successfully.");
			}
		});
  }

	@override
  Widget build(BuildContext context) { 
    return Switch(
				value: SettingsSwitchState.isSwitched,
				onChanged: (bool value) {
					setState(() {
					  SettingsSwitchState.isSwitched = value;
						SettingsSwitch.changeSwitchVal.value = value;
						print("Dark theme switch turns to " + value.toString());
					});
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