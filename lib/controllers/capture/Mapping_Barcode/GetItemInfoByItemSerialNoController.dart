// ignore_for_file: avoid_print, file_names

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class GetItemInfoByItemSerialNoController {
  static Future<int> getData(String itemserialno) async {
    String? tokenNew = await AppPreferences.getToken();

    String url = "${AppUrls.baseUrlWithPort}getItemInfoByItemSerialNo";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "itemserialno": itemserialno,
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
        int msg = response.statusCode;
        return msg;
      } else if (response.statusCode == 404) {
        print("Status Code: ${response.statusCode}");
        int msg = response.statusCode;
        return msg;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
