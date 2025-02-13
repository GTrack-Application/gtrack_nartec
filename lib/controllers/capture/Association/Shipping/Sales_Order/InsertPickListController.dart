// ignore_for_file: avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertPickListController {
  static Future<void> insertData(
    List<Map<String, dynamic>> data,
    String pICKINGROUTEID,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7000}/api/insertIntoPackingSlipTableClAndUpdateWmsSalesPickingListCl?PICKINGROUTEID=$pICKINGROUTEID";

    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    var body = json.encode([...data]);

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);
        print(data);
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        print(data);
        String msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
