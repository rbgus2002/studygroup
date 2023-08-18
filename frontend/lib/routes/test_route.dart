import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/round_info_list_widget.dart';
import 'package:group_study_app/widgets/task_list_widget.dart';

class TestRoute extends StatefulWidget {
  const TestRoute({super.key});

  @override
  State<TestRoute> createState() => _TestRoute();
}

class _TestRoute extends State<TestRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ASD")),
      body: Container(
        padding: Design.edge15,
        child: Panel(
          boxShadows: Design.basicShadows,
    child: TaskListWidget(
          studyId: 0,
          userId: 0,
          roundId: 0,
        ),),
      ),
    );
  }
}