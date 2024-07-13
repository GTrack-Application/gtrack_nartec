// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/SSCC/SsccModel.dart';
import 'package:http/http.dart' as http;

class SsccController {
  static Future<List<SsccModel>> getProducts() async {
    final userId = await AppPreferences.getUserId();
    final token = await AppPreferences.getToken();
    // cluzof0sl000fbxonvfcedb16 userId
    String url = '${AppUrls.baseUrlWith3093}/api/sscc?user_id=$userId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Host': AppUrls.host,
        'Authorization': 'Bearer $token',
      },
    );

    print(json.decode(response.body));

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<SsccModel> products =
          data.map((e) => SsccModel.fromJson(e)).toList();

      return products;
    } else {
      return [];
    }
  }

  // delete sscc
  static Future<void> deleteSscc(String sscc) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}api/sscc/$sscc');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.delete(url, headers: headers);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(data);
    } else {
      throw Exception(data['error']);
    }
  }
}
