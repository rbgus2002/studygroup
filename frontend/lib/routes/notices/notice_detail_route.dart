import 'package:flutter/material.dart';
import 'package:groupstudy/models/comment.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/routes/notices/notice_edit_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/comment_widget.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/haptic_refresh_indicator.dart';
import 'package:groupstudy/widgets/input_field.dart';
import 'package:groupstudy/widgets/tags/notice_reaction_tag.dart';

class NoticeDetailRoute extends StatefulWidget {
  final NoticeSummary noticeSummary;
  final int studyId;
  final VoidCallback onDelete;

  const NoticeDetailRoute({
    super.key,
    required this.noticeSummary,
    required this.studyId,
    required this.onDelete,
  });

  @override
  State<NoticeDetailRoute> createState() => _NoticeDetailRouteState();
}

class _NoticeDetailRouteState extends State<NoticeDetailRoute> {
  static const double _iconSize = 28;

  final GlobalKey<InputFieldState> _commentEditor = GlobalKey();
  late final focusNode = FocusNode();

  late Future<CommentsInfo> _futureCommentInfo;
  List<Comment> _comments = [];
  int _replyTo = Comment.noReplyTarget;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _futureCommentInfo = Comment.getComments(widget.noticeSummary.notice.noticeId);
    _tryGetNotice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: InputBorder.none,
        leading: const SlowBackButton(),
        actions: _noticePopupMenus(),),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: HapticRefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                physics: const AlwaysScrollableScrollPhysics(),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
                      _noticeBody(),
                      _commentList(),
                    ]),
                ),
            ),),
          ),
          _writingCommentBox(),
        ],),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 40,),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _futureCommentInfo = Comment.getComments(widget.noticeSummary.notice.noticeId);
    _tryGetNotice();
  }

  List<Widget>? _noticePopupMenus() {
    if (_isWriter()) {
      return [
        IconButton(
          icon: const Icon(CustomIcons.writing_outline),
          iconSize: _iconSize,
          onPressed: () => _editNotice(),),

        IconButton(
          icon: const Icon(CustomIcons.trash),
          iconSize: _iconSize,
          onPressed: () => _showDeleteNoticeDialog(context)),
      ];
    }
    return null;
  }

  bool _isWriter() {
    return widget.noticeSummary.notice.writerId == Auth.signInfo?.userId;
  }

  Widget _noticeBody() {
    return Container(
      width: double.maxFinite,
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.extraColors.grey100!,
            width: 4,),),),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding8,

            // Writing Date and Writer Nickname
            Text(
              '${TimeUtility.getElapsedTime(context, widget.noticeSummary.notice.createDate)} '
                  '${widget.noticeSummary.notice.writerNickname}',
              style: TextStyles.body2.copyWith(
                  color: context.extraColors.grey500)),
            Design.padding12,

            // Title
            SelectableText(
              widget.noticeSummary.notice.title,
              style: TextStyles.head3.copyWith(
                  color: context.extraColors.grey900),
              textAlign: TextAlign.justify,),
            Design.padding8,

            // Body
            SelectableText(
              widget.noticeSummary.notice.contents,
              style: TextStyles.body1.copyWith(
                  color: context.extraColors.grey800),
              textAlign: TextAlign.justify,),
            Design.padding16,

            // Reaction Tag
            NoticeReactionTag(
                notice: widget.noticeSummary.notice,),
          ],),
    );
  }

  Widget _commentList() {
    return FutureBuilder(
        future: _futureCommentInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int commentCount = snapshot.data!.count;
            _comments = snapshot.data!.comments;

            // update value for notice list
            widget.noticeSummary.commentCount = commentCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Design.padding16,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${context.local.comment} $commentCount',
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey900),),),
                Design.padding12,

                ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _comments.length,
                    itemBuilder: (context, index) =>
                        CommentWidget(
                            comment: _comments[index],
                            studyId: widget.studyId,
                            index: index,
                            isSelected: (_replyTo == index),
                            setReplyTo: _setReplyTo,
                            onDelete: _deleteComment),
                    separatorBuilder: (context, index) =>
                        Design.padding4,),
              ],);
          }
          return const SizedBox();
        }
    );
  }

  void _showDeleteNoticeDialog(BuildContext context) {
    TwoButtonDialog.showDialog(
        context: context,
        text: context.local.confirmDeleteNotice,

        buttonText1: context.local.delete,
        onPressed1: _deleteNotice,

        buttonText2: context.local.cancel,
        onPressed2: Util.doNothing,
    );
  }

  Widget _writingCommentBox() {
    return Container(
      padding: Design.edge8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: context.extraColors.grey200!,
            width: 1),),),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: InputField(
              key: _commentEditor,
              minLines: 1,
              maxLines: 5,
              maxLength: Comment.commentMaxLength,
              focusNode: focusNode,
              hintText: context.local.inputHint1(context.local.comment),
              onTapOutSide: (event) => Util.doNothing(),),),
          IconButton(
            icon: const Icon(CustomIcons.send, size: 24),
            color: ColorStyles.mainColor,
            splashRadius: 16,
            onPressed: _writeComment,),
        ],),
    );
  }

  void _setReplyTo(int index) {
    setState(() {
      // #Case : double check => uncheck
      if (_replyTo == index) {
        focusNode.unfocus();
        _replyTo = Comment.noReplyTarget;
      }
      // #Case : Single check
      else {
        focusNode.requestFocus();
        _replyTo = index;
      }
    });
  }

  void _writeComment() async {
    if (_commentEditor.currentState!.text.isNotEmpty) {
      if (!_isProcessing) {
        _isProcessing = true;

        try {
          int? parentCommentId = _getParentId();
          await Comment.writeComment(
              widget.noticeSummary.notice.noticeId, _commentEditor.currentState!.text,
              parentCommentId).then((newCommentId) {
            // Reset writing box and reply target
            focusNode.unfocus();
            _commentEditor.currentState!.text = "";
            _replyTo = Comment.noReplyTarget;

            _refresh();
          });
        } on Exception catch (e) {
          if (context.mounted) {
            Toast.showToast(
              context: context,
              message: Util.getExceptionMessage(e));
          }
        }

        _isProcessing = false;
      }
    }

    // non-validated
    else {
      Toast.showToast(
          context: context,
          message: context.local.inputHint1(context.local.comment));
    }
  }

  void _deleteComment(int commentId) async {
    try {
      await Comment.deleteComment(commentId).then((result) =>
          _refresh());
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _deleteNotice() async {
    try {
      await Notice.deleteNotice(widget.noticeSummary.notice.noticeId).then((result) {
        if (result) {
          widget.onDelete();
          Navigator.of(context).pop();
        }
      });
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _editNotice() {
    Util.pushRoute(context, (context) =>
      NoticeEditRoute(noticeSummary: widget.noticeSummary, studyId: widget.studyId,),);
  }

  int? _getParentId() {
    return (_replyTo != Comment.noReplyTarget) ?
        _comments[_replyTo].commentId
        : null;
  }

  void _tryGetNotice() async {
    try {
      await Notice.getNotice(widget.noticeSummary.notice.noticeId).then((refreshedNotice) {
        setState(() => widget.noticeSummary.notice = refreshedNotice);
      });
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
