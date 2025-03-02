// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/brand_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/category_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/city_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/country_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/employee_name_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/generate_tag_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/state_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/tag_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/send_barcode_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class FatsController {
  static Future<List<CountryModel>> getContries() async {
    final url = '${AppUrls.baseUrlWith7010}/api/countries';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => CountryModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // /api/states?country_id=12'
  static Future<List<StateModel>> getStates(String countryId) async {
    final url = '${AppUrls.baseUrlWith7010}/api/states?country_id=$countryId';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => StateModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // http://localhost:7000/api/cities?state_id=269
  static Future<List<CityModel>> getCities(String stateId) async {
    final url = '${AppUrls.baseUrlWith7010}/api/cities?state_id=$stateId';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => CityModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final memberId = await AppPreferences.getUserId();
    final url =
        '${AppUrls.baseUrlWith7010}/api/giai/categories?memberId=$memberId';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<BrandModel>> getBrands(String giaiCategoryId) async {
    final url =
        '${AppUrls.baseUrlWith7010}/api/giai/brands?giaiCategoryId=$giaiCategoryId';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => BrandModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // send barcode
  static Future<void> sendBarcode(List<AssetItem> assetItems) async {
    final url =
        '${AppUrls.baseUrlWith7010}/api/assetMasterEncoder/insertAssetMasterEncoder';
    final token = await AppPreferences.getToken();
    final memberId = await AppPreferences.getUserId();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Get current date and time
    final now = DateTime.now();
    final date = now.toString().split(' ')[0]; // Format: YYYY-MM-DD
    final time =
        "${now.hour}:${now.minute}:${now.second} ${now.hour >= 12 ? 'PM' : 'AM'}"; // Format: HH:mm:ss AM/PM

    final body = assetItems
        .map((item) => {
              'memberId': memberId,
              'MajorCategory': item.mCode,
              'MajorCategoryDescription': item.majorDescription,
              'MinorCategory': item.sCode,
              'MinorCategoryDescription': item.minorDescription,
              'AssetType': item.type,
              'ModelOfAsset': item.model,
              'Quantity': item.qty,
              'Country': item.country,
              'Region': item.area,
              'CityName': item.city,
              'Dao': item.department,
              'BusinessUnit': item.businessName,
              'BuildingNo': item.buildingNumber,
              'FloorNo': item.floorNumber,
              'BuildingName': item.buildingName,
              'BuildingAddress': item.buildingName,
              'SerialNumber': item.model,
              'AssetDescription': item.majorDescription,
              'AssetCondition': "New",
              'DaoName': "Dao Name",
              'EmployeeID': "Employee ID",
              'PONumber': "PO Number",
              'PODate': "PO Date",
              'DeliveryNoteNo': "Delivery Note No",
              'Supplier': "Supplier",
              'InvoiceNo': "Invoice No",
              'InvoiceDate': "Invoice Date",
              'Manufacturer': "manufacturer",
              'Ownership': "Ownership",
              'Bought': "Bought",
              'TerminalID': "Terminal Id",
              'ATMNumber': "ATM Number",
              'LocationTag': "Location Tag",
              'UserLoginID': memberId,
              'MainSubSeriesNo': "0",
              'AssetDateCaptured': date,
              'AssetTimeCaptured': time,
              'AssetDateScanned': "Asset Date Scanned",
              'AssetTimeScanned': "Asset Time Scanned",
              'PhoneExtNo': "Phone Ext No",
              'FullLocationDetails':
                  "${item.country}, ${item.state}, ${item.city}, ${item.area}",
            })
        .toList();

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // get tags
  static Future<List<GenerateTagsModel>> getTags() async {
    final memberId = await AppPreferences.getUserId();

    final url =
        '${AppUrls.baseUrlWith7010}/api/assetMasterEncoder?memberId=$memberId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => GenerateTagsModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // generate tags
  static Future<void> generateTags() async {
    final url =
        '${AppUrls.baseUrlWith7010}/api/assetMasterEncoder/generateAssetMasterEncodeAssetCaptureTagNumber';
    final token = await AppPreferences.getToken();
    final memberId = await AppPreferences.getUserId();

    print(url);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {'memberId': memberId};

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['error']);
    }
  }

  static Future<List<EmployeeNameModel>> getEmployeeNames() async {
    final memberId = await AppPreferences.getUserId();
    final token = await AppPreferences.getToken();

    final url =
        '${AppUrls.baseUrlWith7010}/api/memberSubUser?member_id=$memberId';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => EmployeeNameModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // get tag details
  static Future<TagModel> getTagDetails(String tagNumber) async {
    final memberId = await AppPreferences.getUserId();
    final url =
        '${AppUrls.baseUrlWith7010}/api/assetMasterEncoder?memberId=$memberId&TagNumber=$tagNumber';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return TagModel.fromJson(data[0]);
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<void> handleSubmit(
    String id,
    String subUserId,
    String tagNumber,
    String locationTag,
    String serialNo,
    String employeeId,
    String phoneExtension,
    String otherTag,
    String notes,
    String assetCondition,
    String bought,
    String assetLocationDetails,
    String fullLocationDetails,
    List<File> selectedFiles,
  ) async {
    final memberData = await AppPreferences.getUserId();
    final token = await AppPreferences.getToken();
    final url =
        '${AppUrls.baseUrlWith7010}/api/assetCapture/createAssetMasterEncodeAssetCaptureFinal';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'memberId': memberData ?? '',
      'subUser_id': subUserId,
      'TagNumber': tagNumber,
      'LocationTag': locationTag,
      'sERIALnUMBER': serialNo,
      'EMPLOYEEID': employeeId,
      'PhoneExtNo': phoneExtension,
      'ATMNumber': otherTag,
      'DeliveryNoteNo': notes,
      'aSSETcONDITION': assetCondition,
      'Bought': bought,
      'FullLocationDetails': fullLocationDetails,
    });

    // Add files
    for (File file in selectedFiles) {
      String fileName = file.path.split('/').last;
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile(
        'images',
        stream,
        length,
        filename: fileName,
        contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream'),
      );
      request.files.add(multipartFile);
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
    } else {
      print(response.body);
    }
  }
}
