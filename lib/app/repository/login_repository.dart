import 'package:http/http.dart' as http;

import '../../../../utils/api/api_service.dart';
import '../model/token_model.dart';

class LoginRepository {
  ApiService _apiService = ApiService();
  final http.Client _client;

  LoginRepository(this._client);

  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  http.Client getClient() {
    return _client;
  }

  Future<Token> login(Map<String, dynamic> data) async {
    final response = await _apiService.post('/login', data, true, _client);
    return Token.fromJson(response);
  }
}
