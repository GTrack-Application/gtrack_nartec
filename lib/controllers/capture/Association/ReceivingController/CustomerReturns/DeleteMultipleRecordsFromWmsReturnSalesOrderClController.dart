// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteMultipleRecordsFromWmsReturnSalesOrderClController {
  static Future<void> getData(
    List<String> serialNo,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7000}deleteMultipleRecordsFromWmsReturnSalesOrderCl";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    var body = serialNo;

    print("body: ${jsonEncode(body)}");

    try {
      var response =
          await http.delete(uri, headers: headers, body: jsonEncode(body));

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
