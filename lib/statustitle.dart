import 'package:flutter/material.dart';
import 'main.dart';

class StatusTitle extends StatelessWidget {
  final String status;

  StatusTitle(this.status);

  getStatusTitle() {
    switch (this.status) {
      case 'Work':
        return 'Working';
      case 'Rest':
        return 'Resting';
      default:
        return 'Tomato Timer';
    }
  }

  getStatusMessage() {
    switch (this.status) {
      case 'Work':
        return 'Keep it up! You would earn with your effort.';
      case 'Rest':
        return 'Taking a break is for accomplishing a longer journey.';
      default:
        return 'Please press the tomato to trigger the counter.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: Text(
					getStatusTitle(),
					style: TextStyle(
						color: MyApp.myConfig.currentTheme.textblockColors[0],
						fontSize: 45,
						fontWeight: FontWeight.bold,
					)
				),
      ),
      Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          getStatusMessage(),
          style: TextStyle(
            color:MyApp.myConfig.currentTheme.textblockColors[0],
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }
}
