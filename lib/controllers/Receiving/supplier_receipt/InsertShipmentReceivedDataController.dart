// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class InsertShipmentReceivedDataController {
  static Future<void> insertShipmentData(
    String sHIPMENTID,
    String cONTAINERID,
    String aRRIVALWAREHOUSE,
    String iTEMNAME,
    String iTEMID,
    String pURCHID,
    String cLASSIFICATION,
    String serialNum,
    String RCVDCONFIGID,
    String rcvdDate,
    String GTIN,
    String RZONE,
    String palletDate,
    String PALLETCODE,
    String BIN,
    String REMARKS,
    int POQTY,
    double length,
    double width,
    double height,
    double weight,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWith7000}/api/insertShipmentRecievedDataCL";

    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "SHIPMENTID": sHIPMENTID,
      "CONTAINERID": cONTAINERID,
      "ARRIVALWAREHOUSE": aRRIVALWAREHOUSE,
      "ITEMNAME": iTEMID,
      "ITEMID": iTEMID,
      "PURCHID": pURCHID,
      "CLASSIFICATION": cLASSIFICATION,
      "SERIALNUM": serialNum,
      "RCVDCONFIGID": RCVDCONFIGID,
      "RCVD_DATE": rcvdDate,
      "GTIN": GTIN,
      "RZONE": RZONE,
      "PALLET_DATE": palletDate,
      "PALLETCODE": PALLETCODE,
      "BIN": BIN,
      "REMARKS": REMARKS,
      "POQTY": POQTY,
      "LENGTH": length,
      "WIDTH": width,
      "HEIGHT": height,
      "WEIGHT": weight
    });

    print(body);

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
