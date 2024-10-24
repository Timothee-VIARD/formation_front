class Meeting {
  final int peopleNb;
  final String date;
  final int duration;
  final String? roomId;

  Meeting(
      {required this.duration,
      required this.peopleNb,
      required this.date,
      required this.roomId});

  Map<String, dynamic> toJson() {
    return {
      'people_nb': peopleNb,
      'horaire': date,
      'duree': duration,
      'salle_nom': roomId,
    };
  }
}
