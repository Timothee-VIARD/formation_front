import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/utils/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService();
    });

    test('test get method success', () async {
      final response = http.Response('{"data": "value"}', 200);
      when(mockClient.get(Uri.parse('${apiService.baseUrl}/test')))
          .thenAnswer((_) async => response);

      final result = await apiService.get('/test', mockClient);

      expect(result, {'data': 'value'});
    });

    test('test get method failed', () async {
      final response = http.Response('Failed to load data', 404);
      when(mockClient.get(Uri.parse('${apiService.baseUrl}/test')))
          .thenAnswer((_) async => response);

      expect(() => apiService.get('/test', mockClient), throwsException);
    });

    test('test post method success', () async {
      final response = http.Response('{"data": "value"}', 200);
      when(mockClient.post(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: '{"data":"value"}',
      )).thenAnswer((_) async => response);

      final result = await apiService.post('/test', {'data': 'value'}, false, mockClient);

      expect(result, {'data': 'value'});
    });

    test('test post method with token success', () async {
      final response = http.Response('{"data": "value"}', 200);
      when(mockClient.post(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer token',
        },
        body: '{"data":"value"}',
      )).thenAnswer((_) async => response);

      final result = await apiService.post('/test', {'data': 'value'}, false, mockClient, 'token');

      expect(result, {'data': 'value'});
    });

    test('test post method encode success', () async {
      final response = http.Response('{"data": "value"}', 200);
      when(mockClient.post(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        },
        body: {'data': 'value'},
      )).thenAnswer((_) async => response);

      final result = await apiService.post('/test', {'data': 'value'}, true, mockClient);

      expect(result, {'data': 'value'});
    });

    test('test post method failed', () async {
      final response = http.Response('{"detail": "Failed to post data"}', 400);
      when(mockClient.post(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: '{"data":"value"}',
      )).thenAnswer((_) async => response);

      expect(() => apiService.post('/test', {'data': 'value'}, false, mockClient), throwsException);
    });

    test('test delete method success', () async {
      final response = http.Response('{"data": "value"}', 200);
      when(mockClient.delete(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: null,
      )).thenAnswer((_) async => response);

      final result = await apiService.delete('/test', mockClient);

      expect(result, {'data': 'value'});
    });

    test('test delete method with token success', () async {
      final response = http.Response('{"data": "value"}', 200);
      when(mockClient.delete(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: {
          'Authorization': 'Bearer token',
        },
      )).thenAnswer((_) async => response);

      final result = await apiService.delete('/test', mockClient, 'token');

      expect(result, {'data': 'value'});
    });

    test('test delete method failed', () async {
      final response = http.Response('Failed to delete data', 404);
      when(mockClient.delete(
        Uri.parse('${apiService.baseUrl}/test'),
        headers: null,
      )).thenAnswer((_) async => response);

      expect(() => apiService.delete('/test', mockClient), throwsException);
    });
  });
}
