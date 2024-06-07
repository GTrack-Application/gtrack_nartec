import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/item_details/asset_details_model.dart';
import 'package:http/http.dart' as http;

class ItemDetailsController {
  void saveItemDetails({List<AssetDetailsModel>? assets}) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    const url = "${AppUrls.baseUrlWith7000}/api/getReceivingTypes";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
    };

    var body;
    if (assets != null && assets.isNotEmpty) {
      body = {
        "userId": userId,
        "typeOfTransaction": "Purchase",
        "glnIdFrom": "GLN12345",
        "glnIdTo": "GLN67890",
        "refNum": "REF123456789",
        "transpoGLN": "TRANSGLN123",
        // "status": "Pending",
        "details": {
          "GTIN": "GTIN1234567890",
          "ProductNameEn": "Product 1",
          "ProductNameAr": "منتج 1",
          "BrandName": "Brand A",
          "Batch": "Batch001",
          "NetWeight": 10.5,
          "UnitOfMeasure": "kg",
          "Quantity": 100,
          "SSCC": "",
          "ManufacturingDate": "2024-01-01T00:00:00Z",
          "ExpiryDate": "2025-01-01T00:00:00Z",
          "TranspoGLN": "TRANSGLN123"
        },
        "assets": assets
            .map((asset) => {
                  "AssetIdNo": asset.assetId,
                  "TagNo": asset.tagNo,
                  "AssetDescription": asset.description,
                  "AssetClass": asset.assetClass,
                  "AssetGLNLocation": asset.location
                })
            .toList()
      };
    } else {
      body = {
        "userId": userId,
        "typeOfTransaction": "Purchase",
        "glnIdFrom": "GLN12345",
        "glnIdTo": "GLN67890",
        "refNum": "REF123456789",
        "transpoGLN": "TRANSGLN123",
        "status": "Picked",
        /* Picked, Partial Picked */
        "details": {
          "GTIN": "GTIN1234567890",
          "ProductNameEn": "Product 1",
          "ProductNameAr": "منتج 1",
          "BrandName": "Brand A",
          "Batch": "Batch001",
          "NetWeight": 10.5,
          "UnitOfMeasure": "kg",
          "Quantity": 100,
          "SSCC": "",
          "ManufacturingDate": "2024-01-01T00:00:00Z",
          "ExpiryDate": "2025-01-01T00:00:00Z",
          "TranspoGLN": "TRANSGLN123"
        }
      };
    }

    var response = await http.post(uri, body: body, headers: headers);

    if (response.statusCode == 200) {
    } else {
      throw Exception(jsonDecode(response.body)["error"]);
    }
  }
}
