// ignore_for_file: file_names, avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidateShipmentPalettizingSerialNoController {
  static Future<String> palletizeSerialNo(
    String serialNo,
    String shipmentId,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7010}/api/vaildatehipmentPalletizingSerialNumber?ItemSerialNo=$serialNo&SHIPMENTID=$shipmentId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        String palletizeSerialNo = data["message"];
        return palletizeSerialNo;
      } else {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        String msg = data["message"];

        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
