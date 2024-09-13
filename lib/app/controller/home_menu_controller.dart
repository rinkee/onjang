import 'package:get/get.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';

class HomeMenuType {
  static const String all = 'all';
  static const String favorite = 'favorite';
  static const String delete = 'delete';
}

class HomeMenuController extends GetxController {
  var menuType = HomeMenuType.all.obs;
}
