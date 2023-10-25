// generateBarcodeForRma

// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateBarcodeForRmaController {
  static Future<String> getData(
    String RETURNITEMNUM,
    String ITEMID,
    String MODELNO,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWithPort}generateBarcodeForRma";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    var body = {
      "RETURNITEMNUM": RETURNITEMNUM,
      "ITEMID": ITEMID,
      "MODELNO": MODELNO
    };

    print("Body: $body");

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data['RMASERIALNO'];
        return msg;
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data['RMASERIALNO'];
        return msg;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
