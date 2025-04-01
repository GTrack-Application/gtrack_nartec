// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/reveiving/supplier_receipt/GetAllTableZoneModel.dart'
    show GetAllTableZoneModel;
import 'package:http/http.dart' as http;

class GetAllTableZoneController {
  static Future<List<GetAllTableZoneModel>> getAllTableZone() async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWith7010}/api/getAllTblRZones";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
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
