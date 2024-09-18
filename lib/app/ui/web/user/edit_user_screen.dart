import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/input_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UserController _userCtr = Get.find<UserController>();

  final nameCtr = TextEditingController();
  final storeNameCtr = TextEditingController();

  var uid = '';
  var userName = '';
  var storeName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_userCtr.user.value != null) {
      uid = _userCtr.user.value!.uid;
      nameCtr.text = _userCtr.user.value!.name;
      storeNameCtr.text = _userCtr.user.value!.storeName;
    } else {
      // 사용자 데이터가 없을 경우의 처리
      print('User data is not available');
      // 여기에 추가적인 오류 처리 로직을 넣을 수 있습니다.
      // 예: 이전 화면으로 돌아가기, 오류 메시지 표시 등
    }
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
              width: 300,
              child: InputWidget(
                ctr: nameCtr,
                title: '내 이름',
              ),
            ),
            SizedBox(
              width: 300,
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
                              context.pop();
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
                                                  context.pop();
                                                },
                                                child: const Center(
                                                  child: Text('확인'),
                                                ))
                                          ],
                                        ),
                                      )));
                            });
                      }
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
