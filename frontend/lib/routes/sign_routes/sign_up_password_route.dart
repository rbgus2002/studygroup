import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_routes/sign_up_detail_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/secondary_button.dart';
import 'package:group_study_app/widgets/input_field.dart';

class SignUpPasswordRoute extends StatefulWidget {
  final String phoneNumber;

  const SignUpPasswordRoute({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SignUpPasswordRoute> createState() => _SignUpPasswordRouteState();
}

class _SignUpPasswordRouteState extends State<SignUpPasswordRoute> {
  final GlobalKey<InputFieldState> _newPasswordEditor = GlobalKey();
  final GlobalKey<InputFieldState> _newPasswordConfirmEditor = GlobalKey();

  String _newPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          children: [
            Text(
              Util.str(context).inputPassword,
              style: TextStyles.head2,),
            Design.padding48,

            InputField(
              key: _newPasswordEditor,
              obscureText: true,
              hintText: Util.str(context).password,
              maxLength: Auth.passwordMaxLength,
              validator: _newPasswordValidator,
              onChanged: (input) => _newPassword = input,
            ),
            Design.padding16,

            InputField(
              key: _newPasswordConfirmEditor,
              obscureText: true,
              hintText: Util.str(context).confirmPassword,
              validator: _newPasswordConfirmValidator,
              maxLength: Auth.passwordMaxLength,
            ),
            Design.padding(132),

            SecondaryButton(
              text: Util.str(context).start,
              onPressed: _tryResetPassword,),
          ],
        ),
      ),
    );
  }

  String? _newPasswordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Util.str(context).inputHint2(Util.str(context).password);
    }
    return null;
  }

  String? _newPasswordConfirmValidator(String? input) {
    if (input == null || input != _newPassword) {
      return Util.str(context).mismatchPassword;
    }
    return null;
  }

  void _tryResetPassword() async {
    if (_newPasswordEditor.currentState!.validate() &&
        _newPasswordConfirmEditor.currentState!.validate()) {
      Util.pushRoute(context, (context) =>
          SignUpDetailRoute(
            phoneNumber: widget.phoneNumber,
            password: _newPassword,
          ));
    }
  }
}