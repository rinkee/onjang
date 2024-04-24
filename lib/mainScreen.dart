import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_icon_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/k_menu_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/k_menu_child_btn.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/navigation_controller.dart';
import 'package:jangboo_flutter/controller/screen_controller.dart';
import 'package:jangboo_flutter/customer/customer_desktop.dart';
import 'package:jangboo_flutter/customer/customer_screen_desktop.dart';
import 'package:jangboo_flutter/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/layout/desktopLayout.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:jangboo_flutter/user/user_screen_desktop.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final navigationController = Get.put(NavigationController()); // 컨트롤러 인스턴스화
  final screenCtr = Get.put(ScreenController());
  final customerCtr = Get.put(CustomerContentController());
  final userCtr = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1400,
      child: SizedBox(
        width: 996,
        height: 588,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('대장'),
            leading: const SizedBox(),
          ),
          body: const HomeScreenDesktop(),
        ),
      ),
    );
  }
}
