// ignore_for_file: camel_case_types, avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class updateByPalletController {
  static Future<void> updateBin(
    List<String> oldBin,
    String newBin,
    String palletCode,
  ) async {
    String url =
        '${AppUrls.baseUrlWithPort}updateMappedBarcodesBinLocationByPalletCode';

    print("url : $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.tokenNew,
      "Host": AppUrls.host,
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "oldBinLocation": oldBin[0],
      "newBinLocation": newBin,
      "palletCode": palletCode
    });

    print("body : $body");

    try {
      var response = await http.put(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception("Failded to update bin");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
