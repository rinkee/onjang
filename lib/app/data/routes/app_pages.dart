import 'package:get/get.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/data/service/auth_guard.dart';
import 'package:jangboo_flutter/app/initial_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_inactive_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_edit_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/record_screen.dart';
import 'package:jangboo_flutter/app/ui/web/demo/demo_customer.dart';
import 'package:jangboo_flutter/app/ui/web/demo/demo_home.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/instroduce_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/email_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/password_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/sign_in_screen.dart';
import 'package:jangboo_flutter/app/ui/web/user/edit_user_screen.dart';

import 'package:jangboo_flutter/app/ui/web/setting/setting_screen.dart';

import 'package:jangboo_flutter/app/ui/web/user/user_screen.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => InitialScreen()),
    GetPage(
        middlewares: [AuthGuard()],
        name: Routes.home,
        page: () => HomeScreen()),
    GetPage(name: Routes.introduce, page: () => IntroduceScreen()),

    // 고객
    GetPage(
        middlewares: [AuthGuard()],
        name: Routes.customer,
        page: () {
          var customer = Get.arguments as CustomerModel?;
          return CustomerScreen(
            customer: Get.arguments,
          );
        }),
    GetPage(
      middlewares: [AuthGuard()],
      name: Routes.customerInfo,
      page: () {
        var customerId = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
        return CustomerEditScreen(customerId: customerId);
      },
    ),
    GetPage(
        middlewares: [AuthGuard()],
        name: Routes.customerInactive,
        page: () => CustomerInactiveScreen()),
    GetPage(
      middlewares: [AuthGuard()],
      name: Routes.record,
      page: () {
        var customerId = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
        return RecordScreen(customerId: customerId);
      },
    ),

    //Auth
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.signIn, page: () => SignInScreen()),
    GetPage(name: Routes.email, page: () => EmailScreen()),
    GetPage(
        name: Routes.password,
        page: () {
          var email = Get.arguments as String;
          return PasswordScreen(
            email: email,
          );
        }),

    //유저
    GetPage(
        middlewares: [AuthGuard()],
        name: Routes.user,
        page: () => UserScreen()),
    GetPage(
        middlewares: [AuthGuard()],
        name: Routes.userEdit,
        page: () => EditUserScreen()),
    GetPage(
        middlewares: [AuthGuard()],
        name: Routes.setting,
        page: () => SettingScreen()),

    //데모
    // GetPage(name: Routes.demoHome, page: () => DemoHome()),
    // GetPage(
    //   name: Routes.demoCustomer,
    //   page: () => DemoCustomer(
    //     customer: Get.arguments['customer'],
    //     balanceLog: Get.arguments['balanceLog'],
    //   ),
    // ),
  ];
}
