// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/DummyModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetShipmentDataController {
  static Future<List<DummyModel>> getShipmentData(String id) async {
    String url =
        "${AppUrls.base}getShipmentDataFromtShipmentReceiving?SHIPMENTID=$id";

    print("URL: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<DummyModel> shipmentData =
            data.map((e) => DummyModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var message = data['message'];
        throw Exception(message);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
