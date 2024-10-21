import 'package:formation_front/modules/rooms/model/room_model.dart';

import '../../../utils/api/api_service.dart';

class RoomsRepository {
  final ApiService apiService = ApiService();

  RoomsRepository();

  Future<List<Room>> getRooms() async {
    final List<dynamic> response = await apiService.get('/salles');
    return response.map((room) => Room.fromJson(room)).toList();
  }

  Future<Room> getRoomById(int id) async {
    final Map<String, dynamic> response = await apiService.get('/salles/$id');
    return Room.fromJson(response);
  }

  Future<Room> getRoomByName(int name) async {
    final Map<String, dynamic> response =
        await apiService.get('/salles/nom/$name');
    return Room.fromJson(response);
  }

  Future<dynamic> createRoom(Map<String, dynamic> data) async {
    final response = await apiService.post('/salles/', data, false);
    return response['id'];
  }

  Future<void> deleteRoomById(int id) async {
    return await apiService.delete('/salles/$id');
  }

  Future<void> deleteRoomByName(int name) async {
    return await apiService.delete('/salles/nom/$name');
  }
}
