import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class ParticipantSummary {
  final int userId;
  final String picture;

  ParticipantSummary({
    required this.userId,
    required this.picture,
  });
  
  factory ParticipantSummary.fromJson(Map<String, dynamic> json) {
    return ParticipantSummary(
        userId: json['userId'],
        picture: json['picture']
    );
  }

  static Future<List<ParticipantSummary>> getParticipantsProfileImageList(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}studies/participants/summary?studyId=$studyId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Fail to get Participants data (studyId = $studyId)");
    } else {
      print("successfully get Participants data (studyId = $studyId)");

      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['participantSummaryList'];

      return (responseJson as List).map((p) => ParticipantSummary.fromJson(p)).toList();
    }
  }
}