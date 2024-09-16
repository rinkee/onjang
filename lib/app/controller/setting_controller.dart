import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';

class SettingController extends GetxController {
  final UserController _userCtr = Get.find<UserController>();
  static SettingController get to => Get.find();

  final afterRatio = 0.obs;
  final afterMode = false.obs;

  final passwordValue = ''.obs;
  final afterPassword = ''.obs;
  final showErrorText = false.obs;

  @override
  void onInit() {
    super.onInit();
    // UserController의 값으로 초기화
    afterRatio.value = _userCtr.beforeAddRatio.value;
    afterMode.value = _userCtr.initCustomerMode.value;

    // UserController의 값이 변경될 때마다 SettingController의 값도 업데이트
    ever(_userCtr.initCustomerMode,
        (_) => afterMode.value = _userCtr.initCustomerMode.value);
    ever(_userCtr.beforeAddRatio,
        (_) => afterRatio.value = _userCtr.beforeAddRatio.value);
  }

  void incrementAddRatio() {
    if (_userCtr.beforeAddRatio.value < 100) {
      _userCtr.beforeAddRatio.value++;
    }
  }

  void decrementAddRatio() {
    if (_userCtr.beforeAddRatio.value > 0) {
      _userCtr.beforeAddRatio.value--;
    }
  }

  void changeAddRatio(int value) {
    if (value >= 0 && value <= 100) {
      afterRatio.value = value;
    }
  }

  Future<void> changePassword() async {
    await _userCtr.changeCertificationPassword(afterPassword.value);
    afterPassword.value = '';
  }

  Future<void> applySettings() async {
    await _userCtr.changeAddRatio(afterRatio.value);
    await _userCtr.toggleCustomerMode(afterMode.value);
  }

  Future<bool> validatePassword(String password) async {
    return password == _userCtr.user.value!.certificationPassword;
  }

  Future<bool> validateAndToggleCustomerMode(String password) async {
    if (await validatePassword(password)) {
      toggleCustomerMode(!afterMode.value);
      // UserController의 값도 함께 업데이트
      _userCtr.initCustomerMode.value = afterMode.value;
      return true;
    }
    return false;
  }

  void toggleCustomerMode(bool value) {
    afterMode.value = value;
    // GetStorage에도 저장
    GetStorage().write('customerMode', value);
  }

  // 고객모드 비밀번호 변경
  void handlePasswordInput(String newValue, int count, String beforePassword) {
    showErrorText.value = false;

    if (passwordValue.value.length < 4) {
      passwordValue.value = newValue;
    } else {
      return; // 4자리 이상이면 더 이상 입력 받지 않음
    }

    if (passwordValue.value.length == 4) {
      switch (count) {
        case 0:
          handleInitialPassword(beforePassword);
          break;
        case 1:
          handleNewPassword();
          break;
        case 2:
          handleConfirmPassword();
          break;
      }
    }
  }

  void handleInitialPassword(String beforePassword) {
    if (passwordValue.value == beforePassword) {
      Get.back(result: true);
    } else {
      resetPasswordWithError();
    }
  }

  void handleNewPassword() {
    afterPassword.value = passwordValue.value;
    Get.back(result: true);
  }

  void handleConfirmPassword() {
    if (passwordValue.value == afterPassword.value) {
      changePassword();
      Get.back(result: true);
    } else {
      resetPasswordWithError();
    }
  }

  void resetPasswordWithError() {
    passwordValue.value = '';
    showErrorText.value = true;
  }
}
