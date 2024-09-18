import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/initial_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_inactive_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_edit_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/record_screen.dart';
import 'package:jangboo_flutter/app/ui/web/home/home_screen.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/introduce_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/email_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/password_screen.dart';
import 'package:jangboo_flutter/app/ui/web/login/sign_in_screen.dart';
import 'package:jangboo_flutter/app/ui/web/user/edit_user_screen.dart';
import 'package:jangboo_flutter/app/ui/web/setting/setting_screen.dart';

final AuthService _authService = Get.find<AuthService>();
final router = GoRouter(
  // refreshListenable: _authService.isLoggedIn(),
  redirect: (context, GoRouterState state) async {
    var currentPath = state.uri.path;
    final bool isIntroducePage = state.uri.path == Paths.introduce;
    final bool isLoginPage = state.uri.path == Paths.login;
    final bool isSignInPage = state.uri.path == Paths.signIn;
    final bool isPasswordPage = state.uri.path == Paths.password;
    final bool isEmailPage = state.uri.path == Paths.email;

    if (await _authService.isLoggedIn() == false &&
        !isIntroducePage &&
        !isLoginPage &&
        !isSignInPage &&
        !isPasswordPage &&
        !isEmailPage) {
      return Paths.introduce;
    }

    // 로그인, 회원가입, 비밀번호, 이메일 페이지는 자유롭게 접근 가능
    if (isLoginPage || isSignInPage || isPasswordPage || isEmailPage) {
      return null;
    }

    // 그 외의 경우 리다이렉트하지 않음
    return null;
    // if (await _authService.isLoggedIn() == false) {
    //   print('redirect no user');
    //   if (state.name == Routes.initial) {
    //     print('current page is init');
    //     return null;
    //   }
    //   // return '/';
    // } else {
    //   print('redirect go to null');
    //   if (state.name == Routes.initial) {
    //     return null;
    //   }
    //   return null;
    // }
    print(state.uri.path);
    print(Routes.login);
    print(Paths.login);
    print(state.uri.path == Paths.login);
  },
  routes: [
    GoRoute(
      path: Paths.initial,
      name: Routes.initial,
      builder: (context, state) => InitialScreen(),
    ),
    GoRoute(
      path: Paths.home,
      name: Routes.home,
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: Paths.customer,
          name: Routes.customer,
          builder: (context, state) => CustomerScreen(),
          routes: [
            GoRoute(
              path: Paths.customerEdit,
              name: Routes.customerEdit,
              builder: (context, state) {
                final id = state.pathParameters['id'];
                return const CustomerEditScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: Paths.customerInactive,
          name: Routes.customerInactive,
          builder: (context, state) => CustomerInactiveScreen(),
        ),
        GoRoute(
          path: Paths.record,
          name: Routes.record,
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return RecordScreen();
          },
        ),
        GoRoute(
          path: Paths.userEdit,
          name: Routes.userEdit,
          builder: (context, state) {
            return const EditUserScreen();
          },
        ),
        GoRoute(
          path: Paths.setting,
          name: Routes.setting,
          builder: (context, state) => SettingScreen(),
        ),
      ],
    ),
    GoRoute(
      path: Paths.introduce,
      name: Routes.introduce,
      builder: (context, state) => IntroduceScreen(),
    ),
    GoRoute(
      path: Paths.login,
      name: Routes.login,
      builder: (context, state) => LoginScreen(),
    ),
    // GoRoute(
    //   path: Paths.signIn,
    //   name: Routes.signIn,
    //   builder: (context, state) => SignInScreen(),
    // ),
    GoRoute(
      path: Paths.email,
      name: Routes.email,
      builder: (context, state) => EmailScreen(),
    ),
    GoRoute(
      path: Paths.password,
      name: Routes.password,
      // redirect: (context, state) {
      //   final email = state.extra as String?;
      //   if (email == null || email.isEmpty) {
      //     // email이 없으면 email 페이지로 리다이렉트
      //     print('email null !!');
      //     return Paths.email;
      //   }
      //   // email이 있으면 리다이렉트하지 않음
      //   return null;
      // },
      builder: (context, state) {
        final email = state.extra as String;

        return PasswordScreen(email: email);
      },
    ),
  ],
);
