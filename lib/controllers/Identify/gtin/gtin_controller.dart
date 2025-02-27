import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:http/http.dart' as http;

class GTINController {
  static final HttpService httpService = HttpService(baseUrl: AppUrls.gs1Url);

  static Future<List<GTIN_Model>> getProducts() async {
    final userId = await AppPreferences.getUserId();

    String url = "api/products?user_id=$userId";

    final response = await httpService.request(url);

    var data = response.body as List;

    if (response.success) {
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

  static Future<PaginatedGTINResponse> getPaginatedProducts({
    required int page,
    required int pageSize,
  }) async {
    final userId = await AppPreferences.getGs1UserId();

    final url =
        "api/products/paginatedProducts?page=$page&pageSize=$pageSize&user_id=$userId";

    final response = await httpService.request(url);

    if (response.success) {
      return PaginatedGTINResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load paginated products');
    }
  }
}
