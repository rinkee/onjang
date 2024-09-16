import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/data/model/user_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  final AuthService _authService = Get.find<AuthService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  // final SettingController _settingCtr = Get.find<SettingController>();

  final initCustomerMode = false.obs;
  final beforeAddRatio = 5.obs;

  @override
  void onInit() async {
    super.onInit();
    // checkInitialAuthState();
    // setupAuthListener();
    loadUserData();
    getCustomerModeGetStorage();
  }

  Future<void> loadUserData() async {
    final currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      // Fetch user data from Supabase
      final userData = await Supabase.instance.client
          .from('user')
          .select()
          .eq('uid', currentUser.id);

      if (userData != null) {
        user.value = UserModel.fromJson(userData.first);
        beforeAddRatio.value = user.value!.addRatio;
        print('user value = ${user.value}');
      }
    }
  }

  Future<void> getCustomerModeGetStorage() async {
    await GetStorage.init();
    final box = GetStorage();
    var tt = box.read('customerMode');
    if (tt == null) {
      box.write('customerMode', false);
    } else {
      initCustomerMode.value = tt == true;
    }
    print('initCustomerMode = ${initCustomerMode.value}');
  }

  Future<void> toggleCustomerMode(bool currentMode) async {
    if (initCustomerMode.value != currentMode) {
      await GetStorage.init();
      final box = GetStorage();
      await box.write('customerMode', currentMode);
      initCustomerMode.value = currentMode;
      print(initCustomerMode.value);
    }
  }

  Future changeCertificationPassword(String afterPassword) async {
    await supabase.from('user').update(
        {'certification_password': afterPassword}).eq('uid', user.value!.uid);
    await loadUserData();
  }

  Future changeAddRatio(int afterAddRatio) async {
    if (afterAddRatio != beforeAddRatio.value) {
      await supabase
          .from('user')
          .update({'add_ratio': afterAddRatio}).eq('uid', user.value!.uid);
      beforeAddRatio.value = afterAddRatio;
      // await loadUserData();
    }
  }
}
