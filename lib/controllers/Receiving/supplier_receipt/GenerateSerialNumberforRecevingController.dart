import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateSerialNumberforRecevingController {
  static Future<String> generateSerialNo(String itemId) async {
    String url = "${AppUrls.base}generateSerialNumberforReceving";

    final body = {
      "ITEMID": itemId,
    };

    print("URL: $url");
    print("Body: $body");

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        var data = json.decode(response.body);
        var serialNo = data['SERIALNO'];
        return serialNo;
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception();
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
