// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/palletization/GetAllTblLocationsCLModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetMapBarcodeDataByItemCodeController {
  static Future<List<GetAllTblLocationsCLModel>> getData() async {
    String url = "${AppUrls.baseUrlWithPort}getAllTblLocationsCL";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.tokenNew,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<GetAllTblLocationsCLModel> shipmentData =
            data.map((e) => GetAllTblLocationsCLModel.fromJson(e)).toList();
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
