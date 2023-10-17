import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/line_profiles/study_line_profile_widget.dart';
import 'package:group_study_app/widgets/panels/notice_summary_panel.dart';
import 'package:group_study_app/widgets/participant_profile_list_widget.dart';
import 'package:group_study_app/widgets/round_info_list_widget.dart';
import 'package:group_study_app/widgets/rule_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class StudyDetailRoute extends StatefulWidget {
  final int studyId;

  const StudyDetailRoute({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<StudyDetailRoute> createState() => _StudyDetailRouteState();
}

class _StudyDetailRouteState extends State<StudyDetailRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(Design.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding15,

              // Study Head
              FutureBuilder(
                  future: Study.getStudySummary(widget.studyId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StudyLineProfileWidget(study: snapshot.data!);
                    }
                    return const SizedBox(); //< FIXME
                },),
              Design.padding15,

              // Notice
              TitleWidget(title: "NOTICE", icon: AppIcons.chevronRight,
                onTap: () => Util.pushRoute(context,
                        (context)=>NoticeListRoute(studyId: widget.studyId,))),
              NoticeSummaryPanel(studyId: widget.studyId,),
              Design.padding15,

              //
              TitleWidget(title: "MEMBER", icon: AppIcons.add,
                onTap: () => null,),
              ParticipantProfileListWidget(studyId: widget.studyId),
              Design.padding15,

              //
              RuleListWidget(studyId: widget.studyId),
              Design.padding15,

              RoundInfoListWidget(studyId: widget.studyId),
            ],
          )
        ),
      )
    );
  }
}