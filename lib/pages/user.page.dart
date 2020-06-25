import 'package:flutter/material.dart';
import 'package:suflex/models/user.model.dart';
import 'package:suflex/pages/user.new.page.dart';
import 'package:suflex/providers/user.provider.dart';
import 'package:suflex/streams/auth.stream.dart';
import 'package:suflex/widgets/drawer.dart';

class UserPage extends StatefulWidget {
  final AuthStream _authStream;

  UserPage(this._authStream);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> _users = [];

  void _getAll() async {
    try {
      List<User> users = await UserProvider.getAll();

      setState(() {
        this._users = users;
      });
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao pegar informações"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    this._getAll();
  }

  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Deletar item"),
          content: new Text("Deseja realmente deletar esse item?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Não"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () async {
                try {
                  await UserProvider.delete(id);

                  this._getAll();

                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao deletar usuário"),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
      ),
      drawer: DrawerWidget(this.widget._authStream),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_users[index].nome} ${_users[index].sobrenome}'),
              subtitle: Text('${_users[index].username}'),
              trailing: Wrap(
                spacing: 2,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      try {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserNewPage(
                              id: _users[index].id,
                            ),
                          ),
                        );

                        this._getAll();
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _deleteItem(_users[index].id),
                  ),
                ],
              ),
            );
          },
        ),
        onRefresh: () async => this._getAll(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          try {
            await Navigator.pushNamed(context, "/user-new");
            this._getAll();
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
