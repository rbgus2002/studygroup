import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/studies/study_edit_route.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/add_button.dart';
import 'package:group_study_app/widgets/item_entry.dart';
import 'package:group_study_app/widgets/member_profile_list_widget.dart';
import 'package:group_study_app/widgets/panels/notice_summary_panel.dart';
import 'package:group_study_app/widgets/round_summary_list_widget.dart';

class StudyDetailRoute extends StatefulWidget {
  final Study study;

  const StudyDetailRoute({
    Key? key,
    required this.study,
  }) : super(key: key);

  @override
  State<StudyDetailRoute> createState() => _StudyDetailRouteState();
}

class _StudyDetailRouteState extends State<StudyDetailRoute> {
  static const double _imageSize = 80;
  late Study _study;

  @override
  void initState() {
    super.initState();
    _study = widget.study;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _study.color,
        actions: [ _studyPopupMenu() ],
        shape: InputBorder.none,),

      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Study Image and Appbar
              _profileWidget(_study),

              // Notices and Members
              Container(
                padding: Design.edgePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notice Summary Panel
                    NoticeSummaryPanel(studyId: _study.studyId,),
                    Design.padding24,

                    // Member Images
                    Text(
                      context.local.member,
                      style: TextStyles.head5.copyWith(color:
                        context.extraColors.grey800),),
                    Design.padding16,

                    MemberProfileListWidget(
                      studyId: _study.studyId,
                      hostId: _study.hostId,),
                    Design.padding32,
                ]),
              ),

              Container(
                padding: Design.edgePadding,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: context.extraColors.grey100!)),),
                child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.local.rules,
                        style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
                      AddButton(
                        iconData: CustomIcons.writing_outline,
                        text: context.local.writeRule,
                        onTap: () {}),
                    ],),
                ]),
              ),

              Container(
                padding: Design.edgePadding,
                child: RoundSummaryListWidget(study: _study,),),
            ],),
        ),),
    );
  }

  Widget _profileWidget(Study study) {
    return SizedBox(
      height: 226,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 160,
            color: study.color),

          Positioned(
            left: 20,
            top: 116,
            child: Container(
              width: _imageSize,
              height: _imageSize,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Design.radiusValue),),
              child: (study.picture.isNotEmpty) ?
                  CachedNetworkImage(
                    imageUrl: study.picture,
                    fit: BoxFit.cover) : null,),),

          Positioned(
            left: 20,
            top: 200,
            child: Text(
                study.studyName,
                style: TextStyles.head3.copyWith(
                    color: context.extraColors.grey800),))
        ],),
    );
  }

  Widget _studyPopupMenu() {
    double iconSize = 32;
    return PopupMenuButton(
      icon: Icon(
        CustomIcons.more_vert,
        color: context.extraColors.grey900),
      color: context.extraColors.grey000,
      iconSize: iconSize,
      splashRadius: iconSize / 2,
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(minWidth: Design.popupWidth),
      itemBuilder: (context) => [
        // edit profile
        ItemEntry(
          text: context.local.editStudy,
          icon: const Icon(CustomIcons.writing_outline),
          onTap: () => Util.pushRoute(context, (context) =>
              StudyEditRoute(study: _study,)),),

        // setting
        ItemEntry(
          text: context.local.leaveStudy,
          icon: const Icon(CustomIcons.setting_outline,),),
      ],);
  }

  Future<void> refresh() async {
    Study.getStudySummary(_study.studyId).then((study) =>
      setState(() => _study = study));
  }
}