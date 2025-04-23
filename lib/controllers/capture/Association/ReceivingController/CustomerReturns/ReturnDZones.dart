import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/ReceivingModel/CustomerReturns/GetAllTblRZonesModel.dart';
import 'package:http/http.dart' as http;

class ReturnDZones {
  static Future<List<GetAllTblRZonesModel>> getData() async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.gtrack}/api/getAllTblRZones";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<GetAllTblRZonesModel> shipmentData =
            data.map((e) => GetAllTblRZonesModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
