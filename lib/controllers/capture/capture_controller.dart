import 'dart:convert';
import 'dart:developer';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/serialization/serialization_model.dart';
import 'package:http/http.dart' as http;

class CaptureController {
  Future<List<SerializationModel>> getSerializationData(gtin) async {
    String url = "${AppUrls.baseUrlWith7000}/getAllRecordsByGTIN?GTIN=$gtin";
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
    String url = "${AppUrls.baseUrlWith7000}/insertControlledSerials";
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
}
