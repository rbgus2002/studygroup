import 'package:flutter/material.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/date_time_picker_route.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/focused_menu_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/haptic_refresh_indicator.dart';
import 'package:groupstudy/widgets/input_field.dart';
import 'package:groupstudy/widgets/input_field_place.dart';
import 'package:groupstudy/widgets/item_entry.dart';
import 'package:groupstudy/widgets/participant_info_list_widget.dart';
import 'package:groupstudy/widgets/tags/rectangle_tag.dart';

class RoundDetailRoute extends StatefulWidget {
  final int roundSeq;
  final StudyRound studyRound;
  final Function? onRemove;

  const RoundDetailRoute({
    super.key,
    required this.roundSeq,
    required this.studyRound,
    this.onRemove,
  });

  @override
  State<RoundDetailRoute> createState() => _RoundDetailRouteState();
}

class _RoundDetailRouteState extends State<RoundDetailRoute> {
  static const double _iconSize = 32;

  late final TextEditingController _placeEditingController = TextEditingController();
  final GlobalKey<InputFieldState> _detailEditor = GlobalKey();

  final _focusNode = FocusNode();

  bool _isEdited = false;
  bool _isExpended = true;
  
  @override
  void initState() {
    super.initState();
    _tryGetRound();
  }

  @override
  Widget build(BuildContext context) {
    bool scheduled = TimeUtility.isScheduled(widget.studyRound.round.studyTime);
    _placeEditingController.text = widget.studyRound.round.studyPlace;

    return Scaffold(
      appBar: AppBar(
        leading: const SlowBackButton(),
        shape: InputBorder.none,
        actions: [ _roundPopupMenu(), ],),
      body: HapticRefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Round Info & Detail Record
              Container(
                padding: Design.edgePadding,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.extraColors.grey50!,
                      width: 7),),),
                child: Column(
                  children: [
                    // Round Info
                    _roundInfo(),
                    Design.padding12,

                    // Detail Record
                    _detailRecord(),
                    Design.padding12,
                  ],),
              ),

              // Participant Information List
              ParticipantInfoListWidget(
                scheduled: scheduled,
                roundId: widget.studyRound.round.roundId,
                study: widget.studyRound.study,),
            ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _roundDateBoxWidget() {
    return Container(
      width: 46,
      height: 56,
      decoration: BoxDecoration(
        color: widget.studyRound.study.color.withOpacity(0.2),
        borderRadius: Design.borderRadiusSmall,),
      child: InkWell(
        onTap: _editStudyTime,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // if there are studyTime => [ Month, Day ]
            // else => [ -Mon, - ]

            // Month (or date)
            Text(
              (widget.studyRound.round.studyTime != null)?
              '${widget.studyRound.round.studyTime!.month}${context.local.month}' :
              '-${context.local.month}',
              style: TextStyles.body2.copyWith(
                  color: context.extraColors.grey800),),

            // Day (or -)
            Text(
              (widget.studyRound.round.studyTime != null) ?
              '${widget.studyRound.round.studyTime!.day}' :
              '-',
              style: TextStyles.head3.copyWith(
                  color: context.extraColors.grey800),),
          ],),
      ),);
  }

  Widget _roundInfo() {
    return Row(
      children: [
        _roundDateBoxWidget(),
        Design.padding12,

        Flexible(
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Round Sequence (Like 3Round)
              Text(
                '${widget.roundSeq}${context.local.round}',
                style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
              Design.padding4,

              // Time And Place of round
              Row(
                children: [
                  // Study Time (time only like AM 2:20)
                  Icon(CustomIcons.calendar, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  InkWell(
                    onTap: _editStudyTime,
                    child: Text(
                      (widget.studyRound.round.studyTime != null) ?
                        TimeUtility.getTime(widget.studyRound.round.studyTime!) :
                        context.local.inputHint1(context.local.time),
                      style: (widget.studyRound.round.studyTime != null) ?
                        TextStyles.body2.copyWith(color: context.extraColors.grey800) :
                        TextStyles.body2.copyWith(color: context.extraColors.grey800!.withOpacity(0.5)),),
                  ),
                  Design.padding4,

                  // Study Place
                  Icon(CustomIcons.location, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  Expanded(
                    child: InputFieldPlace(
                      placeEditingController: _placeEditingController,
                      onUpdatePlace: _updateStudyPlace,),),
                  Design.padding4,
                ],),
            ]),
        ),

        // Scheduled Tag
        Visibility(
          visible: TimeUtility.isScheduled(widget.studyRound.round.studyTime),
          child: _scheduledTag()),
      ],
    );
  }

  Widget _scheduledTag() {
    return RectangleTag(
      width: 36,
      height: 22,
      color: context.extraColors.pink!,
      text: Text(
        context.local.scheduled,
        style: TextStyles.caption2.copyWith(
          color: context.extraColors.grey800,),),
      onTap: Util.doNothing,
    );
  }

  Widget _detailRecord() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        context.local.record,
        style: TextStyles.head5.copyWith(
            color: context.extraColors.grey900),),
      onExpansionChanged: (value) => setState(() => _isExpended = !_isExpended),
      trailing: AnimatedRotation(
        turns: (_isExpended) ? 0 : 0.5,
        duration: AnimationSetting.animationDurationShort,
        curve: Curves.easeOutCirc,
        child: Icon(
          CustomIcons.chevron_down,
          color: context.extraColors.grey500,),),
      children: [
        InputField(
          key: _detailEditor,
          initText: widget.studyRound.round.detail,
          hintText: context.local.recordHint,
          minLines: 4,
          maxLines: 7,
          maxLength: Round.detailMaxLength,
          focusNode: _focusNode,
          backgroundColor: context.extraColors.grey50,
          onChanged: (input) => _isEdited = true,
          onTapOutSide: _updateDetail,
          counter: true,),
      ],
    );
  }

  Widget _roundPopupMenu() {
    return FocusedMenuButton(
        icon: const Icon(
          CustomIcons.more_vert,
          size: _iconSize,),
        items: [
          ItemEntry(
            text: context.local.deleteRound,
            icon: const Icon(CustomIcons.trash),
            onTap: () => TwoButtonDialog.showDialog(
              context: context,
              text: context.local.deleteRound,

              buttonText1: context.local.no,
              onPressed1: Util.doNothing,

              buttonText2: context.local.delete,
              onPressed2: () => _deleteRound(context),),),
        ]);
  }

  Future<void> _refresh() async {
    _tryGetRound();
  }

  void _updateDetail(PointerDownEvent notUseEvent) {
    if (_isEdited) {
      Round.updateDetail(widget.studyRound.round.roundId, _detailEditor.currentState!.text);
      _isEdited = false;
    }

    _focusNode.unfocus();
  }

  void _updateStudyPlace() {
    widget.studyRound.round.studyPlace = _placeEditingController.text;
    _updateRound(widget.studyRound.round);
  }

  void _editStudyTime() async {
    Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
        DateTimePickerRoute(round: widget.studyRound.round,)).then((value) => _refresh());
  }

  Future<void> _updateRound(Round round) async {
    if (round.roundId == Round.nonAllocatedRoundId) {
      await Round.createRound(round, widget.studyRound.study.studyId);
    }
    else {
      await Round.updateAppointment(round);
    }

    _refresh();
  }

  void _deleteRound(BuildContext context) async {
    try {
      await Round.deleteRound(widget.studyRound.round.roundId).then((result) {
        if (result) {
          Navigator.of(context).pop();

          if (widget.onRemove != null) {
            widget.onRemove!();
          }
        }
      });
    } on Exception catch(e) {
      if (mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _tryGetRound() async {
    try {
      await Round.getDetail(widget.studyRound.round.roundId).then((refreshedRound) =>
        setState(() {
          widget.studyRound.round = refreshedRound;
          _placeEditingController.text = widget.studyRound.round.studyPlace;
          _detailEditor.currentState!.text = widget.studyRound.round.detail??"";
        }));
    } on Exception catch(e) {
      if (mounted) {
        Util.popRoute(context);
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }
}

/// Container for Reference
class StudyRound {
  Study study;
  Round round;

  StudyRound({
    required this.study,
    required this.round,
  });
}