import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Transfer/WipToFG/get_items_ln_wips_model.dart';
import 'package:http/http.dart' as http;

class WIPToFgController {
  static Future<List<GetItemsLnWipsModel>> getItems() async {
    const endPoint = "${AppUrls.baseUrlWithPort}/getItemsLnWIPs";
    List<GetItemsLnWipsModel> items = [];
    final response = await http.get(Uri.parse(endPoint));
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
    const endPoint = "${AppUrls.baseUrlWithPort}insertManyIntoMappedBarcode";
    String? token;
    AppPreferences.getToken().then((value) {
      token = value;
    });
    try {
      final response = await http.post(Uri.parse(endPoint),
          body: jsonEncode({"records": records}),
          headers: {
            "Content-Type": "application/json",
            "Host": AppUrls.host,
            "Authorization": "Bearer $token",
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        var data = jsonDecode(response.body);
        var msg = data["message"];
        throw Exception(msg);
      }
    } catch (error) {
      rethrow;
    }
  }
}
