import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notices/notice_create_route.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/notice_summary_widget.dart';

class NoticeListRoute extends StatefulWidget {
  final int studyId;

  const NoticeListRoute({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<NoticeListRoute> createState() => _NoticeListRouteState();
}

class _NoticeListRouteState extends State<NoticeListRoute> {

  late Future<List<NoticeSummary>> futureNoticeSummaryList;

  @override
  void initState() {
    super.initState();
    futureNoticeSummaryList = NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.local.notice,),
        actions: [
          IconButton(
            icon: const Icon(CustomIcons.writing_square_outline),
            splashRadius: 16,
            onPressed: () => Util.pushRoute(context, (context) =>
              NoticeCreateRoute(studyId: widget.studyId)).then((value) => _refresh()),)
        ],),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: Design.edgePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: futureNoticeSummaryList,
            builder: (context, snapshot) =>
              (snapshot.hasData) ?
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return NoticeSummaryWidget(noticeSummary: snapshot.data![index],
                        studyId: widget.studyId,);
                    }) : Design.loadingIndicator)
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    futureNoticeSummaryList = NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100);
    futureNoticeSummaryList.then((value) => setState((){ }));
  }
}