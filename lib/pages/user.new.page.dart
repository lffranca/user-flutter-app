import 'package:flutter/material.dart';
import 'package:suflex/models/user.model.dart';
import 'package:suflex/providers/user.provider.dart';
import 'package:suflex/themes/input.text.dart';

class UserNewPage extends StatefulWidget {
  int id;

  UserNewPage({this.id});

  @override
  _UserNewPageState createState() => _UserNewPageState();
}

class _UserNewPageState extends State<UserNewPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerSobrenome = new TextEditingController();
  TextEditingController _controllerUsername = new TextEditingController();

  bool _loading = false;

  String _name;
  String _sobrenome;
  String _username;
  String _senha;

  @override
  void initState() {
    super.initState();

    if (this.widget.id != null) {
      _getUser(this.widget.id);
    }
  }

  void _getUser(int id) async {
    try {
      User user = await UserProvider.getByID(id);

      _controllerName.text = user.nome;
      _controllerSobrenome.text = user.sobrenome;
      _controllerUsername.text = user.username;

      // setState(() {
      //   _name = user.nome;
      //   _sobrenome = user.sobrenome;
      //   _username = user.username;
      // });
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo usuário"),
      ),
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 10,
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
                        decoration:
                            firstThemeLoginTextBlackFormDecoration("Nome"),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerName,
                        onSaved: (String val) => _name = val,
                        validator: _validatorEmpty,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            firstThemeLoginTextBlackFormDecoration("Sobrenome"),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerSobrenome,
                        onSaved: (String val) => _sobrenome = val,
                        validator: _validatorEmpty,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            firstThemeLoginTextBlackFormDecoration("Username"),
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerUsername,
                        onSaved: (String val) => _username = val,
                        validator: _validatorEmpty,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            firstThemeLoginTextBlackFormDecoration("Senha"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onSaved: (String val) => _senha = val,
                        validator: _validatorEmpty,
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
                    color: Theme.of(context).accentColor,
                    shape: StadiumBorder(),
                    child:
                        _loading ? CircularProgressIndicator() : Text('SALVAR'),
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() {
                              _loading = true;
                            });

                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                if (this.widget.id != null) {
                                  await UserProvider.update(this.widget.id,
                                      _name, _sobrenome, _username, _senha);
                                } else {
                                  await UserProvider.create(
                                      _name, _sobrenome, _username, _senha);
                                }

                                Navigator.pop(context, true);
                              } catch (e) {
                                print(e);
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Erro ao cadastrar usuário"),
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validatorEmpty(value) {
    if (value.isEmpty) {
      return 'Digite algum texto';
    }
    return null;
  }
}
