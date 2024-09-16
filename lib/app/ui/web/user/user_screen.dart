import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AuthService _authService = Get.find<AuthService>();
  final UserController _userCtr = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                width: 120,
                height: 45,
                child: ButtonWidget(
                    onTap: () async {
                      Get.toNamed(Routes.userEdit);
                    },
                    child: const Center(
                      child: Text('내 정보 수정'),
                    ))),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '설정',
              style: menuTitle,
            ),
            const Gap(30),
            InfoContent(
              title: '로그인 정보',
              child: Text(
                supabase.auth.currentUser!.email.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            InfoContent(
                title: '내 이름',
                child: Obx(
                  () => Text(
                    _userCtr.user.value!.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            InfoContent(
                title: '내 가게명',
                child: Obx(
                  () => Text(
                    _userCtr.user.value!.storeName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Divider(),
            ),
            SizedBox(
                width: 120,
                height: 45,
                child: ButtonWidget(
                    onTap: () async {
                      await _authService.logout();
                    },
                    child: const Center(
                      child: Text('로그아웃'),
                    ))),
          ],
        ),
      ),
    );
  }
}

class InfoTextFiled extends StatelessWidget {
  const InfoTextFiled({
    super.key,
    required this.ctr,
  });

  final TextEditingController ctr;

  @override
  Widget build(BuildContext context) {
    return BorderContainerWidget(
      w: Get.width / 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: TextField(
          controller: ctr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(border: InputBorder.none),
        )),
      ),
    );
  }
}

class InfoContent extends StatelessWidget {
  const InfoContent({
    super.key,
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
        const Gap(5),
        child,
        const Gap(10),
      ],
    );
  }
}
