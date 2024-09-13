import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/input_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final titleStyle = const TextStyle(
    fontSize: 20,
  );

  final afterAddRatio = 5.obs;

  final UserController _userCtr = Get.find<UserController>();

  var afterPassword = '';

  @override
  Widget build(BuildContext context) {
    afterAddRatio.value = _userCtr.user.value!.addRatio;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
            if (afterAddRatio.value != _userCtr.user.value!.addRatio) {
              _userCtr.changeAddRatio(afterAddRatio.value);
              print('ratio change');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '인증 비밀번호 변경',
                          style: titleStyle,
                        ),
                        const Text('오른쪽 버튼을 눌러 인증 비밀번호를 변경 할 수 있어요'),
                      ],
                    ),
                    ButtonWidget(
                      onTap: () async {
                        var one = await ChangePasswordDialog(context, 0);
                        var two = false;
                        var three = false;
                        if (one == true) {
                          Future.delayed(const Duration(milliseconds: 500),
                              () async {
                            two = await ChangePasswordDialog(context, 1);
                            if (two == true) {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () async {
                                three = await ChangePasswordDialog(context, 2);
                                if (three == true) {
                                  print('인증번호 확인');
                                  _userCtr.changeCetificationPassword(
                                      afterPassword);
                                }
                              });
                            }
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '추가충전 비율 변경',
                          style: titleStyle,
                        ),
                        const Text('추가 충전 비율값을 변경 할 수 있어요'),
                      ],
                    ),
                    Row(
                      children: [
                        ButtonWidget(
                            w: 50,
                            h: 50,
                            onTap: () {
                              if (afterAddRatio.value > 0) {
                                afterAddRatio.value = afterAddRatio.value - 1;
                              }
                            },
                            child: const Icon(Icons.remove)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Obx(() => Text(
                                '${afterAddRatio.value}%',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.blue),
                              )),
                        ),
                        ButtonWidget(
                            w: 50,
                            h: 50,
                            onTap: () {
                              if (afterAddRatio.value < 100) {
                                afterAddRatio.value = afterAddRatio.value + 1;
                              }
                            },
                            child: const Icon(Icons.add)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ChangePasswordDialog(BuildContext context, int count) {
    final beforePassword = _userCtr.user.value!.certificationPassword;
    var password = ''.obs;
    var showText = '기존 인증 비밀번호를 입력해 주세요';
    if (count == 1) {
      showText = '새로운 인증 비밀번호를 입력해 주세요';
    }
    if (count == 2) {
      showText = '새로운 인증 비밀번호를 다시 입력해 주세요';
    }

    final showErrorText = false.obs;
    TextEditingController passwordCtr = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BorderContainerWidget(
              w: 450,
              h: 500,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            color: Colors.grey,
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => Visibility(
                                visible: showErrorText.value,
                                child: const Text(
                                  '비밀번호를 다시 확인해주세요',
                                  style: TextStyle(color: Colors.red),
                                )),
                          ),
                          Text(showText),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Obx(() => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor:
                                              password.value.length > index
                                                  ? Colors.black
                                                  : Colors.grey[300],
                                        ),
                                      ));
                                }),
                          ),
                          Container(
                            width: 350,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: keys
                                    .map(
                                      (x) => Row(
                                        children: x.map((y) {
                                          return Expanded(
                                            child: NumberPadWidget(
                                              textCtr: passwordCtr,
                                              label: y,
                                              ratio: 3,
                                              onTap: (val) async {
                                                showErrorText.value = false;
                                                print(val is String);

                                                if (password.value.length < 4 &&
                                                    val is String) {
                                                  password.value =
                                                      password + val;
                                                  print(password.value);
                                                } else {
                                                  String newString =
                                                      password.value.substring(
                                                          0,
                                                          password.value
                                                                  .length -
                                                              1);
                                                  password.value = newString;
                                                  print(password.value);
                                                }

                                                // print(password);
                                                if (count == 0 &&
                                                    password.value ==
                                                        beforePassword) {
                                                  // 유저가 입력한 비밀번호가
                                                  // 기존 비밀번호과 같다면
                                                  // 화면을 닫고 트루를 보냄
                                                  Get.back(result: true);
                                                } else if (count == 0 &&
                                                    password.value.length ==
                                                        4 &&
                                                    password.value !=
                                                        beforePassword) {
                                                  password.value = '';
                                                  showErrorText.value = true;
                                                }
                                                if (count == 1 &&
                                                    password.value.length ==
                                                        4) {
                                                  // 새로운 비밀번호를 입력 받고
                                                  // 화면을 닫고 트루를 보냄
                                                  afterPassword =
                                                      password.value;
                                                  Get.back(result: true);
                                                  print(afterPassword);
                                                }
                                                if (count == 2 &&
                                                    password.value.length ==
                                                        4 &&
                                                    password.value ==
                                                        afterPassword) {
                                                  // 다시 입력한 비밀번호와 입력한 비밀번호가
                                                  // 같을때 화면을 닫고 트루를 보냄
                                                  Get.back(result: true);
                                                } else if (count == 2 &&
                                                    password.value.length ==
                                                        4 &&
                                                    password.value !=
                                                        afterPassword) {
                                                  // 다시 입력한 비밀번호가 전에 입력한 비밀번호와
                                                  // 같지 않을때 에러 메세지와 입력한 비밀번호를
                                                  // 초기화
                                                  password.value = '';
                                                  showErrorText.value = true;
                                                }
                                              },
                                              value: y,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
