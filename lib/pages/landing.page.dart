import 'package:flutter/material.dart';
import 'package:suflex/models/auth.model.dart';
import 'package:suflex/pages/login.page.dart';
import 'package:suflex/pages/user.page.dart';
import 'package:suflex/streams/auth.stream.dart';

class LandingPage extends StatelessWidget {
  final authController = AuthStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Auth>(
      stream: authController.stream,
      builder: (context, AsyncSnapshot<Auth> snapshot) {
        if (snapshot.data == null || snapshot.data.loading) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data.isAuth) {
          return UserPage(authController);
        } else {
          return LoginPage(authController);
        }
      },
    );
  }
}
