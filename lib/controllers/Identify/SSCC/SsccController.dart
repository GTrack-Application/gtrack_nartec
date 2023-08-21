import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/Identify/SSCC/SsccProductsModel.dart';
import 'package:http/http.dart' as http;

class SsccController {
  static Future<List<SsccProductsModel>> getProducts() async {
    const String url = '${AppUrls.baseUrl}/api/member/sscc/list';

    final userId = await AppPreferences.getUserId();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'user_id': userId}),
        headers: {
          'Authorization': AppUrls.tokenIrfan,
          'Content-Type': 'application/json',
          'Host': AppUrls.host,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["SsccProducts"] as List;
        List<SsccProductsModel> products =
            data.map((e) => SsccProductsModel.fromJson(e)).toList();
        return products;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }
}
