// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/IDENTIFY/SSCC/SsccModel.dart';
import 'package:http/http.dart' as http;

class SsccController {
  static HttpService httpService = HttpService(baseUrl: AppUrls.gs1Url);

  static Future<List<SsccModel>> getProducts() async {
    final userId = await AppPreferences.getGs1UserId();

    String url = 'api/sscc?user_id=$userId';

    final response = await httpService.request(url);

    var data = response.data as List;

    if (response.success) {
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
