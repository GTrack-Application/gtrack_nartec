// ignore_for_file: camel_case_types, avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/mapping_barcode/getInventTableWMSDataByItemIdOrItemNameModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class getAllTblMappedBarcodesController {
  static Future<List<getInventTableWMSDataByItemIdOrItemNameModel>> getData(
      String searchText) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7010}/api/getInventTableWMSDataByItemIdOrItemName";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "serachtext": searchText,
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<getInventTableWMSDataByItemIdOrItemNameModel> shipmentData = data
            .map(
                (e) => getInventTableWMSDataByItemIdOrItemNameModel.fromJson(e))
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
