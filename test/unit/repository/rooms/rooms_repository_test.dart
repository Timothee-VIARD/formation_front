import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/rooms/model/room_model.dart';
import 'package:formation_front/modules/rooms/repository/rooms_repository.dart';
import 'package:formation_front/utils/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rooms_repository_test.mocks.dart';

@GenerateMocks([http.Client, ApiService])
void main() {
  group('RoomsRepository', (){
    late RoomsRepository roomsRepository;
    late MockApiService mockApiService;
    late MockClient mockClient;

    setUp(() {
      mockApiService = MockApiService();
      mockClient = MockClient();
      roomsRepository = RoomsRepository();
      roomsRepository.setApiService(mockApiService);
      roomsRepository.setClient(mockClient);
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
}
