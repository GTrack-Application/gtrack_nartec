import 'dart:convert';
import 'dart:developer';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling/products_model.dart';
import 'package:http/http.dart' as http;

class AssemblingController {
  static Future<List<ProductsModel>> getProductsByGtin(String gtin) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    Map<String, dynamic> parameters = {
      "user_id": userId,
      "field": gtin,
    };

    final url =
        "${AppUrls.baseUrlWith7000}getAssemblingsByUserAndBarcode?user_id=$userId&field=$gtin";

    log(url);

    final uri = Uri.parse(url);
    uri.replace(queryParameters: parameters);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    log(response.body.toString());

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }
}
