import 'package:group_study_app/models/notice_summary.dart';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/create_notice_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/notice_panel.dart';

class NoticeListRoute extends StatefulWidget {
  final int studyId = Test.testStudy.studyId;

  NoticeListRoute({super.key});

  @override
  State<NoticeListRoute> createState() {
    return _NoticeListRoute();
  }
}

class _NoticeListRoute extends State<NoticeListRoute> {
  late Future<List<NoticeSummary>> notices;
  @override
  void initState() {
    super.initState();
    notices = NoticeSummary.getNoticeSummaryList(widget.studyId);
  }

  Future<void> updateNotices() async {
    notices = NoticeSummary.getNoticeSummaryList(widget.studyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: AppIcons.add,
            splashRadius: 16,
            onPressed: () {
              Util.pushRoute(context, (context) => CreateNoticeRoute());
            },

          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: notices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: Design.edge15,
                child: RefreshIndicator(
                    onRefresh: updateNotices,
                    child: Column(
                      children: [
                        for (NoticeSummary notice in snapshot.data!)
                          NoticePanel(noticeSummary: notice),
                        for (NoticeSummary notice in snapshot.data!)
                          NoticePanel(noticeSummary: notice),
                      ]
                    )
                ),
              );
            } else
              return NoticePanel(noticeSummary: NoticeSummary(
                noticeId: 12345,
                contents: "내용에 해당하는 부분입니다.",
                createDate: DateTime.now(),
                title: "[공지] 규현님의 취업을 축하드립니다.",
                writerNickname: "Arkady",
                pinYn: true,
              )
              );
              //return Text("공지가 없어용");
          }
        ,)
        )
    );
  }
}