// ignore_for_file: file_names, avoid_print

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidateShipmentIdFromShipmentReveivedClController {
  static Future<bool> palletizeSerialNo(String shipmentId) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7000}validateShipmentIdFromShipmentReceivedCl?SHIPMENTID=$shipmentId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        print("Response: $data");
        return true;
      } else {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        print("Error: $data");
        return false;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
