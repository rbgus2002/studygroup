
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtility {
  static const String _confirmText = "확인";
  static const String _cancelText = "취소";

  static String getElapsedTime(DateTime dateTime) {
    final nowTime = DateTime.now();
    final difference = nowTime.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "방금";
    }

    else if (difference.inHours < 1) {
      return '${difference.inMinutes}분전';
    }

    else if (difference.inDays < 1) {
      return '${difference.inHours}시간전';
    }

    else if (nowTime.day - dateTime.day < 2) {
      return '어제';
    }

    if (dateTime.year == nowTime.year) {
      return DateFormat('MM.dd').format(dateTime);
    }

    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  static String timeToString(DateTime dateTime) {
    final nowTime = DateTime.now();

    if (dateTime.year == nowTime.year) {
      return DateFormat("MM/dd HH:mm").format(dateTime);
    }

    return DateFormat("yy/MM/dd HH:mm").format(dateTime);
  }

  static Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return null;

    if (context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly,
        cancelText: _cancelText,
        confirmText: _confirmText,
      );

      if (time == null) return null;

      return DateTime(date!.year, date.month, date.day, time.hour, time.minute);
    }
    return null;
  }
}