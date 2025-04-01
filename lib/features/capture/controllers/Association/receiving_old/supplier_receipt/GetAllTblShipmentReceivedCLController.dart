// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class GetAllTblShipmentReceivedCLController {
  static Future<int> getAllTableZone(
    String containerId,
    String shipmentId,
    String itemId,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7010}/api/getRemainingQtyFromShipmentCounter?CONTAINERID=$containerId&SHIPMENTID=$shipmentId&ITEMID=$itemId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var itemCount = data['itemCount'];
        return itemCount;
      } else {
        var itemCount = 0;
        return itemCount;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
