import 'dart:convert';

import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/share/product_information/events_screen_model.dart';
import 'package:http/http.dart' as http;

class EventsScreenController {
  static Future<List<EventsScreenModel>> getEventsData(String gtin) async {
    List<EventsScreenModel> events = [];

    final url = Uri.parse(
        "${AppUrls.domain}/api/search/event/gtin/with/maps?gtin=$gtin");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(response.body)['gtinInformation'] as List<dynamic>;
        for (var element in responseData) {
          events.add(EventsScreenModel.fromJson(element));
        }
      } else {
        return events;
      }
    } catch (error) {
      rethrow;
    }

    return events;
  }
}
