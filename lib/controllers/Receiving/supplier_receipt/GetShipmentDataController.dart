// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/reveiving/supplier_receipt/GetShipmentDataFromShipmentExpectedRModel.dart';
import 'package:http/http.dart' as http;

class GetShipmentDataController {
  static Future<List<GetShipmentDataFromShipmentExpectedRModel>>
      getShipmentData(String id) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7000}/api/getShipmentDataFromShipmentExpectedR?SHIPMENTID=$id";

    print(url);

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<GetShipmentDataFromShipmentExpectedRModel> shipmentData = data
            .map((e) => GetShipmentDataFromShipmentExpectedRModel.fromJson(e))
            .toList();
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
