
import 'package:flutter/material.dart';
import 'package:group_study_app/routes/sign_up_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/util.dart';

class SignUpVerifyRoute extends StatefulWidget {
  final String email;

  const SignUpVerifyRoute({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<SignUpVerifyRoute> createState() => _SignUpVerifyRouteState();
}

class _SignUpVerifyRouteState extends State<SignUpVerifyRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const int _verifyNumberLength = 6;

  String verificationCode = "000000";
  List<int> inputCode = List<int>.filled(_verifyNumberLength, -1);

  static const String _titleText = "이메일 인증";
  static const String _confirmText = "확인";
  static const String _resendText = "다시 보내기";
  static const String _fillAllCodeText = "인증 번호를 전부 입력해 주세요";
  static const String _discordCodeText = "인증 번호가 일치하지 않습니다!";

  String _errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_titleText, style: TextStyles.titleSmall,),),
      body: Container(
        alignment: Alignment.center,
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Design.padding30,
            Container(
              padding: Design.edgePadding,
              margin: Design.bottom15,
              color: ColorStyles.grey,
              child: Text(
                "인증 번호를 \"${widget.email}\"주소로 보내드렸어요. 메일에 적혀있는 인증 번호를 아래 빈칸에 입력해 주세요.", //< FIXME is this BEST?
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ),
            Design.padding10,
            Text("인증 번호", style: TextStyles.wideTextStyle),
            Design.padding5,

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < _verifyNumberLength; ++i)
                    _cell(context, i),

                ],
              ),
            ),

            Design.padding15,
            Text(_errorText, style: TextStyles.errorTextStyle,),
            Design.padding30,

            ElevatedButton(
              autofocus: true,
                onPressed: () => checkValidate(context),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: const Text(_confirmText, style: TextStyles.titleSmall,),
                )
            ),
            TextButton(onPressed: _resend, child: const Text(_resendText)),
          ],
        )
      ),
    );
  }

  Widget _cell(BuildContext context, int idx) {
    return Container(
      width: 55,
      padding: Design.edge5,
      child: TextFormField(
        autofocus: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyles.numberTextStyle,
        showCursor: false,
        decoration: const InputDecoration(
          hintText: '*',
          counterText: '',
          hintStyle: TextStyles.numberTextStyle,
        ),
        validator: (value) {
          if (value == "") {
            _errorText = _fillAllCodeText;
            return "";
          }

          _errorText = "";
          return null;
        },
        onChanged: (value) {
          inputCode[idx] = int.parse(value);
          FocusScope.of(context).nextFocus();
        }
      ),
    );
  }

  void checkValidate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String inputCodeStr = inputCode.join();
      if (inputCodeStr.compareTo(verificationCode) == 0) {
        Util.pushRoute(context, (context) => SignUpDetailRoute(email: widget.email));
      }
      _errorText = _discordCodeText;
    }

    setState(() { });
  }

  void _resend() {
    //< FIXME :
    print("resend is called");
  }
}