import 'dart:convert';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class NoticeSummary {
  final int noticeId;
  final String title;
  final String contents;
  final String writerNickname;
  final DateTime createDate;
  bool pinYn;

  NoticeSummary({
    required this.noticeId,
    required this.title,
    required this.contents,
    required this.writerNickname,
    required this.createDate,
    required this.pinYn,
  });

  factory NoticeSummary.fromJson(Map<String, dynamic> json) {
    return NoticeSummary(
      noticeId: json['noticeId'],
      title: json['title'],
      contents: json['contents'],
      writerNickname: json['writerNickname'],
      createDate: DateTime.parse(json['createDate']),
      pinYn: (json['pinYn'] == 'Y'),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'contents': contents,
    'writerNickname': writerNickname,
    'createDate' : createDate,
  };

  static Future<List<NoticeSummary>> getNoticeSummaryListLimit3(int studyId) async {
    final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}notices/list/limited?studyId=$studyId')
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to load data");
    } else {
      print("Notices 3 successfully");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeList'];

      return (responseJson as List).map((p) => NoticeSummary.fromJson(p)).toList();
    }
  }

  static Future<List<NoticeSummary>> getNoticeSummaryList(int studyId) async {
    final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}notices/list?studyId=$studyId')
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to load data");
    } else {
      print("Notices successfully");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeList'];

      return (responseJson as List).map((p) => NoticeSummary.fromJson(p)).toList();
    }
  }

  static Future<bool> switchNoticePin(int noticeId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}notices/pin?noticeId=$noticeId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to change pin"); //< FIXME
    } else {
      String result = json.decode(
          utf8.decode(response.bodyBytes))['data']['pinYn'];
      return (result == 'Y');
    }
  }
}