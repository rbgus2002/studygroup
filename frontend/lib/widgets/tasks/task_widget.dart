import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/task.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/stab_controller.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/tasks/task_check_box.dart';

class TaskWidget extends StatefulWidget {
  final TaskStabController taskStabController;
  final Task task;
  final Color color;
  final Function(Task) onUpdateTaskDetail;
  final Function(Task) onDeleteTask;
  final VoidCallback? onCheckTask;
  final bool isOwner;

  const TaskWidget({
    super.key,
    required this.taskStabController,
    required this.task,
    required this.color,
    required this.onUpdateTaskDetail,
    required this.onDeleteTask,
    this.onCheckTask,
    this.isOwner = false,
  });

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  final _textEditor = TextEditingController();
  final _focusNode = FocusNode();

  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    _textEditor.text = widget.task.detail;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCheckBox(
            task: widget.task,
            activeColor: widget.color,

            onUpdate: _onChecked,
            onClick: widget.onCheckTask,
            enable: widget.isOwner,),
          Design.padding12,

          _taskDetail(),

          (widget.isOwner) ?
            _taskPopupMenu() :
            _stabButton(),
        ],),
    );
  }

  @override
  void dispose() {
    widget.taskStabController.send();

    _textEditor.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _taskDetail() {
    return Flexible(
      fit: FlexFit.tight,
      child: TextField(
        autofocus: _isAdded(),
        minLines: 1,
        maxLines: 10,
        maxLength: Task.taskMaxLength,
        style: TextStyles.task.copyWith(
            color: context.extraColors.grey900,),
        strutStyle: const StrutStyle(
          leading: 0.4,),

        focusNode: _focusNode,
        controller: _textEditor,
        textAlign: TextAlign.justify,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          enabled: widget.isOwner,
          isDense: true,
          hintText: context.local.inputHint2(context.local.task),
          contentPadding: EdgeInsets.zero,
          counterText: "",
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: context.extraColors.grey700!,),),),

        onChanged: (value) => _isEdited = true,
        onTapOutside: (event) {
            // empty && tap outside => delete task
            if (_textEditor.text.isEmpty) {
              _deleteTask();
              setState(() { });
            }},
        onSubmitted: (value) {
            // summit => update or delete task
            if (_isEdited || _textEditor.text.isEmpty) {
              _updateTask();
              setState(() {
                _isEdited = false;
              });
            }},
      ),
    );
  }

  Widget _taskPopupMenu() {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        icon: const Icon(CustomIcons.more_horiz),
        iconSize: 24,
        color: context.extraColors.grey500,
        splashRadius: 10,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          HapticFeedback.lightImpact();
          TwoButtonDialog.showDialog(
            context: context,
            text: widget.task.detail,

            buttonText1: context.local.modify,
            onPressed1: () => _focusNode.requestFocus(),

            buttonText2: context.local.delete,
            onPressed2: () => widget.onDeleteTask(widget.task),);
        }),
    );
  }

  Widget _stabButton() {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        icon: const Icon(CustomIcons.cactus),
        iconSize: 24,
        color: (widget.task.isDone) ?
          context.extraColors.grey400 :
          context.extraColors.grey500,
        splashRadius: 10,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          if (!widget.task.isDone) {
            HapticFeedback.lightImpact();
            widget.taskStabController.stab();
            Toast.showToast(
                context: context,
                message: _getStabMessage(widget.taskStabController.stabCount),);
          }
        },),
    );
  }

  void _onChecked() {
    if (widget.task.taskId == Task.nonAllocatedTaskId) return;

    // Call API and Verify State
    Task.switchTask(widget.task.taskId).then((result) {
      if (result != widget.task.isDone) {
        setState(() => widget.task.isDone = result);
      }
    });
  }

  void _updateTask() {
    widget.task.detail = _textEditor.text;

    // #Case: detail is not empty
    if (widget.task.detail.isNotEmpty) {
      widget.onUpdateTaskDetail(widget.task);
    }

    // #Case: detail is empty;
    else {
      _deleteTask();
    }
  }

  void _deleteTask() {
    widget.onDeleteTask(widget.task);
  }

  String _getStabMessage(int stabCount) {
    if (stabCount == 1) {
      return context.local.stabTaskAbout('');
    }

    else if (stabCount < 5) {
      return context.local.stabTaskAbout('$stabCount${context.local.num} ');
    }
    
    return context.local.stabTaskAbout('$stabCount${context.local.num}${context.local.even} ');
  }

  bool _isAdded() {
    return widget.task.taskId == Task.nonAllocatedTaskId;
  }
}