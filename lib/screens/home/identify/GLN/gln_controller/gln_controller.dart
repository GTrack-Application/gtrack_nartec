// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class GlnController {
  static Future<void> postGln(
    String locationNameEn,
    String addressEn,
    String addressAr,
    String pobox,
    String postalCode,
    String longitude,
    String latitude,
    String status,
    File? glnImage,
    String physicalLocation,
    String glnLocation,
  ) async {
    try {
      String? id = await AppPreferences.getUserId();
      String? token = await AppPreferences.getToken();

      final url = Uri.parse('${AppUrls.baseUrlWith3093}api/gln');

      final request = http.MultipartRequest('POST', url);

      // Bearer token
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Host': 'gs1ksa.org:3093',
      });

      // Adding fields
      request.fields['user_id'] = id ?? '';
      request.fields['locationNameEn'] = locationNameEn;
      request.fields['AddressEn'] = addressEn;
      request.fields['AddressAr'] = addressAr;
      request.fields['pobox'] = pobox;
      request.fields['postal_code'] = postalCode;
      request.fields['longitude'] = longitude;
      request.fields['latitude'] = latitude;
      request.fields['status'] = status;
      request.fields['physical_location'] = physicalLocation;
      request.fields['gln_idenfication'] = glnLocation;

      // Helper function to get MIME type from file extension
      MediaType? getMediaType(String path) {
        final mimeType = lookupMimeType(path);
        if (mimeType != null) {
          final parts = mimeType.split('/');
          if (parts.length == 2) {
            return MediaType(parts[0], parts[1]);
          }
        }
        return MediaType('application', 'octet-stream');
      }

      // Adding images
      if (glnImage != null) {
        print('Adding gln Image: ${glnImage.path}');
        request.files.add(
          await http.MultipartFile.fromPath(
            'gln_image',
            glnImage.path,
            filename: glnImage.path.split('/').last,
            contentType: getMediaType(glnImage.path),
          ),
        );
      }

      // if (physicalLocation != null) {
      //   ByteData byteData = await rootBundle.load(physicalLocation);
      //   List<int> imageData = byteData.buffer.asUint8List();

      //   // Create a MultipartFile from the byte array
      //   String filename = physicalLocation.split('/').last;
      //   var multipartFile = http.MultipartFile.fromBytes(
      //     "physical_location",
      //     imageData,
      //     filename: filename,
      //     contentType: getMediaType(filename),
      //   );

      //   // Add the file to the request
      //   request.files.add(multipartFile);
      // }

      final response = await request.send();
      final responseStr = await response.stream.bytesToString();

      print(responseStr);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Product added successfully');
      } else {
        var data = jsonDecode(responseStr);
        var msg = data['message'];
        throw Exception('Failed to add product: $msg');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
