// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class UpdateStockMasterDataController {
  static Future<void> insertShipmentData(
    String iTEMID,
    double length,
    double width,
    double height,
    double weight,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.gtrack}/api/updateStockMasterData";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var body = {
      "ITEMID": iTEMID,
      "Length": length,
      "Width": width,
      "Height": height,
      "Weight": weight
    };

    try {
      var response =
          await http.put(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
