import '../../../utils/api/api_service.dart';
import '../model/user_model.dart';

class UsersRepository {
  final ApiService apiService = ApiService();

  UsersRepository();

  Future<List<User>> getUsers() async {
    final List<dynamic> response = await apiService.get('/utilisateurs/');
    return response.map((user) => User.fromJson(user)).toList();
  }

  Future<User> getUserById(int id) async {
    final Map<String, dynamic> response =
        await apiService.get('/utilisateurs/$id');
    return User.fromJson(response);
  }

  Future<User> getUserByName(int name) async {
    final Map<String, dynamic> response =
        await apiService.get('/utilisateurs/username/$name');
    return User.fromJson(response);
  }

  Future<int> createUser(Map<String, dynamic> data) async {
    final response = await apiService.post('/utilisateurs/', data, false);
    return response['id'];
  }

  Future<void> deleteUserById(int id) async {
    await apiService.delete('/utilisateurs/$id');
  }

  Future<void> deleteUserByName(String name) async {
    await apiService.delete('/utilisateurs/username/$name');
  }
}
