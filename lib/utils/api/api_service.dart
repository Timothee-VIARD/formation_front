import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:8008';

  ApiService();

  Future<dynamic> get(String endpoint, http.Client client) async {
    final response = await client.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      bool isEncoded, http.Client client,
      [String? token]) async {
    final headers = token != null ? {'Authorization': 'Bearer $token'} : null;
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': isEncoded
            ? 'application/x-www-form-urlencoded; charset=utf-8'
            : 'application/json',
        ...?headers,
      },
      body: isEncoded ? data : json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final detail = json.decode(response.body)['detail'];
      throw Exception(detail);
    }
  }

  Future<dynamic> delete(String endpoint, http.Client client, [String? token]) async {
    final headers = token != null ? {'Authorization': 'Bearer $token'} : null;
    final response = await client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
