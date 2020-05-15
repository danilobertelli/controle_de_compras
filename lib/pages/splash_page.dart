import 'package:controledecompras/firebase/firebase_service.dart';
import 'package:controledecompras/pages/home/home_page.dart';
import 'package:controledecompras/pages/login/login_page.dart';
import 'package:controledecompras/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<FirebaseUser> future = FirebaseAuth.instance.currentUser();

    future.then((FirebaseUser value) {
      if (value != null) {
        firebaseUserUid = value.uid;
        push(context, HomePage(), replace: true);
        return;
      }
      push(context, LoginPage(), replace: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange[200],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
