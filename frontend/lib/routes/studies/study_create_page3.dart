
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_study_app/services/kakao_service.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/buttons/kakao_style_button.dart';

class StudyCreatePage3 extends StatefulWidget {
  final String studyName;
  final String invitingCode;

  const StudyCreatePage3({
    Key? key,
    required this.studyName,
    required this.invitingCode,
  }) : super(key: key);

  @override
  State<StudyCreatePage3> createState() => _StudyCreatePage3State();
}

class _StudyCreatePage3State extends State<StudyCreatePage3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Design.padding(80),

        Text(
          context.local.invitingCode,
          style: TextStyles.head4.copyWith(
            color: context.extraColors.grey900),),
        Design.padding12,

        _invitingCodeBox(),
        Design.padding(120),

        KakaoStyleButton(
          text: context.local.shareInvitingCode,
          onPressed: () {
            HapticFeedback.lightImpact();
            KakaoService.shareInvitingCode(
                context: context,
                studyName: widget.studyName,
                invitingCode: widget.invitingCode);
          },),
      ],
    );
  }

  Widget _invitingCodeBox() {
    return Container(
        width: double.maxFinite,
        height: 68,
        decoration: BoxDecoration(
          color: context.extraColors.inputFieldBackgroundColor,
          borderRadius: Design.borderRadius,),
        child: InkWell(
          borderRadius: Design.borderRadius,
          onTap: _copyCodeToClipboard,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.invitingCode,
                style: TextStyles.head3.copyWith(
                  color: ColorStyles.mainColor,
                  letterSpacing: 4),),
              Design.padding8,

              Icon(
                CustomIcons.add,
                size: 20,
                color: context.extraColors.grey500,),
            ],
          ),
        ),
    );
  }

  void _copyCodeToClipboard() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: widget.invitingCode));
    Toast.showToast(
        context: context,
        message: context.local.copyText2(context.local.invitingCode));
  }
}
