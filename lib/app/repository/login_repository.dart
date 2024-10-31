import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http_io;

import '../../../../utils/api/api_service.dart';
import '../model/token_model.dart';

class LoginRepository {
  ApiService _apiService = ApiService();
  http.Client _client = http_io.IOClient();

  LoginRepository();

  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  void setClient(http.Client client) {
    _client = client;
  }

  Future<Token> login(Map<String, dynamic> data) async {
    final response = await _apiService.post('/login', data, true, _client);
    return Token.fromJson(response);
  }
}
