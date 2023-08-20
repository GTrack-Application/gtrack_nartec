// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/mapping_barcode/GetShipmentReceivedTableModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetSerialTableController {
  static Future<List<GetShipmentReceivedTableModel>> getAllTable(
      String serialNo) async {
    String url = "${AppUrls.baseUrlWithPort}getItemInfoByItemSerialNo";

    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.tokenNew,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "itemserialno": serialNo
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<GetShipmentReceivedTableModel> shipmentData =
            data.map((e) => GetShipmentReceivedTableModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
