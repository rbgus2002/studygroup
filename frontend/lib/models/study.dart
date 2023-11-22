
import 'dart:convert';
import 'dart:ui';

import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Study {
  // string length limits
  static const int studyNameMaxLength = 30;
  static const int studyDetailMaxLength = 40;

  final int studyId;
  String studyName;
  String detail;
  String picture;
  Color color;
  int hostId;

  Study({
    required this.studyId,
    required this.studyName,
    required this.detail,
    required this.picture,
    required this.color,
    required this.hostId
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      studyId: json['studyId'],
      studyName: json['studyName'],
      detail: json['detail']??"",
      picture: json['picture']??"",
      color : Color(int.parse((json['color'] as String).substring(2), radix: 16)),
      hostId: json['hostId']??1,//< FIXME it had to remove
    );
  }

  static Future<Study> getStudySummary(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies?studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Study Summary");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['studySummary'];
      return Study.fromJson(responseJson);
    }
  }

  static Future<bool> updateStudy(Study updatedStudy, XFile? studyImage) async {
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('${DatabaseService.serverUrl}api/studies/${updatedStudy.studyId}'),
    );

    //request.headers.addAll(DatabaseService.getAuthHeader());
    request.headers['Content-Type'] = 'application/json';
    request.headers['accept'] = '*/*';
    request.headers['Access-Control-Allow-Origin'] = '*';
    request.headers['Authorization'] = 'Bearer ${Auth.signInfo!.token}';

    Map<String, dynamic> data = {
      "studyName": updatedStudy.studyName,
      "detail": "AAA"??updatedStudy.detail,
      "color": '0x${updatedStudy.color.value.toRadixString(16).toUpperCase()}',
      "hostUserId": updatedStudy.studyId
    };

    jsonEncode(data);
    print(jsonEncode(data));

    request.fields['dto'] = jsonEncode(data);

/*
    request.fields['studyName'] = updatedStudy.studyName;
    request.fields['detail'] = "ASD"??updatedStudy.detail;
    request.fields['color'] = '0x${updatedStudy.color.value.toRadixString(16)}';
    request.fields['hostUserId'] = updatedStudy.studyId.toString();
*/
    if (studyImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', studyImage.path));
    }

    print(request.fields);

    final response = await request.send();
    final responseJson = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print('sucess to update study');
      return responseJson['success'];
    }
  }
}