import 'package:example/helpers/altogic_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({this.routeTo, this.routeToAuth, Key? key})
      : super(key: key);

  final String? routeToAuth;
  final String? routeTo;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AltogicHelper get helper => AltogicHelper();

  @override
  void initState() {
    helper.init().then((value) {
      if (helper.userLoggedIn) {
        Navigator.pushNamed(context, widget.routeToAuth ?? '/home');
      } else {
        Navigator.pushNamed(context, widget.routeTo ?? '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
