import 'dart:convert';
import 'dart:io';

import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/networks/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiClient {
  final http.Client client = http.Client();

  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}$endpoint",
    ).replace(queryParameters: params);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
    final response = await client.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded;
    } else {
      throw ApiExceptionModel.fromJson(decoded);
    }
  }

  Future<dynamic> putRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    final defaultHeaders = {'Content-Type': 'application/json', ...?headers};

    final response = await http.put(
      url,
      headers: defaultHeaders,
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw ApiExceptionModel.fromJson(decoded);
    }
  }

  /// Multipart for image upload
  Future<dynamic> putMultipart(
    String endpoint,
    Map<String, String> fields,
    File? file,
    String fileFieldName,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    final request = http.MultipartRequest("PUT", url);

    // ✅ add text fields as plain form fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // ✅ add file only if selected
    if (file != null && await file.exists()) {
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();

      final multipartFile = http.MultipartFile(
        fileFieldName,
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (responseBody.trim().startsWith('{')) {
      return jsonDecode(responseBody);
    } else {
      throw Exception(responseBody); // e.g., "Only image files are allowed"
    }
  }

  /// Multipart for multiple image upload
  Future<Map<String, dynamic>> putMultipartMultiple(
    String endpoint,
    Map<String, String> fields,
    List<File>? files,
    String fileFieldName,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final request = http.MultipartRequest('PUT', url);

    // Add form fields
    request.fields.addAll(fields);

    // Add files (max 5)
    if (files != null && files.isNotEmpty) {
      for (var file in files.take(5)) {
        if (await file.exists()) {
          final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
          final multipartFile = await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartFile);
        }
      }
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return {"data": decoded, "message": "Parsed as array"};
        }
      } catch (e) {
        // Backend returned a plain string
        return {"message": body};
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: $body');
    }
  }

  Future<dynamic> deleteRequest(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    final defaultHeaders = {'Content-Type': 'application/json', ...?headers};

    final response = await http.delete(
      url,
      headers: defaultHeaders,
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body.isNotEmpty ? response.body : '{}');
    } else {
      throw Exception(
        'DELETE $endpoint failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
