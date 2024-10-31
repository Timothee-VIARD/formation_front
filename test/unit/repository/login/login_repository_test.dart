import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/app/model/token_model.dart';
import 'package:formation_front/app/repository/login_repository.dart';
import 'package:formation_front/utils/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../meetings/meetings_repository_test.mocks.dart';

@GenerateMocks([http.Client, ApiService])
void main() {
  group('LoginRepository', () {
    late LoginRepository loginRepository;
    late MockApiService mockApiService;
    late MockClient mockClient;

    setUp(() {
      mockApiService = MockApiService();
      mockClient = MockClient();
      loginRepository = LoginRepository();
      loginRepository.setApiService(mockApiService);
      loginRepository.setClient(mockClient);
    });

    test('returns a Token', () async {
      final tokenMap = {
        'access_token': 'mockToken',
        'token_type': 'Bearer',
      };

      when(mockApiService.post('/login', any, true, mockClient))
          .thenAnswer((_) async => tokenMap);

      final token = await loginRepository.login({});

      expect(token, isA<Token>());
      expect(token.accessToken, 'mockToken');
      expect(token.tokenType, 'Bearer');
    });
  });

}
