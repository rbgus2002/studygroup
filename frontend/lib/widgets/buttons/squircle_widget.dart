
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/diagrams/squircle.dart';

class SquircleWidget extends StatelessWidget {
  final Widget? child;
  final double scale;
  final BorderSide? side;
  final Color? backgroundColor;

  const SquircleWidget({
    super.key,
    this.child,
    required this.scale,
    this.side,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale,
      height: scale,
      child: ClipPath.shape(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const SquircleBorder(),
        child: Material(
          color: backgroundColor??context.extraColors.grey200,
          shape: SquircleBorder(
            side: side??BorderSide(color: context.extraColors.grey200!, width: 2)),
          child: child??Image.asset(
              Design.defaultProfileImagePath,
              color: context.extraColors.grey300),)
      ),
    );
  }
}

class SquircleImageWidget extends SquircleWidget {
  SquircleImageWidget({
    super.key,
    required super.scale,
    required String url,
    super.side,
  }) : super(
      child: (url.isNotEmpty) ?
        CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover) :
        null,
  );
}