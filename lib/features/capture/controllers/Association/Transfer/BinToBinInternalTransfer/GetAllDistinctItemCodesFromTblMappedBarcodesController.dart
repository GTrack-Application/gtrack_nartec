// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllDistinctItemCodesFromTblMappedBarcodesController {
  static Future<List<String>> getAllTable() async {
    String url =
        "${AppUrls.baseUrlWith7010}/api/getAllDistinctItemCodesFromTblMappedBarcodes";
    print("url: $url");

    final uri = Uri.parse(url);

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        //     {
        //     "ItemCode": "CV-9800YJ 220 BR"
        //     }

        var data = json.decode(response.body) as List;
        List<String> shipmentData =
            data.map((e) => e["ItemCode"].toString()).toList();
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
