// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Transfer/WipToFG/get_items_ln_wips_model.dart';
import 'package:http/http.dart' as http;

class WIPToFgController {
  static Future<List<GetItemsLnWipsModel>> getItems() async {
    String? token;
    await AppPreferences.getToken().then((value) => token = value);

    const endPoint = "${AppUrls.baseUrlWith7000}/api/getItemsLnWIPs";

    List<GetItemsLnWipsModel> items = [];

    final headers = <String, String>{
      'Authorization': '$token',
      'Host': AppUrls.host,
    };

    final response = await http.get(Uri.parse(endPoint), headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var item in data) {
        items.add(GetItemsLnWipsModel.fromJson(item));
      }
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<void> insertManyIntoMappedBarcode(List records) async {
    const endPoint =
        "${AppUrls.baseUrlWith7000}/api/insertManyIntoMappedBarcode";

    String? token;
    await AppPreferences.getToken().then((value) => token = value);
    try {
      final response = await http.post(Uri.parse(endPoint),
          body: jsonEncode({"records": records}),
          headers: {
            "Authorization": "$token",
            "Content-Type": "application/json",
            "Host": AppUrls.host,
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        print("status code: ${response.statusCode}");
      } else {
        var data = jsonDecode(response.body);
        print("status code: ${response.statusCode}");

        var msg = data["message"];
        throw Exception(msg);
      }
    } catch (error) {
      rethrow;
    }
  }
}
