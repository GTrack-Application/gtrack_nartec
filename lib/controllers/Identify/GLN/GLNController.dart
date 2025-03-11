// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/models/identify/GLN/gln_model.dart';
import 'package:http/http.dart' as http;

class GLNController {
  static HttpService httpService = HttpService(baseUrl: AppUrls.gs1Url);

  static Future<List<PackedItemsModel>> getData() async {
    String? token = await AppPreferences.getToken();
    String url = "${AppUrls.baseUrlWith7010}/api/getAllPackedItems";

    log(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    var data = response.body as List;

    print(json.decode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<PackedItemsModel> products = data
          .map((e) => PackedItemsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return products;
    } else {
      return [];
    }
  }

  static Future<void> deleteData(String id) async {
    String? token = await AppPreferences.getToken();
    String url = "${AppUrls.baseUrlWith3093}/api/gln/$id";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      var data = json.decode(response.body);
      throw data['error'];
    }
  }

  static Future<List<GlnModel>> getGlnData() async {
    String? userId = await AppPreferences.getGs1UserId();
    String url = "api/gln?user_id=$userId";

    final response = await httpService.request(url);

    if (response.success) {
      var data = response.data as List;
      List<GlnModel> glnList = data.map((e) => GlnModel.fromJson(e)).toList();
      return glnList;
    } else {
      return [];
    }
  }

  static Future<void> deleteGlnV2(String id) async {
    String? token = await AppPreferences.getToken();
    String url = "${AppUrls.baseUrlWith3093}/api/gln/$id";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      var data = json.decode(response.body);
      throw data['error'];
    }
  }
}
