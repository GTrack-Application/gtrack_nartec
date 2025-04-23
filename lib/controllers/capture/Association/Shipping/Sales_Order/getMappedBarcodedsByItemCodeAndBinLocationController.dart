// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/Mapping/Sales_Order/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';
import 'package:http/http.dart' as http;

class getMappedBarcodedsByItemCodeAndBinLocationController {
  static Future<List<getMappedBarcodedsByItemCodeAndBinLocationModel>> getData(
    String itemCode,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.gtrack}/api/getmapBarcodeDataByItemCode";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "itemcode": itemCode,
      "binlocation": "",
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<getMappedBarcodedsByItemCodeAndBinLocationModel> shipmentData =
            data
                .map((e) =>
                    getMappedBarcodedsByItemCodeAndBinLocationModel.fromJson(e))
                .toList();
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
