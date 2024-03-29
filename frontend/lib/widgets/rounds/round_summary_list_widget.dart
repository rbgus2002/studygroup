import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/list_model.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/widgets/buttons/add_button.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';
import 'package:groupstudy/widgets/rounds/round_summary_widget.dart';

class RoundSummaryListWidget extends StatefulWidget {
  final Study study;

  const RoundSummaryListWidget({
    super.key,
    required this.study
  });

  @override
  State<RoundSummaryListWidget> createState() => RoundSummaryListWidgetState();
}

class RoundSummaryListWidgetState extends State<RoundSummaryListWidget> {
  late GlobalKey<AnimatedListState> _roundListKey;
  late ListModel<Round> _roundListModel;

  late final List<UserProfileSummary> _memberProfileImages;

  @override
  void initState() {
    super.initState();
    _initListModel();

    Study.getMemberProfileSummaries(widget.study.studyId).then((value) =>
      _memberProfileImages = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.local.roundList,
              style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
            AddButton(
                iconData: CustomIcons.plus_square_outline,
                text: context.local.addRound,
                onTap: _addRound),
          ],),
        Design.padding20,

        FutureBuilder(
          future: Round.getRoundList(widget.study.studyId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != _roundListModel.items) {
                _initListModel(rounds: snapshot.data!);
              }

              return AnimatedList(
                padding: EdgeInsets.zero,
                key: _roundListKey,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,

                initialItemCount: _roundListModel.length,
                itemBuilder: _buildItem,);
            }
            return Design.loadingIndicator;
          }),
        
        _studyStartFlagWidget(),
        Design.padding48,
      ],
    );
  }

  void _initListModel({ List<Round>? rounds }) {
    _roundListKey = GlobalKey<AnimatedListState>();
    _roundListModel = ListModel(
        listKey: _roundListKey,
        items: rounds??[],
        removedItemBuilder: _buildRemovedItem);
  }

  void _refresh() {
    setState(() { });
  }

  Widget _buildRemovedItem(
      Round round, BuildContext context, Animation<double> animation) {

    // remove => end -> begin
    var slideToLeft = animation.drive(Tween(
        begin: const Offset(-1.0,0.0),
        end: const Offset(0.0,0.0)));

    return SlideTransition(
      position: slideToLeft,
      child: SizeTransition(
        sizeFactor: animation,
        child: RoundSummaryWidget(
          roundSeq: 0,
          round: round,
          study: widget.study,
          onRemove: _removeRound,
          onChanged: _refresh,
          participantProfileList: _getParticipantProfileList(round)),),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    int roundSeq = _roundListModel.length - index;

    // build => begin -> end
    var slideFromLeft = animation.drive(Tween(
        begin: const Offset(-1.0,0.0),
        end: const Offset(0.0,0.0)));

    return SlideTransition(
        position: slideFromLeft,
        child: SizeTransition(
          sizeFactor: animation,
          child: RoundSummaryWidget(
              roundSeq: roundSeq,
              round: _roundListModel[index],
              study: widget.study,
              onRemove: _removeRound,
              onChanged: _refresh,
              participantProfileList: _getParticipantProfileList(_roundListModel[index]),
          ),),
    );
  }

  List<UserProfileSummary> _getParticipantProfileList(Round round) {
    if (round.participantProfileSummaries != null) {
      return round.participantProfileSummaries!;
    }

    return _memberProfileImages;
  }

  Widget _studyStartFlagWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SquircleWidget(
          scale: 32,
          side: BorderSide.none,
          backgroundColor: ColorStyles.mainColor,
          child: Center(
            child: Icon(
              CustomIcons.cactus,
              size: 16,
              color: context.extraColors.grey000,),),),
        Design.padding8,

        Text(
          context.local.studyStart,
          style: TextStyles.head5.copyWith(
            color: ColorStyles.mainColor)),
      ],
    );
  }

  void _addRound() {
    HapticFeedback.lightImpact();

    // check round limits
    if (_roundListModel.length >= Round.roundLimitedCount) {
      return Toast.showToast(
          context: context,
          message: context.local.roundLimitWarning(Round.roundLimitedCount));
    }

    // check top is not empty round
    if (_isNotAdded()) {
      _addRoundOnTop();
    }
  }

  void _addRoundOnTop() {
    _roundListModel.insert(0,
        Round(roundId: Round.nonAllocatedRoundId,));
  }

  void _removeRound(int roundSeq) {
    int index = _roundListModel.length - roundSeq;
    _roundListModel.removeAt(index);
  }

  bool _isNotAdded() {
    // will add in first(top)
    return (_roundListModel.items.isEmpty ||
        (_roundListModel.items.first.roundId != Round.nonAllocatedRoundId));
  }
}