// ignore_for_file: file_names

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/GetTblStockMasterByItemIdModel.dart';
import 'package:http/http.dart' as http;

class GetTblStockMasterByItemIdController {
  static Future<List<GetTblStockMasterByItemIdModel>> getData(
      String itemId) async {
    String url = "${AppUrls.base}getTblStockMasterByItemId?itemid=$itemId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<GetTblStockMasterByItemIdModel> shipmentData = data
            .map((e) => GetTblStockMasterByItemIdModel.fromJson(e))
            .toList();
        return shipmentData;
      } else {
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
