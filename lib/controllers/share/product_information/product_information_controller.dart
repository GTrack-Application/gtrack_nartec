import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/product_information/promotional_offer_model.dart';
import 'package:http/http.dart' as http;

class ProductInformationController {
  static Future<List<PromotionalOfferModel>> getPromotionalOffer(
      String gtin) async {
    List<PromotionalOfferModel> safetyInfromations = [];
    try {
      var response = await http.get(Uri.parse(
          '${AppUrls.baseUrlWithPort}/getPromotionalOffersByGtin/$gtin'));
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        responseBody.forEach((data) {
          safetyInfromations.add(PromotionalOfferModel.fromJson(data));
        });
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
    return safetyInfromations;
  }
}
