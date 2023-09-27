
import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_info.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/line_profiles/participant_line_profile_widget.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class ParticipantTaskListWidget extends StatelessWidget {
  final ParticipantInfo participantInfo;

  const ParticipantTaskListWidget({
    Key? key,
    required this.participantInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParticipantLineProfileWidget(
          user: participantInfo.participant,
          taskProgress: participantInfo.taskProgress,
        ),
        Design.padding10,

        ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            
            itemCount: participantInfo.taskGroups.length,
            itemBuilder: _buildTaskGroup,
        )
      ],
    );
  }

  Widget _buildTaskGroup(BuildContext context, int index) {
    return Container(
      padding: Design.bottom15,
      child: TaskGroupWidget(taskGroup: participantInfo.taskGroups[index])
    );
  }
}