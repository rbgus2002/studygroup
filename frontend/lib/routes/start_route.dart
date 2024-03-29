
import 'package:flutter/material.dart';
import 'package:groupstudy/routes/sign_routes/sign_in_route.dart';
import 'package:groupstudy/routes/sign_routes/sign_up_verify_route.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';

class StartRoute extends StatelessWidget {
  const StartRoute({ super.key, });

  @override
  Widget build(BuildContext context) {
    TextStyle appNameStyle = TextStyles.startTitle.copyWith(
        color: ColorStyles.mainColor,
        fontWeight: TextStyles.black,
        fontSize: 32,
        height: 1);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Character
            Positioned(
              top: 300,
              child: Image.asset(
                Design.characterImagePath,
                scale: 2,),),

            // Cloud
            Positioned(
              top: 528,
              child: Image.asset(
                Design.cloudImagePath,
                color: context.extraColors.inputFieldBackgroundColor,
                scale: 2,),),
            Container(
              margin: const EdgeInsets.only(top: 644),
              color: context.extraColors.inputFieldBackgroundColor,
              width: 420,
              height: 600,),

            // Text And Button
            Container(
              padding: Design.edgePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Design.padding(100),

                  // Title Text
                  SizedBox(
                    width: double.maxFinite,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyles.startTitle.copyWith(color: context.extraColors.grey800),
                        children: [
                          TextSpan(
                              text: context.local.appDescriptionFront),
                          TextSpan(
                              text: '“${context.local.appName}”',
                              style: appNameStyle),
                          TextSpan(
                              text: context.local.appDescriptionBack),
                        ]
                      ),),),
                  const Spacer(),

                  // start(sing up) button
                  PrimaryButton(
                    text: context.local.start,
                    onPressed: () => Util.pushRoute(context, (context) =>
                    const SignUpRoute()),),
                  Design.padding4,

                  // sing in button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.local.alreadyHaveAnAccount,
                        style: TextStyles.head5.copyWith(color: context.extraColors.grey500),),

                      TextButton(
                        onPressed: () => Util.pushRoute(context, (context) => const SignInRoute()),
                        child : Text(context.local.signIn),),
                    ],),

                  // bottom margin
                  Design.padding28,
                ],),),
          ],)
      ),
    );
  }
}