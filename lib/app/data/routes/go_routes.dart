import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
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

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: Routes.initial,
      builder: (context, state) => InitialScreen(),
    ),
    GoRoute(
      path: '/home',
      name: Routes.home,
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'customer',
          name: Routes.customer,
          builder: (context, state) => CustomerScreen(),
          routes: [
            GoRoute(
              path: ':id',
              name: Routes.customerEdit,
              builder: (context, state) {
                final id = state.pathParameters['id'];
                return const CustomerEditScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'customer-inactive',
          name: Routes.customerInactive,
          builder: (context, state) => CustomerInactiveScreen(),
        ),
        GoRoute(
          path: 'record/:id',
          name: Routes.record,
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return RecordScreen();
          },
        ),
        GoRoute(
          path: 'user/edit',
          name: Routes.userEdit,
          builder: (context, state) => const EditUserScreen(),
        ),
        GoRoute(
          path: 'setting',
          name: Routes.setting,
          builder: (context, state) => SettingScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/introduce',
      name: Routes.introduce,
      builder: (context, state) => IntroduceScreen(),
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/signin',
      name: Routes.signIn,
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/email',
      name: Routes.email,
      builder: (context, state) => EmailScreen(),
    ),
    GoRoute(
      path: '/password',
      name: Routes.password,
      builder: (context, state) {
        final email = state.extra as String?;
        return PasswordScreen(email: email ?? '');
      },
    ),
  ],
);
