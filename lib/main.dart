import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/screen_controller.dart';
import 'package:jangboo_flutter/home/home_screen.dart';
import 'package:jangboo_flutter/home/home_screen2.dart';
import 'package:jangboo_flutter/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/login/login_screen.dart';
import 'package:jangboo_flutter/login/sign_in_screen.dart';
import 'package:jangboo_flutter/mainScreen.dart';
import 'package:jangboo_flutter/splash.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(
        const Size(1000, 800)); // 가로 사이즈, 세로 사이즈 기본 사이즈 부여
    await DesktopWindow.setMinWindowSize(const Size(900, 600)); // 최소 사이즈 부여
    await DesktopWindow.setMaxWindowSize(const Size(1500, 1200)); // 최대 사이즈 부여
  }

  await Supabase.initialize(
    url: 'https://rvombewznfvotchxajxu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2b21iZXd6bmZ2b3RjaHhhanh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4Njg2NjksImV4cCI6MjAyMDQ0NDY2OX0.HAIdDrLDOth-0R3_bW9TvIoYZePQoTUvP4qqm8foTLo',
  );
  Get.put(AuthController());
  Get.put(ScreenController());
  Get.lazyPut(() => CustomerContentController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      theme: ThemeData(

          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(
            seedColor: sgColor,
            background: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.blueGrey[900])),
      home: const SplashScreen(),
    );
  }
}
