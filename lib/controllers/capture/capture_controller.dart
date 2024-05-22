import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/serialization/serialization_model.dart';
import 'package:http/http.dart' as http;

class CaptureController {
  Future<List<SerializationModel>> getSerializationData(gtin) async {
    String url = "${AppUrls.baseUrlWith7000}/getAllRecordsByGTIN?GTIN=$gtin";
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;

      List<SerializationModel> serializationData =
          data.map((e) => SerializationModel.fromJson(e)).toList();
      return serializationData;
    } else {
      var data = json.decode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }
}
