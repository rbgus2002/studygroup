import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/routes/notices/notice_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';

class CreateNoticeRoute extends StatelessWidget {
  final _fromKey = GlobalKey<FormState>();

  final int studyId;

  String _title = "";
  String _contents = "";

  bool _isProcessing = false;

  CreateNoticeRoute({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _completeButton(context),
        ],
      ),
      body: Container(
        padding: Design.edgePadding,
        child: SingleChildScrollView(
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                Design.padding12,

                // [Title]
                TextFormField(
                  style: TextStyles.head3.copyWith(
                    color: context.extraColors.grey900),
                  maxLength: Notice.titleMaxLength,
                  textAlign: TextAlign.justify,
                  onChanged: (text) => _title = text,
                  validator: (input) =>
                    (input == null || input.isEmpty)?
                      context.local.inputHint1(context.local.title) : null,
                  decoration: InputDecoration(
                    hintText: context.local.inputHint1(context.local.title),
                    hintStyle: TextStyles.head3.copyWith(
                        color: context.extraColors.grey400),
                    border: InputBorder.none,
                    counterText: "",
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.errorColor),),
                  ),),
                Design.padding16,

                // [Contents]
                TextFormField(
                  style: TextStyles.body1.copyWith(
                      color: context.extraColors.grey900,),
                  maxLines: 8,
                  maxLength: Notice.contentsMaxLength,
                  textAlign: TextAlign.justify,
                  onChanged: (text) => _contents = text,
                  validator: (input) =>
                    (input == null || input.isEmpty)?
                      context.local.inputHint1(context.local.content) : null,
                  decoration: InputDecoration(
                    hintText: context.local.inputHint1(context.local.content),
                    hintStyle: TextStyles.body1.copyWith(
                        color: context.extraColors.grey400),
                    border: InputBorder.none,
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorStyles.errorColor),),
                  ),),
            ]),
          ),),
      ),
    );
  }

  Widget _completeButton(BuildContext context) {
    return TextButton(
        onPressed: () => _writeNotice(context),
        child: Text(
          context.local.complete,
          style: TextStyles.head5.copyWith(
            color: ColorStyles.mainColor),),
    );
  }

  void _writeNotice(BuildContext context) async {
    if (_fromKey.currentState!.validate()) {
      if (!_isProcessing) {
        try {
          _isProcessing = true;
          await Notice.createNotice(_title, _contents, studyId).then((
              newNoticeId) {
            if (newNoticeId != Notice.noticeCreationError) {
              Navigator.of(context).pop();
              Util.pushRoute(
                  context, (context) =>
                  NoticeDetailRoute(noticeId: newNoticeId));
            }
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
  }
}