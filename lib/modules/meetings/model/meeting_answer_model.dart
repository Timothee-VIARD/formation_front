class MeetingAnswer {
  final int id;
  final int peopleNb;
  final String date;
  final int duration;
  final int? roomId;
  final String userName;

  MeetingAnswer(
      {required this.id,
      required this.duration,
      required this.userName,
      required this.peopleNb,
      required this.date,
      required this.roomId});

  factory MeetingAnswer.fromJson(Map<String, dynamic> json) {
    return MeetingAnswer(
      id: json['id'],
      peopleNb: json['people_nb'],
      date: json['horaire'],
      duration: json['duree'],
      roomId: json['salle_id'],
      userName: json['user'],
    );
  }
}
