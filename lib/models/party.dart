import 'package:cloud_firestore/cloud_firestore.dart';

class Party {
  String id;
  String partyName;
  String venue;
  DateTime time;
  String dressCode;

  Party({
    required this.id,
    required this.partyName,
    required this.venue,
    required this.time,
    required this.dressCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'partyName': partyName,
      'venue': venue,
      'time': time,
      'dressCode': dressCode,
    };
  }

  factory Party.fromJson(Map<String, dynamic> json, String id) {
    return Party(
      id: id,
      partyName: json['partyName'],
      venue: json['venue'],
      time: (json['time'] as Timestamp).toDate(),
      dressCode: json['dressCode'],
    );
  }
}