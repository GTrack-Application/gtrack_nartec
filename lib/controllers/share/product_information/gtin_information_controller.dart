import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/product_information/gtin_information_model.dart';
import 'package:http/http.dart' as http;

class GtinInformationController {
  static Future<GtinInformationModel> getGtinInformation(String gtin) async {
    final url = Uri.parse(
        "${AppUrls.domain}/api/search/member/gtin?gtin=6287004290017");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GtinInformationModel.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      rethrow;
    }
  }
}
