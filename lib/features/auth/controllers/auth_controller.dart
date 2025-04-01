// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/auth/models/CRLoginModel.dart';
import 'package:gtrack_nartec/features/auth/models/LoginResponseModel.dart';
import 'package:gtrack_nartec/features/auth/models/login_model.dart';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<LoginModel> loginWithPassword(
      String email, String password) async {
    const baseUrl = '${AppUrls.baseUrlWith7010}/api/memberSubUser/login';
    final uri = Uri.parse(baseUrl);

    final body = json.encode({'email': email, 'password': password});

    try {
      final response = await http
          .post(uri, body: body, headers: {'Content-Type': 'application/json'});

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return LoginModel.fromJson(responseBody);
      } else {
        final msg = json.decode(response.body)['error'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

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

    print(url);
    print(body);

    final response = await http.post(url, headers: headers, body: body);

    var data = json.decode(response.body);

    print(data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponseModel.fromJson(data);
    } else {
      final msg = data['error'];
      print(msg);
      throw Exception(msg);
    }
  }
}
