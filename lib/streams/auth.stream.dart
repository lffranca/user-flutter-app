import 'dart:async';
import 'dart:convert';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suflex/models/auth.model.dart';
import 'package:suflex/settings/url.setting.dart';

class AuthStream {
  AuthStream() {
    this._verifyAuth();
  }

  Map<String, dynamic> _tokenConverter(String accessToken) {
    List<String> tokenItems = accessToken.split(".");

    while ((tokenItems[1].length * 6) % 8 != 0) tokenItems[1] += "=";

    const base64 = const Base64Codec();
    var resultBase64 = base64.decode(tokenItems[1]);

    Utf8Codec utf8Codec = new Utf8Codec();
    String resultUTF8 = utf8Codec.decode(resultBase64);

    return jsonDecode(resultUTF8);
  }

  void _verifyAuth() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String tokenString = prefs.getString(URLSetting.prefsAccess);

      if (tokenString?.isEmpty ?? true) {
        _controller.sink.add(Auth(false, false));
        return;
      }

      Map<String, dynamic> token = this._tokenConverter(tokenString);

      DateTime date =
          new DateTime.fromMillisecondsSinceEpoch(token["exp"] * 1000);

      if (date.isBefore(new DateTime.now())) {
        await prefs.clear();
        _controller.sink.add(Auth(false, false));
        return;
      }

      _controller.sink.add(Auth(false, true));
    } catch (e) {
      print(e);
      _controller.sink.add(Auth(false, false));
    }
  }

  final _controller = BehaviorSubject.seeded(Auth(true, false));

  Stream<Auth> get stream => _controller.stream;

  StreamSink<Auth> get update => _controller.sink;

  void dispose() {
    _controller.close();
  }
}
