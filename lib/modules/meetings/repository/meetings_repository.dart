import '../../../utils/api/api_service.dart';

class MeetingsRepository {
  final ApiService apiService;

  MeetingsRepository({required this.apiService});

  Future getMeetings() async {
    return await apiService.get('/meetings');
  }

  Future getMeetingById(int id) async {
    return await apiService.get('/meetings/$id');
  }

  Future getMeetingByName(int name) async {
    return await apiService.get('/meetings/name/$name');
  }

  Future createMeeting(Map<String, dynamic> data) async {
    return await apiService.post('/meetings', data, false);
  }

  Future deleteMeetingById(int id) async {
    return await apiService.delete('/meetings/$id');
  }

  Future deleteMeetingByName(int name) async {
    return await apiService.delete('/meetings/name/$name');
  }
}
