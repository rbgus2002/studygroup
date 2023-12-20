import 'dart:convert';

import 'package:group_study_app/models/participant_info.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Task {
  static const int taskMaxLength = 200;
  static const int nonAllocatedTaskId = -1;

  int taskId;
  String detail;
  bool isDone;

  Task({
    this.taskId = nonAllocatedTaskId,
    this.detail = "",
    this.isDone = false,
  });

  @override
  String toString() {
    return '$detail $isDone';
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      isDone: (json['doneYn'] == 'Y'),
      detail: json['detail']??"",
    );
  }

  static Future<List<ParticipantInfo>> getTasks(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Tasks");
    } else {
      print("Success to get participants Task lists");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['tasks'];
      return (responseJson as List).map((p) => ParticipantInfo.fromJson(p)).toList();
    }
  }

  static Future<bool> createPersonalTask(Task task, int roundParticipantId) async {
    Map<String, dynamic> data = {
      "roundParticipantId": roundParticipantId,
      "detail": task.detail,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/personal'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool success = responseJson['success'];
      if(success) {
        task.taskId = responseJson['data']['taskId'];
        print("success to create personal task");
      }
      return success;
    }
  }

  static Future<bool> createGroupTask(Task task, int roundId, Function(String, List<TaskInfo>)? notify) async {
    Map<String, dynamic> data = {
      "roundId": roundId,
      "detail": task.detail,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/group'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print('success to create group tasks');

      List<TaskInfo> taskInfoList = ((responseJson['data']['groupTasks']??[]) as List).map((i) =>
          TaskInfo.fromJson(i)).toList();

      if (notify != null) {
        notify(task.detail, taskInfoList);
      }

      return responseJson['success'];
    }
  }

  static Future<bool> deleteTask(int taskId, int roundParticipantId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?taskId=$taskId&roundParticipantId=$roundParticipantId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to delete task");
    } else {
      bool result = json.decode(response.body)['success'];
      if (result) print('success to delete task');
      return result;
    }
  }

  static Future<bool> updateTaskDetail(Task task, int roundParticipantId) async {
    if (task.taskId == Task.nonAllocatedTaskId) return false;

    Map<String, dynamic> data = {
      'taskId': task.taskId,
      'roundParticipantId': roundParticipantId,
      'detail': task.detail,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?taskId=${task.taskId}&roundParticipantId=$roundParticipantId}'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to update task detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if (success) print("Success to update task detail"); //< FIXME
      return success;
    }
  }

  static Future<bool> switchTask(int taskId) async {
    if (taskId == nonAllocatedTaskId) { return false; }

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/check?taskId=$taskId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception('Failed to switch check task');
    } else {
      String isChecked = json.decode(response.body)['data']['doneYn'];
      return (isChecked == 'Y');
    }
  }

  static Future<bool> stabTask({
    required int targetUserId,
    required int studyId,
    required int roundId,
    required int taskId,
    required int count}) async {

    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/notifications/tasks?targetUserId=$targetUserId&studyId=$studyId&roundId=$roundId&taskId=$taskId&count=$count'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      if (responseJson['success']) print('success to stab task($count times)');
      return responseJson['success'];
    }
  }
}

class TaskInfo {
  final int roundParticipantId;
  final int taskId;

  TaskInfo({
    required this.roundParticipantId,
    required this.taskId,
  });

  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo(
      roundParticipantId: json['roundParticipantId'],
      taskId: json['taskId'],
    );
  }
}

class TaskGroup {
  static final Set<String> sharedTaskGroups = { 'GROUP' };

  final int roundParticipantId;
  final String taskType;
  final String taskTypeName;
  final List<Task> tasks;
  bool isShared;

  TaskGroup({
    required this.roundParticipantId,
    required this.taskType,
    required this.taskTypeName,
    this.tasks = const [],
    required this.isShared,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json, int roundParticipantId) {
    return TaskGroup(
      roundParticipantId: roundParticipantId,
      taskType: json['taskType'],
      taskTypeName: json['taskTypeName'],
      tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
      isShared: (sharedTaskGroups.contains(json['taskType'])),
    );
  }
}