

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:groupstudy/models/sign_info.dart';
import 'package:groupstudy/routes/splash_route.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/flavor.dart';
import 'package:groupstudy/services/kakao_service.dart';
import 'package:groupstudy/services/message_service.dart';
import 'package:groupstudy/services/uri_link_service.dart';
import 'package:groupstudy/themes/app_theme.dart';
import 'package:groupstudy/utilities/extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalizationExtension.init();
  MessageService.init();
  KakaoService.init();
  UriLinkService.init();
  AppTheme.init();

  await Flavor.init((flavor) {
    // for base url
    DatabaseService.init(flavor);
    // for sign key
    SignInfo.init(flavor);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  const MyApp({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.themeMode,
      builder: (context, themeMode, child) =>
        MaterialApp(
          home: const SplashRoute(),
          navigatorKey: navigationKey,

          themeMode: themeMode,
          theme: AppTheme.themeData,
          darkTheme: AppTheme.darkThemeData,

          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
    );
  }
}