// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/palletization/GetTransferDistributionByTransferIdModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetShipmentPalletizingController {
  static Future<List<GetTransferDistributionByTransferIdModel>>
      getShipmentPalletizing(String id) async {
    String url =
        "${AppUrls.baseUrlWithPort}getTransferDistributionByTransferId?TRANSFERID=$id";

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
        List<GetTransferDistributionByTransferIdModel> obj = data
            .map((json) =>
                GetTransferDistributionByTransferIdModel.fromJson(json))
            .toList();
        return obj;
      } else {
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception("$msg");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
