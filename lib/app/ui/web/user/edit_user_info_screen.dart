import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/input_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditUserInfoScreen extends StatefulWidget {
  const EditUserInfoScreen(
      {super.key, required this.userName, required this.storeName});

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();

  final String userName;
  final String storeName;
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final UserController _userCtr = Get.find<UserController>();

  final nameCtr = TextEditingController();
  final storeNameCtr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtr.text = widget.userName;
    storeNameCtr.text = widget.storeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 정보 수정',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width / 2 - 20,
              child: InputWidget(
                ctr: nameCtr,
                title: '내 이름',
              ),
            ),
            SizedBox(
              width: Get.width / 2 - 20,
              child: InputWidget(
                ctr: storeNameCtr,
                title: '내 가게명',
              ),
            ),
            const Gap(20),
            Center(
              child: SizedBox(
                width: 300,
                child: ButtonWidget(
                    bgColor: sgColor,
                    onTap: () async {
                      if (nameCtr.text != '' && storeNameCtr.text != '') {
                        var uid = _userCtr.user.value!.uid;
                        await supabase
                            .from('user')
                            .update({
                              'store_name': storeNameCtr.text,
                              'name': nameCtr.text
                            })
                            .eq('uid', uid)
                            .then((value) async {
                              // 디비 값 변경후 업데이트ㅐㅡ
                              await _userCtr.loadUserData();
                              Get.back();
                            });
                      } else {
                        print(nameCtr.text);
                        print(storeNameCtr.text);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  child: BorderContainerWidget(
                                      w: 250,
                                      h: 180,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            const Text(
                                              '이름과 가게명은 필수 입력란입니다',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            const Spacer(),
                                            ButtonWidget(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: const Center(
                                                  child: Text('확인'),
                                                ))
                                          ],
                                        ),
                                      )));
                            });
                      }

                      // Get.to(() => const EditCustomerInfoScreen());
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                          child: Text(
                        '수정하기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
