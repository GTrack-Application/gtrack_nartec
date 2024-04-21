// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemReAllocationTableDataController {
  static Future<List<GetItemInfoByPalletCodeModel>> getAllTable(
      String palletId) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWith7000}getItemInfoByPalletCode";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "palletcode": palletId,
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<GetItemInfoByPalletCodeModel> shipmentData =
            data.map((e) => GetItemInfoByPalletCodeModel.fromJson(e)).toList();
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
