import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/ReceivingModel/CustomerReturns/GetAllTblRZonesModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReturnDZones {
  static Future<List<GetAllTblRZonesModel>> getData() async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWith7000}/api/getAllTblRZones";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
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
