// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
    String locationNameAr,
  ) async {
    String? id = await AppPreferences.getGs1UserId();
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.gs1Url}api/gln');

    final request = http.MultipartRequest('POST', url);

    // Bearer token
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    // Adding fields
    request.fields['user_id'] = id ?? '';
    request.fields['locationNameEn'] = locationNameEn;
    request.fields['locationNameAr'] = locationNameAr;
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

    final response = await request.send();
    final responseStr = await response.stream.bytesToString();

    log(responseStr);
    log(response.statusCode.toString());
    log(response.reasonPhrase.toString());

    final data = jsonDecode(responseStr);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Product added successfully');
    } else {
      final msg = data['error'];
      throw Exception('$msg');
    }
  }
}
