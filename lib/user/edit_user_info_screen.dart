import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/common_widget/k_edit_textfield.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/supabase.dart';
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
  final userCtr = Get.put(AuthController());

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
    return MaxWidthBox(
      maxWidth: maxWidth,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 정보 수정'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width / 2 - 20,
                child: EditTextField(
                  ctr: nameCtr,
                  title: '내 이름',
                ),
              ),
              SizedBox(
                width: Get.width / 2 - 20,
                child: EditTextField(
                  ctr: storeNameCtr,
                  title: '내 가게명',
                ),
              ),
              const Gap(20),
              Center(
                child: SizedBox(
                  width: 300,
                  child: kBtn(
                      bgColor: sgColor,
                      onTap: () async {
                        if (nameCtr.text != '' && storeNameCtr.text != '') {
                          var uid = userCtr.userData.value!.uid;
                          await supabase
                              .from('user')
                              .update({
                                'store_name': storeNameCtr.text,
                                'name': nameCtr.text
                              })
                              .eq('uid', uid)
                              .then((value) async {
                                // 디비 값 변경후 업데이트ㅐㅡ
                                await userCtr.fetchUserData(uid);
                                Get.back();
                              });
                        } else {
                          print(nameCtr.text);
                          print(storeNameCtr.text);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: BorderContainer(
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
                                              kBtn(
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
      ),
    );
  }
}
