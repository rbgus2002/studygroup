
import 'package:flutter/material.dart';
import 'package:groupstudy/main.dart';
import 'package:groupstudy/services/auth.dart';

class Util {
  static const int _exceptionTextLength = "Exception: ".length;
  static const Duration textEditingWaitingTime = Duration(milliseconds: 12);

  static Function doNothing() {
    return () {};
  }

  static Future<void> pushRouteByKey(WidgetBuilder builder) async {
    MyApp.navigationKey.currentState?.push(
        MaterialPageRoute(builder: builder));
  }

  static Future<void> pushRoute(BuildContext context, WidgetBuilder builder) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: builder),
    );
  }

  static Future<void> pushRouteAndPopUntil(BuildContext context, WidgetBuilder builder) async {
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: builder),
        (route) => false
    );
  }

  static void popRoute(BuildContext context) {
    Navigator.of(context).pop();
  }

  static SlideTransition _slideUp(BuildContext context, Animation<double> animation,  Animation<double> secondaryAnimation, Widget child) {
    Offset down = const Offset(0.0, 1.0);
    Offset center = Offset.zero;

    var tween = Tween(begin: down, end: center).chain(CurveTween(curve: Curves.ease));

    return SlideTransition(
        position: animation.drive(tween),
        child: child,
    );
  }

  static pushRouteWithSlideUp(BuildContext context, RoutePageBuilder builder) async {
    return await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: builder,
          transitionsBuilder: _slideUp,)
    );
  }

  static Future<void> replaceRouteWithFade(BuildContext context, RoutePageBuilder builder) {
    return Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: builder,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          double begin = 0.0;
          double end = 1.0;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeIn));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      )
    );
  }

  static void delay(VoidCallback function) async {
    Future.delayed(const Duration(milliseconds: 300), function);
  }

  static String getExceptionMessage(Exception e) {
    return e.toString().substring(_exceptionTextLength);
  }

  static bool isOwner(int userId) {
    return (userId == Auth.signInfo?.userId);
  }
}