import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_color_styles.dart';

class OldDesign{
  static const String defaultImagePath = 'assets/images/default_profile.png';

  static const double padding = 15;
  static const double borderRadius = 10;

  static const EdgeInsets edge5 = EdgeInsets.all(5.0);
  static const EdgeInsets edge10 = EdgeInsets.all(10.0);
  static const EdgeInsets edge15 = EdgeInsets.all(15.0);
  static const EdgeInsets edgePadding = edge15;

  static const EdgeInsets bottom10 = EdgeInsets.only(bottom: 10.0);
  static const EdgeInsets bottom15 = EdgeInsets.only(bottom: 15.0);

  static const SizedBox padding3 = SizedBox(width: 3, height: 3,);
  static const SizedBox padding5 = SizedBox(width: 5, height: 5,);
  static const SizedBox padding10 = SizedBox(width: 10, height: 10,);
  static const SizedBox padding15 = SizedBox(width: 15, height: 15,);
  static const SizedBox padding30 = SizedBox(width: 30, height: 30,);
  static const SizedBox padding60 = SizedBox(width: 60, height: 60,);

  static const List<BoxShadow> basicShadows = [ BoxShadow(
      color: OldColorStyles.shadow,
      spreadRadius: 1,
      blurRadius: 2,
      offset: Offset(2, 2),
    )];

  static const Widget loadingIndicator = SizedBox(
      height: 128,
      child: Center(
        child: CircularProgressIndicator()
      )
    );
}