import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/users/model/user_model.dart';
import 'package:formation_front/modules/users/repository/users_repository.dart';
import 'package:formation_front/utils/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'users_repository_test.mocks.dart';

@GenerateMocks([http.Client, ApiService])
void main() {
  group('UsersRepository', () {
    late UsersRepository usersRepository;
    late MockApiService mockApiService;
    late MockClient mockClient;

    setUp(() {
      mockApiService = MockApiService();
      mockClient = MockClient();
      usersRepository = UsersRepository();
      usersRepository.setApiService(mockApiService);
      usersRepository.setClient(mockClient);
    });

    test('returns a list of Users',
            () async {
          final usersList = [
            {'id': 1, 'name': 'mock user 1', 'email': 'mock@mock.com'},
            {'id': 2, 'name': 'mock user 2', 'email': 'mock2@mock.com'}
          ];

          when(mockApiService.get('/utilisateurs/', mockClient))
              .thenAnswer((_) async => usersList);

          final users = await usersRepository.getUsers();

          expect(users, isA<List<User>>());
          expect(users.length, 2);
          expect(users[0].id, 1);
          expect(users[1].id, 2);
        });

    test('returns a User by id', () async {
      const userId = 1;
      final userMap = {'id': 1, 'name': 'mock user', 'email': 'mock@mock.com'};

      when(mockApiService.get('/utilisateurs/$userId', mockClient))
          .thenAnswer((_) async => userMap);

      final user = await usersRepository.getUserById(userId);

      expect(user, isA<User>());
      expect(user.id, 1);
      expect(user.name, 'mock user');
      expect(user.email, 'mock@mock.com');
    });

    test('creates a User', () async {
      final userMap = {'id': 1, 'name': 'mock user', 'email': 'mock@mock.com'};

      when(mockApiService.post('/utilisateurs/', userMap, false, mockClient))
          .thenAnswer((_) async => userMap);

      final userId = await usersRepository.createUser(userMap);

      expect(userId, 1);
    });

    test('deletes a User by name', () async {
      const name = 'mock user';

      when(mockApiService.delete('/utilisateurs/username/$name', mockClient))
          .thenAnswer((_) async => null);

      await usersRepository.deleteUserByName(name);

      verify(mockApiService.delete('/utilisateurs/username/$name', mockClient));
    });
  });
}
