
import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/studies/study_participating_route.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/input_field.dart';

class StudyCreatePage1 extends StatefulWidget {
  final Function(String, String) getNext;
  final String studyName;
  final String studyDetail;

  const StudyCreatePage1({
    super.key,
    required this.getNext,
    required this.studyName,
    required this.studyDetail,
  });

  @override
  State<StudyCreatePage1> createState() => _StudyCreatePage1State();
}

class _StudyCreatePage1State extends State<StudyCreatePage1> {
  final GlobalKey<InputFieldState> _studyNameEditor = GlobalKey();
  final GlobalKey<InputFieldState> _studyDetailEditor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Design.padding(88),

        Text(
          context.local.studyName,
          style: TextStyles.head5.copyWith(
            color: context.extraColors.grey900,),),
        Design.padding8,

        InputField(
          key: _studyNameEditor,
          initText: widget.studyName,
          hintText: context.local.inputHint1(context.local.studyName),
          maxLength: Study.studyNameMaxLength,
          counter: true,
          validator: _studyNameValidator,),
        Design.padding12,

        Text(
          context.local.studyDetail,
          style: TextStyles.head5.copyWith(
            color: context.extraColors.grey900,),),
        Design.padding8,

        InputField(
          key: _studyDetailEditor,
          initText: widget.studyDetail,
          hintText: context.local.inputHint1(context.local.studyDetail),
          maxLength: Study.studyDetailMaxLength,
          minLines: 3,
          maxLines: 3,
          counter: true,
          validator: _studyDetailValidator,),
        Design.padding(172),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: Text(context.local.participateByCode),
              onPressed: () => Util.pushRoute(context, (context) =>
                  const StudyParticipantRoute()),),
            Design.padding4,

            PrimaryButton(
              text: context.local.next,
              onPressed: () => _getNext(),),
          ],),
      ],);
  }

  void _getNext() {
    if (_studyNameEditor.currentState!.validate() &&
        _studyDetailEditor.currentState!.validate()) {

      widget.getNext(
        _studyNameEditor.currentState!.text,
        _studyDetailEditor.currentState!.text,);
    }
  }

  String? _studyNameValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.studyName);
    }
    return null;
  }

  String? _studyDetailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return context.local.inputHint1(context.local.studyDetail);
    }
    return null;
  }
}