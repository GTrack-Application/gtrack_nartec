// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/mapping_barcode/GetShipmentReceivedTableModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertAllDataController {
  static Future<void> postData(
    String BIN,
    String SELECTTYPE,
    List<GetShipmentReceivedTableModel> getItemInfoByPalletCodeModel,
    String TRANSFERID,
    int TRANSFERSTATUS,
    String INVENTLOCATIONIDFROM,
    String INVENTLOCATIONIDTO,
    String ITEMID,
    int QTYTRANSFER,
    int QTYRECEIVED,
    String CREATEDDATETIME,
    String GROUPID,
    String MainLocation,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWithPort}insertTblTransferBinToBinCL";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    final data = getItemInfoByPalletCodeModel.map(
      (e) {
        return {
          ...e.toJson(),
          "BinLocation": BIN,
          "MainLocation": MainLocation,
          "SELECTTYPE": SELECTTYPE,
          "TRANSFERID": TRANSFERID,
          "TRANSFERSTATUS": TRANSFERSTATUS,
          "INVENTLOCATIONIDFROM": INVENTLOCATIONIDFROM,
          "INVENTLOCATIONIDTO": INVENTLOCATIONIDTO,
          "ITEMID": ITEMID,
          "QTYTRANSFER": QTYTRANSFER,
          "QTYRECEIVED": QTYRECEIVED,
          "CREATEDDATETIME": CREATEDDATETIME,
          "GROUPID": GROUPID
        };
      },
    );

    print(jsonEncode([...data]));

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode([...data]));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data["message"];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
