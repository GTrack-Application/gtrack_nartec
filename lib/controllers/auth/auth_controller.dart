import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/auth/CRLoginModel.dart';
import 'package:gtrack_mobile_app/models/auth/LoginResponseModel.dart';
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

  static Future<LoginResponseModel> completeLogin(
      String email, String password, String activity) async {
    final url = Uri.parse('${AppUrls.baseUrlWith3091}api/users/memberLogin');

    final headers = <String, String>{'Content-Type': 'application/json'};

    final body = jsonEncode(
      {"email": email, "password": password, "activity": activity},
    );

    final response = await http.post(url, headers: headers, body: body);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(data);
    } else {
      final msg = data['error'];
      throw Exception(msg);
    }
  }
}
