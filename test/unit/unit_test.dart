import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/app/model/token_model.dart';
import 'package:formation_front/app/repository/login_repository.dart';
import 'package:formation_front/modules/common/snack_bar/controllers/cubit.dart';
import 'package:formation_front/modules/common/snack_bar/controllers/state.dart';
import 'package:formation_front/modules/common/time_input_field/time_input_field.dart';
import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/meetings/model/meeting_model.dart';
import 'package:formation_front/modules/meetings/repository/meetings_repository.dart';
import 'package:formation_front/modules/rooms/model/room_model.dart';
import 'package:formation_front/modules/rooms/repository/rooms_repository.dart';
import 'package:formation_front/modules/users/model/user_model.dart';
import 'package:formation_front/modules/users/repository/users_repository.dart';
import 'package:formation_front/utils/api/api_service.dart';
import 'package:formation_front/utils/date_time/date_state.dart';
import 'package:formation_front/utils/date_time/date_time.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'unit_test.mocks.dart';

@GenerateMocks([http.Client, ApiService])
void main() {
  group('Repositories tests', () {
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

        final result = await apiService.post(
            '/test', {'data': 'value'}, false, mockClient);

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

        final result = await apiService.post(
            '/test', {'data': 'value'}, false, mockClient, 'token');

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

        final result =
            await apiService.post('/test', {'data': 'value'}, true, mockClient);

        expect(result, {'data': 'value'});
      });

      test('test post method failed', () async {
        final response =
            http.Response('{"detail": "Failed to post data"}', 400);
        when(mockClient.post(
          Uri.parse('${apiService.baseUrl}/test'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: '{"data":"value"}',
        )).thenAnswer((_) async => response);

        expect(
            () =>
                apiService.post('/test', {'data': 'value'}, false, mockClient),
            throwsException);
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
    group('LoginRepository', () {
      late LoginRepository loginRepository;
      late MockApiService mockApiService;
      late MockClient mockClient;

      setUp(() {
        mockApiService = MockApiService();
        mockClient = MockClient();
        loginRepository = LoginRepository(mockClient);
        loginRepository.setApiService(mockApiService);
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
      });

      test('login with good credentials', () async {
        final credentials = {'username': 'roger', 'password': 'roger'};

        when(mockApiService.post('/login', credentials, true, mockClient))
            .thenAnswer((_) async => {
                  'access_token': 'token',
                  'token_type': 'Bearer',
                });

        final token = await loginRepository.login(credentials);
        expect(token, isA<Token>());
      });

      test("login with bad credentials", () async {
        final credentials = {'username': 'roger', 'password': 'roger'};

        when(mockApiService.post('/login', credentials, true, mockClient))
            .thenThrow(Exception("Identifiants non reconnus"));

        expect(loginRepository.login(credentials), throwsException);
      });
    });
    group('MeetingsRepository', () {
      late MeetingsRepository meetingsRepository;
      late MockApiService mockApiService;
      late MockClient mockClient;

      setUp(() {
        mockApiService = MockApiService();
        mockClient = MockClient();
        meetingsRepository = MeetingsRepository(mockClient);
        meetingsRepository.setApiService(mockApiService);
      });

      test('returns a list of Meetings', () async {
        final meetingsList = [
          {
            'id': 1,
            'people_nb': 1,
            'horaire': '2022-01-01',
            'duree': 1,
            'salle_id': 1,
            'user': 'mock'
          },
          {
            'id': 2,
            'people_nb': 2,
            'horaire': '2022-01-02',
            'duree': 2,
            'salle_id': 2,
            'user': 'mock2'
          }
        ];

        when(mockApiService.get('/reunions/', mockClient))
            .thenAnswer((_) async => meetingsList);

        final meetings = await meetingsRepository.getMeetings();

        expect(meetings, isA<List<MeetingAnswer>>());
        expect(meetings.length, 2);
        expect(meetings[0].id, 1);
        expect(meetings[1].id, 2);
      });

      test('create a meeting', () async {
        final meetingMap = {
          'people_nb': 1,
          'horaire': '2022-01-01',
          'duree': 1,
          'salle_nom': "room"
        };

        final meeting = Meeting(
            duration: 1, peopleNb: 1, date: '2022-01-01', roomId: 'room');

        when(mockApiService.post(
                '/reunions/', meetingMap, false, mockClient, 'token'))
            .thenAnswer((_) async => {'id': 1});

        final id = await meetingsRepository.createMeeting(meeting, 'token');

        expect(id, 1);
      });

      test('delete a meeting', () async {
        when(mockApiService.delete('/reunions/1', mockClient, 'token'))
            .thenAnswer((_) async => {});

        await meetingsRepository.deleteMeetingById(1, 'token');

        verify(mockApiService.delete('/reunions/1', mockClient, 'token'));
      });
    });
    group('RoomsRepository', () {
      late RoomsRepository roomsRepository;
      late MockApiService mockApiService;
      late MockClient mockClient;

      setUp(() {
        mockApiService = MockApiService();
        mockClient = MockClient();
        roomsRepository = RoomsRepository(mockClient);
        roomsRepository.setApiService(mockApiService);
      });

      test('returns a list of Rooms', () async {
        final roomsList = [
          {'id': 1, 'name': 'mock room 1', 'nb_max': 10},
          {'id': 2, 'name': 'mock room 2', 'nb_max': 20}
        ];

        when(mockApiService.get('/salles', mockClient))
            .thenAnswer((_) async => roomsList);

        final rooms = await roomsRepository.getRooms();

        expect(rooms, isA<List<Room>>());
        expect(rooms.length, 2);
        expect(rooms[0].id, 1);
        expect(rooms[1].id, 2);
      });

      test('creates a Room', () async {
        final roomMap = {'id': 1, 'name': 'mock room', 'nb_max': 10};

        when(mockApiService.post('/salles/', roomMap, false, mockClient))
            .thenAnswer((_) async => roomMap);

        final id = await roomsRepository.createRoom(roomMap);

        expect(id, 1);
      });

      test('deletes a Room by id', () async {
        const roomId = 1;

        when(mockApiService.delete('/salles/$roomId', mockClient))
            .thenAnswer((_) async => null);

        await roomsRepository.deleteRoomById(roomId);

        verify(mockApiService.delete('/salles/$roomId', mockClient));
      });
    });
    group('UsersRepository', () {
      late UsersRepository usersRepository;
      late MockApiService mockApiService;
      late MockClient mockClient;

      setUp(() {
        mockApiService = MockApiService();
        mockClient = MockClient();
        usersRepository = UsersRepository(mockClient);
        usersRepository.setApiService(mockApiService);
      });

      test('returns a list of Users', () async {
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
        final userMap = {
          'id': 1,
          'name': 'mock user',
          'email': 'mock@mock.com'
        };

        when(mockApiService.get('/utilisateurs/$userId', mockClient))
            .thenAnswer((_) async => userMap);

        final user = await usersRepository.getUserById(userId);

        expect(user, isA<User>());
        expect(user.id, 1);
        expect(user.name, 'mock user');
        expect(user.email, 'mock@mock.com');
      });

      test('creates a User', () async {
        final userMap = {
          'id': 1,
          'name': 'mock user',
          'email': 'mock@mock.com'
        };

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

        verify(
            mockApiService.delete('/utilisateurs/username/$name', mockClient));
      });
    });
  });

  group('Common functions tests', () {
    group('NotificationCubit', () {
      late NotificationCubit notificationCubit;

      setUp(() {
        notificationCubit = NotificationCubit();
      });

      tearDown(() {
        notificationCubit.close();
      });

      blocTest<NotificationCubit, NotificationState>(
        'emits [NotificationSuccess, NotificationInitial] when showSuccess is called',
        build: () => notificationCubit,
        act: (cubit) => cubit.showSuccess('Success message'),
        expect: () => [
          NotificationSuccess('Success message'),
          NotificationInitial(),
        ],
      );

      blocTest<NotificationCubit, NotificationState>(
        'emits [NotificationError, NotificationInitial] when showError is called',
        build: () => notificationCubit,
        act: (cubit) => cubit.showError('Error message'),
        expect: () => [
          NotificationError('Error message'),
          NotificationInitial(),
        ],
      );
    });
    group('DateTimeUtils', () {
      test('mergeDateAndTimeString should return correct DateTime', () {
        const date = '01/01/2022';
        const time = '12:00';
        final result = DateTimeUtils.mergeDateAndTimeString(date, time);
        expect(result, DateTime(2022, 1, 1, 12, 0));
      });

      test('getDateTimeFromString should parse date string correctly', () {
        const dateString = '2022-01-01T12:00:00';
        final result = DateTimeUtils.getDateTimeFromString(dateString);
        expect(result, DateTime(2022, 1, 1, 12, 0));
      });

      test('getDateTimePlusDuration should add duration correctly', () {
        final date = DateTime(2022, 1, 1, 12, 0);
        const duration = 60;
        final result = DateTimeUtils.getDateTimePlusDuration(date, duration);
        expect(result, DateTime(2022, 1, 1, 13, 0));
      });

      test(
          'getDateState should return DateState.late if now is after meeting end',
          () {
        final date = DateTime.now().subtract(const Duration(hours: 2));
        const duration = 60;
        final result = DateTimeUtils.getDateState(date, duration);
        expect(result, DateState.late);
      });

      test(
          'getDateState should return DateState.soon if now is before meeting start',
          () {
        final date = DateTime.now().add(const Duration(hours: 2));
        const duration = 60;
        final result = DateTimeUtils.getDateState(date, duration);
        expect(result, DateState.soon);
      });

      test(
          'getDateState should return DateState.now if now is during the meeting',
          () {
        final date = DateTime.now().subtract(const Duration(minutes: 30));
        const duration = 60;
        final result = DateTimeUtils.getDateState(date, duration);
        expect(result, DateState.now);
      });

      test('getDateOnly should return date in dd/MM/yyyy format', () {
        final date = DateTime(2022, 1, 1);
        final result = DateTimeUtils.getDateOnly(date);
        expect(result, '1/1/2022');
      });

      test('getTimeOnly should return time in HH:mm format', () {
        final date = DateTime(2022, 1, 1, 12, 0);
        final result = DateTimeUtils.getTimeOnly(date);
        expect(result, '12:00');
      });
    });
    group('TimeTextInputFormatter', () {
      final formatter = TimeTextInputFormatter();

      test('formats empty input correctly', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '');
        expect(formatter.formatEditUpdate(oldValue, newValue), newValue);
      });

      test('formats valid time input correctly', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '1234');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, '12:34');
      });

      test('rejects invalid characters', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '12a4');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, oldValue.text);
      });

      test('rejects invalid time values', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '2560');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, oldValue.text);
      });

      test('formats 3 digits time input correctly', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '321');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, '03:21');
      });

      test('formats two-digit input correctly', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '25');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, '0${newValue.text[0]}:${newValue.text[1]}');
      });

      test('formats four-digit input correctly', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '1234');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, '12:34');
      });

      test('adds colon to two-digit input', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '12');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, '12:');
      });

      test('adds colon to three-digit input', () {
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '123');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, '12:3');
      });
    });
  });
}
