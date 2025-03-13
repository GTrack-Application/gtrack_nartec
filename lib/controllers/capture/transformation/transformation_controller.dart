import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/transformation/event_station_model.dart';

class TransformationController {
  final HttpService http7010 = HttpService(baseUrl: AppUrls.baseUrlWith7010);

  /* 
  ########################################################################## 
    EVENT STATION START
  ##########################################################################
  */

  Future<List<EventStation>> getEventStations() async {
    final memberId = await AppPreferences.getMemberId();

    final url =
        "/api/eventStation/stations?association=true&created_by=$memberId";

    final response = await http7010.request(url);

    if (response.success) {
      final responseJson = response.data;
      final eventStationResponse = EventStationResponse.fromJson(responseJson);
      return eventStationResponse.data;
    } else {
      throw Exception(response.message);
    }
  }

  Future<List<StationAttributeMaster>> getStationAttributes(
      String eventStationId) async {
    final url =
        "/api/stationAttribute/inUsed/master?eventStationId=$eventStationId";

    final response = await http7010.request(url);

    if (response.success) {
      final responseJson = response.data;
      final stationAttributeResponse =
          StationAttributeResponse.fromJson(responseJson);
      return stationAttributeResponse.data;
    } else {
      throw Exception(response.message);
    }
  }

  Future<dynamic> saveStationAttributeHistory(Map<String, dynamic> formValues,
      Map<String, List<String>> arrayValues) async {
    final url = "/api/stationAttribute/history";

    // Combine regular form values with array values into a single payload
    final Map<String, dynamic> payload = {...formValues};

    // Add all array values to the payload
    arrayValues.forEach((fieldName, items) {
      payload[fieldName] = items;
    });

    final response = await http7010.request(
      url,
      method: HttpMethod.post,
      payload: payload,
    );

    if (response.success) {
      return response.data;
    } else {
      throw Exception(response.message);
    }
  }

  Future<void> saveTransaction(
      String eventStationId, EventStation station) async {
    final url = "/api/eventStation/saveTransaction";

    final response = await http7010.request(
      url,
      method: HttpMethod.post,
    );

    if (response.success) {
      return response.data;
    } else {
      throw Exception(response.message);
    }
  }

  /*
  ##########################################################################
    EVENT STATION END
  ##########################################################################
  */
}
