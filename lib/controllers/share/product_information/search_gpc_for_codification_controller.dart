import 'dart:developer';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/product_information/SearchGpcForCodification.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchGpcForCodificationController {
  static Future<SearchGpcForCodification> searchGpcForCodification(
      String gpc) async {
    final url = "${AppUrls.baseUrl}api/gpc/searchGpcForCodification?gpc=$gpc";
    final uri = Uri.parse(url);

    final token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Host': AppUrls.host,
      'authorization': 'Bearer $token',
    };

    final response = await http.get(uri, headers: headers);

    var data = json.decode(response.body)['data'];

    if (response.statusCode == 200) {
      return SearchGpcForCodification.fromJson(data);
    } else {
      var data = json.decode(response.body)['message'];
      throw Exception(data);
    }
  }

  static Future<List<dynamic>> findSimilarRecords(String gcpName) async {
    final url =
        "${AppUrls.vectorEmbeddingUrl}api/findSimilarRecords?text=$gcpName&tableName=hs_codes";
    final uri = Uri.parse(url);

    // final token = await AppPreferences.getToken();

    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.get(uri, headers: headers);

    var data = json.decode(response.body)[0] as List;

    if (response.statusCode == 200) {
      // return the list of similar records
      return data;
    } else {
      var data = json.decode(response.body)['message'];
      throw Exception(data);
    }
  }
}
