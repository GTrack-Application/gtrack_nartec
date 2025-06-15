import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/global/utils/device_ip.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/image_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/ingredient_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/instruction_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/leaflet_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/nutrition_facts_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/packaging_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/promotional_offer_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/recipe_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/retailer_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/review_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/video_model.dart';
import 'package:http/http.dart' as http;

class GTINController {
  static final HttpService httpService = HttpService(baseUrl: AppUrls.gs1Url);
  static final HttpService gtrackService = HttpService(baseUrl: AppUrls.gtrack);
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
    String? searchQuery,
  }) async {
    final userId = await AppPreferences.getMemberId();

    String url = '/api/products/';

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url +=
          "searchProductsBySelectedFields?searchText=$searchQuery&page=$page&limit=$pageSize";
    } else {
      url +=
          "paginatedProducts?page=$page&pageSize=$pageSize&member_id=$userId";
    }

    final response = await gtrackService.request(url);

    if (response.success) {
      return PaginatedGTINResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load paginated products');
    }
  }

  static Future<List<AllergenModel>> getAllergenInformation(
    String gtin, {
    int page = 1,
    int limit = 100,
  }) async {
    final response = await upcHubService.request(
      '/api/digitalLinks/ingredients?barcode=$gtin&page=$page&pageSize=$limit',
      method: HttpMethod.get,
    );

    print(
        "Url: ${AppUrls.upcHub}/api/digitalLinks/ingredients?barcode=$gtin&page=$page&pageSize=$limit");

    if (response.success) {
      final data = response.data['ingredients'] as List;
      return data.map((e) => AllergenModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['error'] ??
          response.data['message'] ??
          'Failed to load allergens');
    }
  }

  static Future<RetailerResponse> getRetailerInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
      '/api/digitalLinks/retailers?page=$page&pageSize=$limit&barcode=$gtin',
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
      '/api/digitalLinks/ingredients?page=$page&pageSize=$limit&barcode=$gtin',
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
      '/api/digitalLinks/packagings?page=$page&pageSize=$limit&barcode=$gtin',
      method: HttpMethod.get,
    );

    final packagingResponse = PackagingResponse.fromJson(response.data);
    return packagingResponse;
  }

  static Future<PromotionalOfferResponse> getPromotionalOffers(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await gtrackService.request(
      '/api/getPromotionalOffersByGtin/$gtin',
      method: HttpMethod.get,
    );

    final promotionalResponse =
        PromotionalOfferResponse.fromJson(response.data);
    return promotionalResponse;
  }

  static Future<RecipeResponse> getRecipeInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await gtrackService.request(
      '/api/getRecipeDataByGtin/$gtin',
      method: HttpMethod.get,
    );

    final recipeResponse = RecipeResponse.fromJson(response.data);
    return recipeResponse;
  }

  static Future<LeafletResponse> getLeafletInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await gtrackService.request(
      '/api/getProductLeafLetsDataByGtin/$gtin',
      method: HttpMethod.get,
    );

    final leafletResponse = LeafletResponse.fromJson(response.data);
    return leafletResponse;
  }

  static Future<ImageResponse> getImageInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
        "/api/digitalLinks/images?page=$page&pageSize=$limit&barcode=$gtin");

    if (response.success) {
      return ImageResponse.fromJson(response.data);
    } else {
      throw Exception(response.data['error'] ??
          response.data['message'] ??
          'Failed to load images');
    }
  }

  static Future<InstructionResponse> getInstructionInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
        "/api/digitalLinks/instructions?page=$page&pageSize=$limit&barcode=$gtin");

    if (response.success) {
      return InstructionResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load instructions');
    }
  }

  static Future<VideoResponse> getVideoInformation(
    String gtin, {
    required int page,
    required int limit,
  }) async {
    final response = await upcHubService.request(
      "/api/digitalLinks/videos?page=$page&pageSize=$limit&barcode=$gtin",
      method: HttpMethod.get,
    );

    if (response.success) {
      return VideoResponse.fromJson(response.data);
    } else {
      throw Exception(response.data['error'] ??
          response.data['message'] ??
          'Failed to load videos');
    }
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
        getPromotionalOffers(gtin, page: page, limit: limit),
        getRecipeInformation(gtin, page: page, limit: limit),
        getLeafletInformation(gtin, page: page, limit: limit),
        getImageInformation(gtin, page: page, limit: limit),
        getInstructionInformation(gtin, page: page, limit: limit),
        getVideoInformation(gtin, page: page, limit: limit),
      ]);

      return {
        'allergens': responses[0],
        'retailers': responses[1],
        'ingredients': responses[2],
        'packagings': responses[3],
        'promotions': responses[4],
        'recipes': responses[5],
        'leaflets': responses[6],
        'images': responses[7],
        'instructions': responses[8],
        'videos': responses[9],
      };
    } catch (e) {
      throw Exception('Failed to fetch digital link data: $e');
    }
  }

  static Future<List<ReviewModel>> getReviews(String gtin) async {
    final response =
        await upcHubService.request('/api/productReview?ProductId=$gtin');

    if (response.success) {
      return (response.data as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Future<ReviewModel> postReview({
    required String barcode,
    required int rating,
    required String comment,
    required String productDescription,
    required String brandName,
  }) async {
    final userId = await AppPreferences.getMemberId();
    String deviceIp = await getLocalIP();

    final response = await upcHubService.request(
      '/api/productReview',
      method: HttpMethod.post,
      payload: {
        "LocationIP": deviceIp,
        "SenderId": userId,
        "rating": rating,
        "Comments": comment,
        "ProductId": barcode,
        "ProductDescription": productDescription,
        "BrandName": brandName,
        "GTIN": barcode,
        "gcpGLNID": barcode.substring(0, 7), // Taking first 7 chars as GCP
      },
    );

    if (response.success) {
      return ReviewModel.fromJson(response.data);
    } else {
      throw Exception('Failed to submit review');
    }
  }

  static Future<List<NutritionFactsModel>> fetchNutritionFacts(
      String barcode) async {
    final response = await upcHubService.request(
      '/api/digitalLinks/nutritionFacts?barcode=$barcode',
      method: HttpMethod.get,
    );

    if (response.success) {
      final data = json.decode(response.body);
      final List<dynamic> nutritionFactsJson = data['nutritionFacts'];
      return nutritionFactsJson
          .map((json) => NutritionFactsModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load nutrition facts');
    }
  }
}
