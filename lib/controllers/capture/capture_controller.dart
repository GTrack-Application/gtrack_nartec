import 'dart:convert';
import 'dart:developer';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/products_model.dart';
import 'package:gtrack_mobile_app/models/capture/serialization/serialization_model.dart';
import 'package:http/http.dart' as http;

class CaptureController {
  Future<List<SerializationModel>> getSerializationData(gtin) async {
    String url =
        "${AppUrls.baseUrlWith7000}/api/getAllRecordsByGTIN?GTIN=$gtin";
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;

      List<SerializationModel> serializationData =
          data.map((e) => SerializationModel.fromJson(e)).toList();
      return serializationData;
    } else {
      var data = json.decode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  Future<String> createNewSerial({
    required String gtin,
    required int quantity,
    required String batchNumber,
    required String expiryDate,
    required String manufacturingDate,
  }) async {
    String url = "${AppUrls.baseUrlWith7000}/api/insertControlledSerials";
    final uri = Uri.parse(url);
    var body = jsonEncode({
      "GTIN": gtin,
      "qty": "$quantity",
      "BATCH": batchNumber,
      "EXPIRY_DATE": expiryDate,
      "MANUFACTURING_DATE": manufacturingDate,
    });

    log(body);
    var response = await http.post(uri, body: body, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    log(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);
      var msg = data['message'];
      return msg;
    } else {
      var data = json.decode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  Future<List<ProductsModel>> getProducts({String? gtin}) async {
    final userId = await AppPreferences.getUserId();
    final token = await AppPreferences.getToken();

    String url = gtin != null
        ? "${AppUrls.baseUrlWith3093}/api/products?user_id=$userId&barcode=$gtin"
        : "${AppUrls.baseUrlWith3093}/api/products?user_id=$userId";

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
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();

      return products;
    } else {
      return [];
    }
  }
}
