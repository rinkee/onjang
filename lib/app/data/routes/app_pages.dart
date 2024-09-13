import 'package:get/get.dart';

import 'package:jangboo_flutter/app/initial_screen.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/instroduceLayout.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => InitialScreen()),
    GetPage(
      name: Routes.Home,
      page: () => HomeScreenDesktop(),
    ),
    GetPage(
      name: Routes.Introduce,
      page: () => IntroduceLayout(),
    ),
  ];
}
