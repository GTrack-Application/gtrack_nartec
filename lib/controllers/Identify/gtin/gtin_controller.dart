import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/ingredient_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/packaging_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/retailer_model.dart';
import 'package:http/http.dart' as http;

class GTINController {
  static final HttpService httpService = HttpService(baseUrl: AppUrls.gs1Url);
  static final HttpService upcHubService = HttpService(baseUrl: AppUrls.upcHub);

  // static Future<List<GTIN_Model>> getProducts() async {
  //   final userId = await AppPreferences.getUserId();

  //   String url = "api/products?user_id=$userId";

  //   final response = await httpService.request(url);

  //   var data = response.body as List;

  //   if (response.success) {
  //     List<GTIN_Model> products =
  //         data.map((e) => GTIN_Model.fromJson(e)).toList();

  //     return products;
  //   } else {
  //     return [];
  //   }
  // }

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
    print("userId: $userId");

    final url =
        "api/products/paginatedProducts?page=$page&pageSize=$pageSize&user_id=$userId";

    final response = await httpService.request(url);

    if (response.success) {
      return PaginatedGTINResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load paginated products');
    }
  }

  static Future<AllergenResponse> getAllergenInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
      'digitalLinks/allergens?page=$page&pageSize=$limit&barcode=$gtin',
      method: HttpMethod.get,
    );

    final allergenResponse = AllergenResponse.fromJson(response.data);

    return allergenResponse;
  }

  static Future<RetailerResponse> getRetailerInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
      'digitalLinks/retailers?page=$page&pageSize=$limit&barcode=$gtin',
      method: HttpMethod.get,
    );

    final retailerResponse = RetailerResponse.fromJson(response.data);
    return retailerResponse;
  }

  static Future<IngredientResponse> getIngredientInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
      'digitalLinks/ingredients?page=$page&pageSize=$limit&barcode=$gtin',
      method: HttpMethod.get,
    );

    final ingredientResponse = IngredientResponse.fromJson(response.data);
    return ingredientResponse;
  }

  static Future<PackagingResponse> getPackagingInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
      'digitalLinks/packagings?page=$page&pageSize=$limit&barcode=$gtin',
      method: HttpMethod.get,
    );

    final packagingResponse = PackagingResponse.fromJson(response.data);
    return packagingResponse;
  }

  static Future<Map<String, dynamic>> getDigitalLinkViewData(
    String gtin, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final responses = await Future.wait([
        getAllergenInformation(gtin, page: page, limit: limit),
        getRetailerInformation(gtin, page: page, limit: limit),
        getIngredientInformation(gtin, page: page, limit: limit),
        getPackagingInformation(gtin, page: page, limit: limit),
      ]);

      return {
        'allergens': responses[0],
        'retailers': responses[1],
        'ingredients': responses[2],
        'packagings': responses[3],
      };
    } catch (e) {
      throw Exception('Failed to fetch digital link data: $e');
    }
  }
}
