import 'package:http/http.dart' as http;

import '../../../utils/api/api_service.dart';
import '../model/user_model.dart';

class UsersRepository {
  ApiService _apiService = ApiService();
  final http.Client _client;

  UsersRepository(this._client);

  setApiService(ApiService service) {
    _apiService = service;
  }

  Future<List<User>> getUsers() async {
    final List<dynamic> response = await _apiService.get('/utilisateurs/', _client);
    return response.map((user) => User.fromJson(user)).toList();
  }

  Future<User> getUserById(int id) async {
    final Map<String, dynamic> response =
        await _apiService.get('/utilisateurs/$id', _client);
    return User.fromJson(response);
  }

  Future<int> createUser(Map<String, dynamic> data) async {
    final response = await _apiService.post('/utilisateurs/', data, false, _client);
    return response['id'];
  }

  Future<void> deleteUserByName(String name) async {
    await _apiService.delete('/utilisateurs/username/$name', _client);
  }
}
