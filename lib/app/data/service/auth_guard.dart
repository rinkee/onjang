import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';

class AuthGuard extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();
  @override
  RouteSettings? redirect(String? route) {
    if (_authService.userId == null)
      return const RouteSettings(name: Routes.introduce);
    return null;
  }
}
