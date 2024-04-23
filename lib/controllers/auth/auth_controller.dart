import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/auth/CRLoginModel.dart';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<List<CRLoginModel>> login(String email) async {
    final url = Uri.parse(
        '${AppUrls.baseUrlWith3091}api/users/getCrInfoByEmail?email=$email');

    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.get(url, headers: headers);

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      return data.map((e) => CRLoginModel.fromJson(e)).toList();
    } else {
      final msg = json.decode(response.body)['message'];
      throw Exception(msg);
    }
  }

  static Future<void> completeLogin(
    String email,
    String password,
    String activity,
  ) async {
    final url = Uri.parse('${AppUrls.baseUrlWith3091}api/users/memberLogin');

    print(url);

    final headers = <String, String>{'Content-Type': 'application/json'};

    final body = jsonEncode(
      {"email": email, "password": password, "activity": activity},
    );

    print(body);

    final response = await http.post(url, headers: headers, body: body);

    var data = json.decode(response.body);

    print(data);

    if (response.statusCode == 200) {
      return data;
    } else {
      final msg = data['error'];
      throw Exception(msg);
    }
  }
}
