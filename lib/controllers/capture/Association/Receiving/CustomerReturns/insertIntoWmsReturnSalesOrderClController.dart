// ignore_for_file: avoid_print, camel_case_types, depend_on_referenced_packages

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/ReceivingModel/CustomerReturns/GetWmsReturnSalesOrderByReturnItemNum2Model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class insertIntoWmsReturnSalesOrderClController {
  static Future<void> getData(
    List<getWmsReturnSalesOrderByReturnItemNum2Model> table,
  ) async {
    String? tokenNew = await AppPreferences.getToken();

    String url = "${AppUrls.baseUrlWithPort}insertIntoWmsReturnSalesOrderCl";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    var body = table.map((e) {
      return {
        ...e.toJson(),
        "ITEMSERIALNO": e.itemSerialNo,
      };
    }).toList();

    print("body: ${jsonEncode([body])}");

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
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
