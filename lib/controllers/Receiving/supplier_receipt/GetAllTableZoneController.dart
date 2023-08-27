// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/GetAllTableZoneModel.dart';
import 'package:http/http.dart' as http;

class GetAllTableZoneController {
  static Future<List<GetAllTableZoneModel>> getAllTableZone() async {
    String? tokenNew = await AppPreferences.getToken();

    String url = "${AppUrls.baseUrlWithPort}getAllTblRZones";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    print(headers);

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<GetAllTableZoneModel> shipmentData =
            data.map((e) => GetAllTableZoneModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
