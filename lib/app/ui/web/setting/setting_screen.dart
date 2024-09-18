import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/setting_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';

class SettingScreen extends GetView<SettingController> {
  SettingScreen({super.key});
  final UserController _userCtr = Get.find<UserController>();
  final afterRatio = 0.obs;
  final afterMode = false.obs;

  Future<void> _handlePasswordChange(BuildContext context) async {
    final steps = [0, 1, 2];
    for (var step in steps) {
      await Future.delayed(const Duration(milliseconds: 500));
      var result = await ChangePasswordDialog(context, step);
      if (!result) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    afterRatio.value = _userCtr.beforeAddRatio.value;
    afterMode.value = _userCtr.initCustomerMode.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          onPressed: () {
            context.pop();
            controller.applySettings();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SettingContent(
                  title: '고객모드',
                  description: '이 모드를 키면 기능이 제한됩니다',
                  child: Obx(
                    () => Switch(
                      value: controller.afterMode.value,
                      onChanged: (_) => ShowCustomerMode(context: context),
                    ),
                  ),
                ),
                SettingContent(
                  title: '고객모드 인증 비밀번호 변경',
                  description: '초기 비밀번호는 0000',
                  child: ButtonWidget(
                    onTap: () => _handlePasswordChange(context),
                    child: const _PasswordDots(),
                  ),
                ),
                SettingContent(
                  title: '추가충전 비율 변경',
                  description: '결제금액의 일정비율을 추가 충전해 할인 효과를 줄 수 있습니다',
                  child: _AddRatioWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> ShowCustomerMode({required BuildContext context}) async {
    var password = ''.obs;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 440,
              maxHeight: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  _buildCloseButton(context),
                  Column(
                    children: [
                      _buildDescription(),
                      const Gap(60),
                      _buildPasswordDots(password),
                      const Gap(30),
                      Obx(
                        () => NumberPadWidget(
                          value: password.value,
                          hideDoubleZero: true,
                          onChanged: (newValue) async {
                            if (password.value.length < 4) {
                              password.value = newValue;
                              if (password.value.length == 4) {
                                bool isValid = await controller
                                    .validateAndToggleCustomerMode(
                                        password.value);
                                if (isValid) {
                                  context.pop();
                                } else {
                                  password.value = '';
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        color: Colors.grey,
        onPressed: () => context.pop(false),
        icon: const Icon(Icons.close),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('고객용 장부 모드란?', style: menuTitle),
        Text(
          '금액 충전, 장부 수정, 삭제등 민감한 기능이 선택되는걸 방지하는 기능입니다.',
          style: descriptionTitle,
        ),
      ],
    );
  }

  Widget _buildPasswordDots(RxString password) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Obx(() => Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  backgroundColor: password.value.length > index
                      ? Colors.black
                      : Colors.grey[300],
                ),
              ));
        },
      ),
    );
  }

  ChangePasswordDialog(BuildContext context, int count) {
    final beforePassword = _userCtr.user.value!.certificationPassword;
    controller.passwordValue.value = '';
    controller.showErrorText.value = false;
    var showText = '기존 인증 비밀번호를 입력해 주세요';
    if (count == 1) {
      showText = '새로운 인증 비밀번호를 입력해 주세요';
    }
    if (count == 2) {
      showText = '새로운 인증 비밀번호를 다시 입력해 주세요';
    }

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 440,
              maxHeight: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        color: Colors.grey,
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(
                          () => Visibility(
                            visible: controller.showErrorText.value,
                            child: const Text(
                              '비밀번호를 다시 확인해주세요',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                          ),
                        ),
                        Text(
                          showText,
                          style: descriptionTitle,
                        ),
                        _buildPasswordDots(controller.passwordValue),
                        Obx(() => NumberPadWidget(
                              value: controller.passwordValue.value,
                              onChanged: (newValue) {
                                if (controller.passwordValue.value.length < 4) {
                                  controller.passwordValue.value = newValue;
                                  if (controller.passwordValue.value.length ==
                                      4) {
                                    handlePasswordCompletion(
                                        context, count, beforePassword);
                                  }
                                }
                              },
                              hideDoubleZero: true,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handlePasswordCompletion(
      BuildContext context, int count, String beforePassword) {
    if (count == 0) {
      if (controller.passwordValue.value == beforePassword) {
        Navigator.of(context).pop(true);
      } else {
        controller.passwordValue.value = '';
        controller.showErrorText.value = true;
      }
    } else if (count == 1) {
      controller.afterPassword.value = controller.passwordValue.value;
      Navigator.of(context).pop(true);
    } else if (count == 2) {
      if (controller.passwordValue.value == controller.afterPassword.value) {
        Navigator.of(context).pop(true);
        _userCtr.changeCertificationPassword(controller.passwordValue.value);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '비밀번호 변경 완료',
            style: TextStyle(fontSize: 20),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: '확인',
            textColor: Colors.white,
            onPressed: () {
              context.pop();
            }, //버튼 눌렀을때.
          ),
        ));
      } else {
        controller.passwordValue.value = '';
        controller.showErrorText.value = true;
      }
    }
  }
}

class SettingContent extends StatelessWidget {
  const SettingContent({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });
  final String title;
  final String description;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: menuTitle,
                ),
                Text(
                  description,
                  style: descriptionTitle,
                )
              ],
            ),
            child
          ],
        ),
        Gap(20),
      ],
    );
  }
}

class _PasswordDots extends StatelessWidget {
  const _PasswordDots();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddRatioWidget extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWidget(
          w: 50,
          h: 50,
          onTap: () =>
              controller.changeAddRatio(controller.afterRatio.value - 1),
          child: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => Text(
                '${controller.afterRatio.value}%',
                style: const TextStyle(fontSize: 20, color: Colors.blue),
              )),
        ),
        ButtonWidget(
          w: 50,
          h: 50,
          onTap: () =>
              controller.changeAddRatio(controller.afterRatio.value + 1),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
