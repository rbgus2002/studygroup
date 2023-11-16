import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notices/notice_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/old_panel.dart';
import 'package:group_study_app/widgets/tags/notice_reaction_tag.dart';

class NoticeSummaryWidget extends StatefulWidget {
  final NoticeSummary noticeSummary;

  const NoticeSummaryWidget({
    Key? key,
    required this.noticeSummary,
  }) : super(key: key);

  @override
  State<NoticeSummaryWidget> createState() => _NoticeSummaryWidgetState();
}

class _NoticeSummaryWidgetState extends State<NoticeSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.extraColors.grey200!),),),
      child: InkWell(
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding24,
              // Title and Pin icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Flexible(child:
                    Text(
                      widget.noticeSummary.title,
                      style: TextStyles.head4.copyWith(color: context.extraColors.grey900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),),

                  // Pin Icon
                  IconButton(
                    icon: const Icon(CustomIcons.pin),
                    iconSize: 24,
                    color: (widget.noticeSummary.pinYn) ?
                        ColorStyles.mainColor :
                        context.extraColors.grey300,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _switchPin,)
                ],),
              Design.padding12,

              // Notice Body Summary
              Text(
                widget.noticeSummary.contents,
                style: TextStyles.body1.copyWith(color: context.extraColors.grey600),
                textAlign: TextAlign.justify,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,),
              Design.padding16,

              // Writing Date and Writer, Reaction Tag, Comment Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Writing Date & Writer
                  Text(
                      '${TimeUtility.getElapsedTime(widget.noticeSummary.createDate)}'
                      ' • ${widget.noticeSummary.writerNickname}',
                      style: TextStyles.body3.copyWith(color: context.extraColors.grey500),),

                  // Reaction Tag and Comment count
                  Row(
                    children: [
                      // Reaction Tag
                      NoticeReactionTag(
                          noticeId: widget.noticeSummary.noticeId,
                          isChecked: widget.noticeSummary.read,
                          checkerNum: widget.noticeSummary.readCount,
                          enabled: false),
                      Design.padding8,

                      // Comment Count
                      Row(
                        children: [
                          Icon(
                            CustomIcons.comment,
                            color: context.extraColors.grey500,
                            size: 20,),
                          Design.padding(2),

                          Text(
                            '${widget.noticeSummary.commentCount}',
                            style: TextStyles.body2.copyWith(color: context.extraColors.grey600!),),
                        ],),
                    ],),
                ]
              ),
              Design.padding20,
            ],
          ),
        onTap: () {
            Util.pushRoute(context,
                    (context) => NoticeDetailRoute(noticeId: widget.noticeSummary.noticeId));
        },
      ),
    );
  }

  void _switchPin() async {
    // Fast Unsafe State Update
    setState(() { widget.noticeSummary.pinYn = !widget.noticeSummary.pinYn; } );

    // Call API and Verify State
    NoticeSummary.switchNoticePin(widget.noticeSummary.noticeId).then((pinYn) =>
        setState(() { widget.noticeSummary.pinYn = pinYn; })
    );
  }

  @Deprecated('deprecated for #26')
  void _switchCheck() async {
    // Fast Unsafe State Update
    setState(() {
      widget.noticeSummary.read = !widget.noticeSummary.read;
      (widget.noticeSummary.read)? ++widget.noticeSummary.readCount: --widget.noticeSummary.readCount;
    });

    // Call API and Verify State
    Notice.switchCheckNotice(widget.noticeSummary.noticeId).then((value) {
      if (value != widget.noticeSummary.read) {
        setState(() {
          (widget.noticeSummary.read)? --widget.noticeSummary.readCount: ++widget.noticeSummary.readCount;
          widget.noticeSummary.read = value;
        });
      }
    });
  }
}