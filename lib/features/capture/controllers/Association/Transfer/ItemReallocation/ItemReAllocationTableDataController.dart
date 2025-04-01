// ignore_for_file: avoid_print

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/features/capture/models/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';

class ItemReAllocationTableDataController {
  static Future<List<GetItemInfoByPalletCodeModel>> getAllTable(
      String palletId) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
      "palletcode": palletId,
    };

    try {
      final response = await HttpService().request(
        "/api/getItemInfoByPalletCode",
        method: HttpMethod.post,
        headers: headers,
      );

      if (response.success) {
        print("Status Code: ${response.statusCode}");

        var data = response.data as List;
        List<GetItemInfoByPalletCodeModel> shipmentData =
            data.map((e) => GetItemInfoByPalletCodeModel.fromJson(e)).toList();
        return shipmentData;
      } else {
        print("Status Code: ${response.statusCode}");
        var data = response.data;
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
