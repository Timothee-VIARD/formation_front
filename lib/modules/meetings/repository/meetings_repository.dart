import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/meetings/model/meeting_model.dart';

import '../../../utils/api/api_service.dart';

class MeetingsRepository {
  final ApiService apiService = ApiService();

  MeetingsRepository();

  Future<List<MeetingAnswer>> getMeetings() async {
    final List<dynamic> response = await apiService.get('/reunions/');
    return response.map((meeting) => MeetingAnswer.fromJson(meeting)).toList();
  }

  Future createMeeting(Meeting data, String token) async {
    final response =
        await apiService.post('/reunions/', data.toJson(), false, token);
    return response['id'];
  }

  Future deleteMeetingById(int id, String token) async {
    return await apiService.delete('/reunions/$id', token);
  }
}
