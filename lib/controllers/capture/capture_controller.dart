import 'dart:convert';
import 'dart:developer';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/gtin_model.dart';
import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';
import 'package:http/http.dart' as http;

class CaptureController {
  Future<List<SerializationModel>> getSerializationData(gtin) async {
    String url =
        "${AppUrls.baseUrlWith7010}/api/getAllRecordsByGTIN?GTIN=$gtin";
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
    String url = "${AppUrls.baseUrlWith7010}/api/insertControlledSerials";
    final uri = Uri.parse(url);
    var body = jsonEncode({
      "GTIN": gtin,
      "qty": "$quantity",
      "BATCH": batchNumber,
      "EXPIRY_DATE": expiryDate,
      "MANUFACTURING_DATE": manufacturingDate
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

  Future<List<GTINModell>> getProducts({String? gtin}) async {
    final token = await AppPreferences.getToken();

    String url =
        "${AppUrls.baseUrlWith7010}/api/getAllRecordsByGTIN?GTIN=${gtin!}";

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body)['data'] as List;
      var products = data.map((e) => GTINModell.fromJson(e)).toList();
      return products;
    } else {
      var data = json.decode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }
}
