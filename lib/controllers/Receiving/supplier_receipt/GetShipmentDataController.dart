// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/DummyModel.dart';
import 'package:http/http.dart' as http;

class GetShipmentDataController {
  static Future<List<DummyModel>> getShipmentData(String id) async {
    String url =
        "${AppUrls.base}getShipmentDataFromtShipmentReceiving?SHIPMENTID=$id";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<DummyModel> shipmentData =
            data.map((e) => DummyModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        var data = json.decode(response.body);
        var message = data['message'];
        throw Exception(message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
