

import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/studies/study_create_page1.dart';
import 'package:group_study_app/routes/studies/study_create_page2.dart';
import 'package:group_study_app/routes/studies/study_create_page3.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/progress_bar_widget.dart';
import 'package:image_picker/image_picker.dart';

class StudyCreateRoute extends StatefulWidget {
  const StudyCreateRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StudyCreateRoute> createState() => _StudyCreateRouteState();
}

class _StudyCreateRouteState extends State<StudyCreateRoute> {
  final GlobalKey<ProgressBarWidgetState> _progressController = GlobalKey();

  String _studyName = "";
  String _studyDetail = "";
  Color _studyColor = ColorStyles.mainColor;
  XFile? _profileImage;

  final int _pageCount = 3;
  int _page = 1;

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: ProgressBarWidget(
              key: _progressController,
              initProgress: _getProgress()),),),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding4,
            Text(
              (_page == 3)?
                context.local.startStudyWithFriend :
                context.local.setStudyInfo,
              style: TextStyles.head2.copyWith(
                color: context.extraColors.grey800,),),

            (_page == 1) ?
              StudyCreatePage1(getNext: _getStudyNameAndDetail,) :
            (_page == 2) ?
              StudyCreatePage2(getNext: _getStudyColorAndImage,) :
            (_page == 3) ?
              const StudyCreatePage3(inviteCode: 866990) : const SizedBox(), //< FIXME
          ],),),
    );
  }

  void _getStudyNameAndDetail(String studyName, String studyDetail) {
    if (_page == 1) {
      _studyName = studyName;
      _studyDetail = studyDetail;

      _pageRouteTo(2);
    }
  }

  void _getStudyColorAndImage(Color studyColor, XFile? profileImage) {
    if (_page == 2) {
      _studyColor = studyColor;
      _profileImage = profileImage;

      _createStudy();
    }
  }

  void _pageRouteTo(int page) {
    setState(() {
      _page = page;
      _progressController.currentState!.progress = _getProgress();
    });
  }

  void _createStudy() async {
    if (!_isProcessing) {
      _isProcessing = true;

      try {
        await Study.createStudy(
            studyName: _studyName,
            studyDetail: _studyDetail,
            studyColor: _studyColor,
            studyImage: _profileImage).then(
                (value) => _pageRouteTo(3));
      } on Exception catch(e) {
        if (mounted) {
          Toast.showToast(
              context: context,
              message: Util.getExceptionMessage(e));
        }
      }

      _isProcessing = false;
    }
  }

  double _getProgress() {
    return _page / _pageCount;
  }
}
