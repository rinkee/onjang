import 'package:get/get.dart';
import 'package:jangboo_flutter/model/customer_model.dart';

enum ContentType {
  Home(state: 'home'),
  Customer(state: 'customer'),
  Setting(state: 'setting');

  final state;
  const ContentType({required this.state});
}

class ScreenController extends GetxController {
  static ScreenController get to => Get.find();

  final Rx<ContentType> currentScreen = Rx<ContentType>(ContentType.Home);
  Rx<CustomerModel>? currentCustomer;

  // 변경 사항을 적용할 때는 value 속성을 사용합니다.
  void changeScreen(ContentType type) {
    currentScreen.value = type;
  }
}
