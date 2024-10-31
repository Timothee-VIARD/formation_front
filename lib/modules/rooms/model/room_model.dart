import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final int id;
  final String name;
  final int nbMax;

  const Room({required this.id, required this.name, required this.nbMax});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      nbMax: json['nb_max'],
    );
  }

  @override
  List<Object?> get props => [id, name, nbMax];
}