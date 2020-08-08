import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main.dart';
import 'methods.dart';

class Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
			children: <Widget>[
      	ClipPath(
          clipper: CustomHalfCircleClipper(),
          child: Container(
            height: size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
								begin: Alignment.topCenter,
								end: Alignment.bottomCenter,
								colors: MyApp.myConfig.currentTheme.headerColors,
            	)
						),
          )
				),
				Positioned(
					left: 10,
					top: 30,
					height: 40,
					width: 40,
					child: Container(
						decoration: BoxDecoration(
							boxShadow: [
								BoxShadow(
									color: Colors.black.withOpacity(0.3),
									spreadRadius: 2,
									blurRadius: 15,
									offset: Offset(-5, 0), // changes position of shadow
								),
							],
						),
						child: GestureDetector(
							child: SvgPicture.asset(
								'assets/image/menu.svg',
								height: 40,
								width: 40,
								color: Color(0xFFEEEEEE),
							),
							onTap: () => PageManager.openSettingsPage(context)
						)
					)
				),
    	]
		);
  }
}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
