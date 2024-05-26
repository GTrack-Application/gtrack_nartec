import 'package:gtrack_mobile_app/models/capture/aggregation/assembling/products_model.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssemblingController {
  static Future<List<ProductsModel>> getProductsByGtin(String gtin) async {
    String? userId = await AppPreferences.getUserId();
    String? token = await AppPreferences.getToken();

    String url =
        "${AppUrls.baseUrlWith3093}api/products?user_id=$userId&barcode=$gtin";

    print(url);

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    print(json.decode(response.body));

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
