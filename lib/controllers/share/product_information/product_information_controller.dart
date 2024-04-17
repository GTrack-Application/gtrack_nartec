import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/product_information/leaflets_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/location_origin_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/packaging_composition_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/product_contents_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/product_recall_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/promotional_offer_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/recipe_model.dart';
import 'package:http/http.dart' as http;

class ProductInformationController {
  static Future<List<PromotionalOfferModel>> getPromotionalOffer(
      String gtin) async {
    List<PromotionalOfferModel> promotionalOffers = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getPromotionalOffersByGtin/$gtin'));
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          promotionalOffers.add(PromotionalOfferModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return promotionalOffers;
  }

  static Future<List<ProductContentsModel>> getProductContents(
      String gtin) async {
    List<ProductContentsModel> productContents = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getProductContentByGtin/$gtin'));
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          productContents.add(ProductContentsModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return productContents;
  }

  // product location of origin
  static Future<List<LocationOriginModel>> getProductLocationOrigin(
      String gtin) async {
    List<LocationOriginModel> productLocationOrigin = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getProductLocationOriginByGtin/$gtin'));
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          productLocationOrigin.add(LocationOriginModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return productLocationOrigin;
  }

  // product recall
  static Future<List<ProductRecallModel>> getProductRecallByGtin(
      String gtin) async {
    List<ProductRecallModel> productRecall = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getProductLocationOriginByGtin/$gtin'));
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          productRecall.add(ProductRecallModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return productRecall;
  }

  // Recipe
  static Future<List<RecipeModel>> getRecipeByGtin(String gtin) async {
    List<RecipeModel> recipe = [];
    try {
      var response = await http.get(
          Uri.parse('${AppUrls.baseUrlWithPort}/getRecipeDataByGtin/$gtin'));
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          recipe.add(RecipeModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return recipe;
  }

  // Packaging composition
  static Future<List<PackagingCompositionModel>> getPackagingCompositionByGtin(
      String gtin) async {
    List<PackagingCompositionModel> packagingCompositionModel = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getAlltblPkgCompositionDataByGtin/$gtin'));
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          packagingCompositionModel
              .add(PackagingCompositionModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return packagingCompositionModel;
  }

  // Leaflets
  static Future<List<LeafletsModel>> getLeafletsByGtin(String gtin) async {
    List<LeafletsModel> leafletsModel = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getProductLeafLetsDataByGtin/$gtin'));
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          leafletsModel.add(LeafletsModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return leafletsModel;
  }
}
