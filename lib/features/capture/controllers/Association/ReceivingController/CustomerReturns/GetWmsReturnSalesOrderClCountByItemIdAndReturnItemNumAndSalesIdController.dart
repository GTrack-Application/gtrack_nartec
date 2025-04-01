// ignore_for_file: camel_case_types, avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetWmsReturnSalesOrderClCountByItemIdAndReturnItemNumAndSalesIdController {
  static Future<int> getData(
    String itemId,
    String returnItemNum,
    String salesId,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7010}/api/getWmsReturnSalesOrderClCountByItemIdAndReturnItemNumAndSalesId";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var body = {
      "ITEMID": itemId,
      "RETURNITEMNUM": returnItemNum,
      "SALESID": salesId,
    };

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var returnItemsCount = data["returnItemsCount"];
        return returnItemsCount;
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
