import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/identify/models/IDENTIFY/GIAI/giai_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GIAIController {
  static Future<List<GIAIModel>> getGIAI() async {
    final memberId = await AppPreferences.getMemberId();

    final url =
        "${AppUrls.baseUrlWith7010}/api/assetMasterEncoder?memberId=$memberId";

    final header = {
      "Authorization": "Bearer ${AppPreferences.getToken()}",
    };

    final response = await http.get(Uri.parse(url), headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body) as List;
      return data.map((e) => GIAIModel.fromJson(e)).toList();
    } else {
      var data = json.decode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<void> deleteGIAI(String id) async {
    final url = "${AppUrls.baseUrlWith7010}/api/assetMasterEncoder/$id";

    final header = {
      "Authorization": "Bearer ${AppPreferences.getToken()}",
    };

    final response = await http.delete(Uri.parse(url), headers: header);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      var data = json.decode(response.body);
      throw Exception(data['message']);
    }
  }
}
