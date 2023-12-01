
import 'package:flutter/material.dart';
import 'package:group_study_app/models/rule.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class RuleWidget extends StatefulWidget {
  final Rule rule;

  final Function(Rule) onUpdateRuleDetail;
  final Function(Rule) onDeleteRule;

  const RuleWidget({
    Key? key,
    required this.rule,
    required this.onUpdateRuleDetail,
    required this.onDeleteRule,
  }) : super(key: key);

  @override
  State<RuleWidget> createState() => _RuleWidgetState();
}

class _RuleWidgetState extends State<RuleWidget> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.rule.detail;

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CustomIcons.check1,
            size: 16,
            color: context.extraColors.grey500),
          Design.padding8,

          Flexible(
            fit: FlexFit.tight,
            child: TextField(
              maxLines: 1,
              maxLength: Rule.ruleMaxLength,
              style: TextStyles.body1.copyWith(
                color: context.extraColors.grey600,),

              controller: _textEditingController,
              decoration: InputDecoration(
                isDense: true,
                hintText: context.local.inputHint1(context.local.rules),
                hintStyle: TextStyles.body1.copyWith(
                  color: context.extraColors.grey400,),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                counterText: "",
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: context.extraColors.grey700!,),),),

              onChanged: (value) => _isEdited = true,
              onTapOutside: (event) => _updateRule(),
              onSubmitted: (value) => _updateRule(),
            ),),
      ],),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateRule() {
    if (_isEdited) {
      widget.rule.detail = _textEditingController.text;

      if (widget.rule.detail.isNotEmpty) {
        widget.onUpdateRuleDetail(widget.rule);
      } else {
        widget.onDeleteRule(widget.rule);
      }

      _isEdited = false;
    }

    _focusNode.unfocus();
    setState(() {});
  }
}