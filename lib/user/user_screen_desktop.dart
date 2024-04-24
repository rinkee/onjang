import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:jangboo_flutter/user/edit_user_info_screen.dart';

final userCtr = Get.put(AuthController());

class UserScreenDesktop extends StatefulWidget {
  const UserScreenDesktop({super.key});

  @override
  State<UserScreenDesktop> createState() => _UserScreenDesktopState();
}

class _UserScreenDesktopState extends State<UserScreenDesktop> {
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
                child: kBtn(
                    onTap: () async {
                      Get.to(() => EditUserInfoScreen(
                            userName: userCtr.userName.value,
                            storeName: userCtr.storeName.value,
                          ));
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
                    userCtr.userName.value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            InfoContent(
                title: '내 가게명',
                child: Obx(
                  () => Text(
                    userCtr.storeName.value,
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
                child: kBtn(
                    onTap: () async {
                      await userCtr.signOut();
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
    return BorderContainer(
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
