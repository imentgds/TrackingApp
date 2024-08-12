import 'package:flutter/material.dart';
import 'login2.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _animateWelcomeScreen();
  }

  void _animateWelcomeScreen() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });

      // After the animation is complete, navigate to the next screen
      Future.delayed(Duration(seconds: 4), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 2),
          child: Text(
            'Welcome',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
