import 'package:dio/dio.dart';
import 'package:suflex/models/auth.response.dart';
import 'package:suflex/settings/url.setting.dart';

class AuthProvider {
  static Future<AuthResponse> login(String username, String password) async {
    final String _endpoint = "${URLSetting.urlApi}/login";

    try {
      Response response = await Dio().post(_endpoint, data: {
        "username": username,
        "senha": password,
      });

      return AuthResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
