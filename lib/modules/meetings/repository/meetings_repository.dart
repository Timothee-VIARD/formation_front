import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/meetings/model/meeting_model.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api/api_service.dart';

class MeetingsRepository {
  ApiService _apiService = ApiService();
  final http.Client _client;

  MeetingsRepository(this._client);

  setApiService(ApiService service) {
    _apiService = service;
  }

  Future<List<MeetingAnswer>> getMeetings() async {
    final List<dynamic> response = await _apiService.get('/reunions/', _client);
    return response.map((meeting) => MeetingAnswer.fromJson(meeting)).toList();
  }

  Future createMeeting(Meeting data, String token) async {
    final response = await _apiService.post(
        '/reunions/', data.toJson(), false, _client, token);
    return response['id'];
  }

  Future deleteMeetingById(int id, String token) async {
    return await _apiService.delete('/reunions/$id', _client, token);
  }
}
