import '../../../utils/api/api_service.dart';

class RoomsRepository {
  final ApiService apiService;

  RoomsRepository({required this.apiService});

  Future<dynamic> getRooms() async {
    return await apiService.get('/salles');
  }

  Future<dynamic> getRoomById(int id) async {
    return await apiService.get('/salles/$id');
  }

  Future<dynamic> getRoomByName(int name) async {
    return await apiService.get('/salles/nom/$name');
  }

  Future<dynamic> createRoom(Map<String, dynamic> data) async {
    return await apiService.post('/salles', data);
  }

  Future<dynamic> deleteRoomById(int id) async {
    return await apiService.delete('/salles/$id');
  }

  Future<dynamic> deleteRoomByName(int name) async {
    return await apiService.delete('/salles/nom/$name');
  }
}