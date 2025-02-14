// ignore_for_file: avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubmitItemReallocateControllerimport {
  static Future<void> postData(
    List<GetItemInfoByPalletCodeModel> getItemInfoByPalletCodeModel,
    String availablePallet,
    String serialnum,
    String selectType,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url = "${AppUrls.baseUrlWith7010}/api/manageItemsReallocation";
    print("url: $url");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    final data = getItemInfoByPalletCodeModel.map(
      (e) {
        return {
          ...e.toJson(),
          "serialNumber": serialnum,
          "selectionType": selectType,
        };
      },
    );

    print(jsonEncode([...data]));

    final body = {
      "availablePallet": availablePallet,
      "serialNumber": serialnum,
      "selectionType": selectType
    };

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      // await http.post(uri, headers: headers, body: jsonEncode([...data]));

      if (response.statusCode == 200) {
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
