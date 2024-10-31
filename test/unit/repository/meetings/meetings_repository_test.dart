import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/meetings/model/meeting_model.dart';
import 'package:formation_front/modules/meetings/repository/meetings_repository.dart';
import 'package:formation_front/utils/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../rooms/rooms_repository_test.mocks.dart';

@GenerateMocks([http.Client, ApiService])
void main() {
  group('MeetingsRepository', () {
    late MeetingsRepository meetingsRepository;
    late MockApiService mockApiService;
    late MockClient mockClient;

    setUp(() {
      mockApiService = MockApiService();
      mockClient = MockClient();
      meetingsRepository = MeetingsRepository();
      meetingsRepository.setApiService(mockApiService);
      meetingsRepository.setClient(mockClient);
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

      final meeting =
          Meeting(duration: 1, peopleNb: 1, date: '2022-01-01', roomId: 'room');

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
}
