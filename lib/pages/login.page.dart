import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suflex/models/auth.model.dart';
import 'package:suflex/models/auth.response.dart';
import 'package:suflex/providers/auth.provider.dart';
import 'package:suflex/settings/url.setting.dart';
import 'package:suflex/streams/auth.stream.dart';
import 'package:suflex/themes/input.text.dart';

class LoginPage extends StatefulWidget {
  final AuthStream _authStream;

  LoginPage(this._authStream);

  @override
  _LoginPageState createState() => _LoginPageState(_authStream);
}

class _LoginPageState extends State<LoginPage> {
  final AuthStream _authStream;

  _LoginPageState(this._authStream);

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                // color: Colors.yellow,
                child: Image.asset(
                  "assets/laranja2.png",
                  height: 200,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            firstThemeLoginTextFormDecoration("Usuário"),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String val) {
                          _username = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: firstThemeLoginTextFormDecoration("Senha"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onSaved: (String val) {
                          _password = val;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Digite algum texto';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 60,
                  right: 60,
                ),
                height: 56,
                child: Builder(
                  builder: (context) => RaisedButton(
                    color: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    shape: StadiumBorder(),
                    child:
                        _loading ? CircularProgressIndicator() : Text('ENTRAR'),
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() {
                              _loading = true;
                            });

                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                AuthResponse response =
                                    await AuthProvider.login(
                                        _username, _password);

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                await prefs.setString(
                                    URLSetting.prefsAccess, response.token);

                                this._authStream.update.add(Auth(false, true));
                              } catch (e) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Usuário ou senha inválida!"),
                                  ),
                                );
                              }
                            }

                            setState(() {
                              _loading = false;
                            });
                          },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 60,
                  right: 60,
                ),
                child: FlatButton(
                  child: Text(
                    "RECUPERAR SENHA",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
