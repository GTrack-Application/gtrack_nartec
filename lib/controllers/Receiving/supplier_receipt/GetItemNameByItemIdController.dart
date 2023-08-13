// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/BinToBinInternalModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetItemNameByItemIdController {
  static Future<List<BinToBinInternalModel>> getName(String itemId) async {
    String url = "${AppUrls.base}getOneMapBarcodeDataByItemCode";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "itemcode": itemId,
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body) as List;
        List<BinToBinInternalModel> allData =
            data.map((e) => BinToBinInternalModel.fromJson(e)).toList();
        return allData;
      } else {
        throw Exception("No Data Found");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
