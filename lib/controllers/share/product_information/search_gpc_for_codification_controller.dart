import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/share/product_information/SearchGpcForCodification.dart';
import 'package:http/http.dart' as http;

class SearchGpcForCodificationController {
  static Future<SearchGpcForCodification> searchGpcForCodification(
    String gpc,
  ) async {
    final url =
        "${AppUrls.baseUrlWith3093}api/gpc/searchGpcForCodification?gpc=$gpc";
    final uri = Uri.parse(url);

    final token = await AppPreferences.getToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
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

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      // return the list of similar records
      return data;
    } else {
      var data = json.decode(response.body)['message'];
      throw Exception(data);
    }
  }
}
