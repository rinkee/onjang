import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends StatelessWidget {
  final AuthService _authService = Get.find<AuthService>();
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2)); // 스플래시 화면 표시 시간

    if (await _authService.isLoggedIn()) {
      await _userController.loadUserData();
      if (_userController.user.value != null) {
        // Get.offAllNamed(Routes.home);
        // context.push("/home");
        context.pushReplacementNamed('home');
        print('go to home');
      } else {
        // Get.offAllNamed(Routes.introduce);
        context.pushReplacementNamed('introduce');
        print('go to intro without user data');
      }
    } else {
      // Get.offAllNamed(Routes.introduce);
      context.pushReplacementNamed('introduce');
      print('go to intro without login data');
    }
  }
}
