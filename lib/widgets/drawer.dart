import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suflex/models/auth.model.dart';
import 'package:suflex/streams/auth.stream.dart';

class DrawerWidget extends StatelessWidget {
  final AuthStream _authStream;

  DrawerWidget(this._authStream);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: Image.asset("assets/person.png").image,
                  radius: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Bem vindo",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () async {
              try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                this._authStream.update.add(Auth(false, false));
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
