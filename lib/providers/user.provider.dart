import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suflex/models/user.model.dart';
import 'package:suflex/settings/url.setting.dart';

class UserProvider {
  static Future<List<User>> getAll() async {
    final String _endpoint = "${URLSetting.urlApi}/private/user";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenString = prefs.getString(URLSetting.prefsAccess);

    if (tokenString?.isEmpty ?? true) {
      throw new Error();
    }

    Response response = await Dio().get(
      _endpoint,
      options: Options(
        headers: {
          "Authorization": "Bearer $tokenString",
        },
      ),
    );

    List<User> items = [];
    for (int index = 0; index < response.data.length; index++) {
      items.add(User.fromJson(response.data[index]));
    }

    return items;
  }

  static Future<User> getByID(int id) async {
    final String _endpoint = "${URLSetting.urlApi}/private/user/$id";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenString = prefs.getString(URLSetting.prefsAccess);

    if (tokenString?.isEmpty ?? true) {
      throw new Error();
    }

    Response response = await Dio().get(
      _endpoint,
      options: Options(
        headers: {
          "Authorization": "Bearer $tokenString",
        },
      ),
    );

    return User.fromJson(response.data);
  }

  static Future<void> delete(int id) async {
    final String _endpoint = "${URLSetting.urlApi}/private/user/$id";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenString = prefs.getString(URLSetting.prefsAccess);

    if (tokenString?.isEmpty ?? true) {
      throw new Error();
    }

    await Dio().delete(
      _endpoint,
      options: Options(
        headers: {
          "Authorization": "Bearer $tokenString",
        },
      ),
    );
  }

  static Future<void> create(String nome, sobrenome, username, senha) async {
    final String _endpoint = "${URLSetting.urlApi}/private/user";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenString = prefs.getString(URLSetting.prefsAccess);

    if (tokenString?.isEmpty ?? true) {
      throw new Error();
    }

    Map<String, dynamic> data = Map<String, dynamic>();
    data["nome"] = nome;
    data["sobrenome"] = sobrenome;
    data["username"] = username;
    data["senha"] = senha;

    await Dio().post(
      _endpoint,
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer $tokenString",
        },
      ),
    );
  }

  static Future<void> update(
      int id, String nome, sobrenome, username, senha) async {
    final String _endpoint = "${URLSetting.urlApi}/private/user/$id";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenString = prefs.getString(URLSetting.prefsAccess);

    if (tokenString?.isEmpty ?? true) {
      throw new Error();
    }

    Map<String, dynamic> data = Map<String, dynamic>();
    data["nome"] = nome;
    data["sobrenome"] = sobrenome;
    data["username"] = username;
    data["senha"] = senha;

    await Dio().put(
      _endpoint,
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer $tokenString",
        },
      ),
    );
  }
}
