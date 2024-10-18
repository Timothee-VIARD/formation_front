class Room {
  final int id;
  final String name;
  final int nbMax;

  Room({required this.id, required this.name, required this.nbMax});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      nbMax: json['nb_max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nb_max': nbMax,
    };
  }
}
