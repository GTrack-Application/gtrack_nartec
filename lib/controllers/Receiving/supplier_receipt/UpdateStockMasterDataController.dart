// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class UpdateStockMasterDataController {
  static Future<void> insertShipmentData(
    String iTEMID,
    double length,
    double width,
    double height,
    double weight,
  ) async {
    String url = "${AppUrls.base}updateStockMasterData";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var body = {
      "ITEMID": iTEMID,
      "Length": length,
      "Width": width,
      "Height": height,
      "Weight": weight,
    };

    print(jsonEncode(body));
    print("url: $url");

    try {
      var response =
          await http.put(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
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
