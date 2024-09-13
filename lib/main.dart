import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:jangboo_flutter/app/data/routes/app_pages.dart';

import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/controller/home_menu_controller.dart';
import 'package:jangboo_flutter/app/ui/web/demo/demo_home.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/instroduceLayout.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/introduceScreen.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/sign_in_screen.dart';

import 'package:jangboo_flutter/app/initial_screen.dart';
import 'package:motion/motion.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Motion.instance.initialize();
  // if (kIsWeb) {
  // } else {
  //   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //     await DesktopWindow.setWindowSize(
  //         const Size(1000, 800)); // 가로 사이즈, 세로 사이즈 기본 사이즈 부여
  //     await DesktopWindow.setMinWindowSize(const Size(900, 600)); // 최소 사이즈 부여
  //     await DesktopWindow.setMaxWindowSize(const Size(1500, 1200)); // 최대 사이즈 부여
  //   }
  // }

  await Supabase.initialize(
    url: 'https://rvombewznfvotchxajxu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2b21iZXd6bmZ2b3RjaHhhanh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4Njg2NjksImV4cCI6MjAyMDQ0NDY2OX0.HAIdDrLDOth-0R3_bW9TvIoYZePQoTUvP4qqm8foTLo',
  );
  await Get.putAsync(() => AuthService().init());
  Get.put(UserController());
  Get.put(HomeMenuController());
  Get.put(CustomerContentController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.INITIAL,
      getPages: AppPages.pages,
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: sgColor,
            background: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.grey),
              backgroundColor: Colors.grey[900])),
    );
  }
}
