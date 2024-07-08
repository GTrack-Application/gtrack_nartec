import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:http/http.dart' as http;

class GTINController {
  static Future<List<GTIN_Model>> getProducts() async {
    final userId = await AppPreferences.getUserId();
    final token = await AppPreferences.getToken();

    String url = "${AppUrls.baseUrlWith3093}/api/products?user_id=$userId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Host': AppUrls.host,
        'Authorization': 'Bearer $token',
      },
    );

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<GTIN_Model> products =
          data.map((e) => GTIN_Model.fromJson(e)).toList();

      return products;
    } else {
      return [];
    }
  }

  static Future<void> deleteProductById(String productId) async {
    final token = await AppPreferences.getToken();
    String url = "${AppUrls.baseUrlWith3093}api/products/gtin/$productId";
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'authorization': "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
