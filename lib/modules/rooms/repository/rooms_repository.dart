import 'package:formation_front/modules/rooms/model/room_model.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api/api_service.dart';

class RoomsRepository {
  ApiService _apiService = ApiService();
  final http.Client _client;

  RoomsRepository(this._client);

  setApiService(ApiService service) {
    _apiService = service;
  }

  Future<List<Room>> getRooms() async {
    final List<dynamic> response = await _apiService.get('/salles', _client);
    return response.map((room) => Room.fromJson(room)).toList();
  }

  Future<dynamic> createRoom(Map<String, dynamic> data) async {
    final response = await _apiService.post('/salles/', data, false, _client);
    return response['id'];
  }

  Future<void> deleteRoomById(int id) async {
    return await _apiService.delete('/salles/$id', _client);
  }
}
