// ignore_for_file: avoid_print

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Mapping/BinToBinAxapta/GetAxaptaTableModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAxaptaTableDataController {
  static Future<List<GetAxaptaTableDataModel>> getAllTable(
      String transferID) async {
    String url =
        "${AppUrls.baseUrlWithPort}getExpectedTransferOrderByTransferId?TRANSFERID=$transferID";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.tokenNew,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body) as List;
        List<GetAxaptaTableDataModel> shipmentData =
            data.map((e) => GetAxaptaTableDataModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
