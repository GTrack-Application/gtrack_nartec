// ignore_for_file: camel_case_types, avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Mapping/Sales_Order/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class updateByPalletController {
  static Future<void> updateBin(
    List<getMappedBarcodedsByItemCodeAndBinLocationModel> oldBin,
    String newBin,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        '${AppUrls.baseUrlWith7010}/api/updateMappedBarcodesBinLocationByPalletCode';

    print("url : $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Content-Type": "application/json",
    };

    var body = oldBin.map((element) {
      return {
        "oldBinLocation": element.binLocation,
        "newBinLocation": newBin,
        "palletCode": element.palletCode
      };
    });

    try {
      var response = await http.put(uri,
          headers: headers,
          body: jsonEncode({
            "records": [...body]
          }));

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
