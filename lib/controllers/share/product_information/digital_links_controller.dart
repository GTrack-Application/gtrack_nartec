import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/product_information/digital_links_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/product_contents_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/promotional_offer_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/recipe_model.dart';
import 'package:gtrack_mobile_app/models/share/product_information/safety_information_model.dart';
import 'package:http/http.dart' as http;

class DigitalLinksController {
  Future<dynamic> getDigitalLinksData(String screen, String gtin) async {
    final url =
        "${AppUrls.baseUrl}/api/digitalLinks?identificationKeyType=gtin&identificationKey=$gtin,";
    final token = await AppPreferences.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{"authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var digitalLinksModel = DigitalLinksModel.fromJson(
        jsonDecode(response.body),
      );
      if (digitalLinksModel.success == true) {
        var responses = digitalLinksModel.data?[0].responses;
        switch (screen) {
          case "promotional-offers":
            List<PromotionalOfferModel> models = [];
            var data = responses
                ?.where(
                  (element) => element.linkType == 'gs1:hasRetailers',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(PromotionalOfferModel.fromJson(i));
            });
            return models;
          case "safety-information":
            List<SafetyInfromationModel> models = [];
            var data = responses
                ?.where(
                  (element) =>
                      element.linkType == 'gs1:productSustainabilityInfo',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(SafetyInfromationModel.fromJson(i));
            });
            return models;
          case "product-contents":
            List<ProductContentsModel> models = [];
            var data = responses
                ?.where(
                  (element) => element.linkType == 'gs1:pip',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(ProductContentsModel.fromJson(i));
            });
            return models;

          case "product-recall":
            List<SafetyInfromationModel> models = [];
            var data = responses
                ?.where(
                  (element) =>
                      element.linkType == 'gs1:productSustainabilityInfo',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(SafetyInfromationModel.fromJson(i));
            });
            return models;
          case "recipe":
            List<RecipeModel> models = [];
            var data = responses
                ?.where(
                  (element) => element.linkType == 'gs1:recipeInfo',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(RecipeModel.fromJson(i));
            });
            return models;
          case "packaging-composition":
            List<ProductContentsModel> models = [];
            var data = responses
                ?.where(
                  (element) => element.linkType == 'gs1:pip',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(ProductContentsModel.fromJson(i));
            });
            return models;
          case "electronic-leaflets":
            List<ProductContentsModel> models = [];
            var data = responses
                ?.where(
                  (element) => element.linkType == 'gs1:pip',
                )
                .map((e) => e.toJson())
                .toList();
            data?.forEach((i) {
              models.add(ProductContentsModel.fromJson(i));
            });
            return models;
        }
      }
    } else {
      throw Exception("Internal server error!");
    }
  }
}
