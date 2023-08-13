// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllTblShipmentReceivedCLController {
  static Future<int> getAllTableZone(
    String containerId,
    String shipmentId,
    String itemId,
  ) async {
    print("CONTAINERID: $containerId");
    print("SHIPMENTID: $shipmentId");
    print("ITEMID: $itemId");

    String url =
        "${AppUrls.base}getRemainingQtyFromShipmentCounter?CONTAINERID=$containerId&SHIPMENTID=$shipmentId&ITEMID=$itemId";

    print("URL: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        var itemCount = data['itemCount'];
        return itemCount;
      } else {
        print("Status Code: ${response.statusCode}");
        var itemCount = 0;
        return itemCount;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
