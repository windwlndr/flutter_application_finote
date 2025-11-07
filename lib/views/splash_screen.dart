import 'package:flutter/material.dart';
import 'package:flutter_application_finote/preferences/preferences_handler.dart';
import 'package:flutter_application_finote/views/login_page.dart';
import 'package:flutter_application_finote/widgets/buttom_navbar.dart';

class SplashScreenDay18 extends StatefulWidget {
  const SplashScreenDay18({super.key});

  @override
  State<SplashScreenDay18> createState() => _SplashScreenDay18State();
}

class _SplashScreenDay18State extends State<SplashScreenDay18> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    Future.delayed(Duration(seconds: 3)).then((value) async {
      var isLogin = await PreferenceHandler.getLogin();
      print(isLogin);
      if (isLogin != null && isLogin == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ButtomNavbarWidgets()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreenDay18()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff09887f), Color(0x3509887f)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/Finote.png", scale: 3)),
          ],
        ),
      ),
    );
  }
}
