// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/aggregation/palletization/GetAlltblBinLocationsModel.dart';
import 'package:http/http.dart' as http;

class GetAlltblBinLocationsController {
  static Future<List<GetAlltblBinLocationsModel>>
      getShipmentPalletizing() async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.gtrack}/api/getAlltblPalletMaster";

    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<GetAlltblBinLocationsModel> shipmentPalletizing =
            data.map((e) => GetAlltblBinLocationsModel.fromJson(e)).toList();
        return shipmentPalletizing;
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
