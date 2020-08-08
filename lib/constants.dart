import 'package:flutter/material.dart';
import 'package:tomatotimer/settingsitem.dart';

final settingsThemeSwitchKey = new GlobalKey<SettingsSwitchState>();
final settingsNotifySwitchKey = new GlobalKey<SettingsSwitchState>();
final settingsVibrateSwitchKey = new GlobalKey<SettingsSwitchState>();

const ColorTheme lightTheme = const ColorTheme(
	Color(0xFFff4d47),
	[
		Color(0xFFa63333),
		Color(0xFFff4d47),
		Color(0xFFff6b6b),
	],
	Color(0xFFF0F0F0), 
	[
		Colors.black,
		Colors.white,
	]
);

const ColorTheme darkTheme = ColorTheme(
	Color(0xFF871900), 
	[
		Color(0xFF200000),
		Color(0xFF400000),
		Color(0xFF600000),
	],
	Color(0xFF450600),
	[
		Colors.white,
		Color(0xFF96291e), 
	]
);

class ColorTheme {
	final Color primaryColor;
	final List<Color> headerColors;
	final Color wallColor;
	final List<Color> textblockColors; // [0] is font color, [1] is text block backgroud color
	const ColorTheme(this.primaryColor, this.headerColors, this.wallColor, this.textblockColors);
}