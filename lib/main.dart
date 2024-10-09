import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/controller/setting_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/routes/go_routes.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:motion/motion.dart';
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
  Get.put(CustomerController());
  Get.put(SettingController());
  // Get.put(DemoController());
  if (kIsWeb) {
    MetaSEO().config();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp.router(
      // initialRoute: Routes.initial,
      // getPages: AppPages.pages,
      routerDelegate: router.routerDelegate,
      backButtonDispatcher: router.backButtonDispatcher,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      title: '모두의장부',
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
          textTheme: GoogleFonts.notoSansNKoTextTheme(textTheme),
          colorScheme: ColorScheme.fromSeed(
            seedColor: sgColor,
            background: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.notoSansNKo(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              iconTheme: IconThemeData(color: Colors.grey),
              backgroundColor: Colors.grey[900])),
    );
  }
}
