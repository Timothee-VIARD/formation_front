import '../../../../utils/api/api_service.dart';
import '../model/token_model.dart';

class LoginRepository {
  final ApiService apiService = ApiService();

  LoginRepository();

  Future<Token> login(Map<String, dynamic> data) async {
    final response = await apiService.post('/login', data, true);
    return Token.fromJson(response);
  }
}
