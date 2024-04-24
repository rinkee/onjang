import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';

enum ActionType {
  add(
      title: "충전하기",
      state: "add",
      buttonColor: Color.fromRGBO(35, 135, 39, 1),
      iconColor: Color.fromARGB(255, 65, 179, 69)),
  use(
      title: "사용하기",
      state: "use",
      buttonColor: Color.fromRGBO(25, 118, 210, 1),
      iconColor: Color.fromRGBO(82, 177, 254, 1)),
  card(
      title: "카드등록",
      state: "card",
      buttonColor: Colors.purple,
      iconColor: Color.fromARGB(255, 127, 28, 144)),
  record(
      title: "기록",
      state: "record",
      buttonColor: Colors.black,
      iconColor: Colors.black),
  setting(
      title: "설정",
      state: "setting",
      buttonColor: Colors.black,
      iconColor: Colors.black),

  favorite(
      title: "즐겨찾기",
      state: "favorite",
      buttonColor: Colors.amber,
      iconColor: Colors.amber);

  final String title;
  final String state;
  final Color? buttonColor;
  final Color? iconColor;
  const ActionType({
    required this.title,
    required this.state,
    required this.iconColor,
    required this.buttonColor,
  });
}

class CustomerContentController extends GetxController {
  static CustomerContentController get to => Get.find();
  var currentCustomerIndex = 0;
  final customerList = <CustomerModel>[]; // 검색용
  final filteredItems = <CustomerModel>[].obs; // 검색용
  final selectCustomerList = <CustomerModel>[]; // 선택용
  final showSearchScreen = false.obs; // 검색 화면을 보여줄지
  var type = '사용하기'.obs;
  var enterUsePrice = ''.obs;
  var enterAddPrice = ''.obs;
  var coId = 0.obs;
  var coName = ''.obs;
  var coPhone = ''.obs;
  var coCard = ''.obs;
  var coBarcode = ''.obs;
  var balance = 0.obs;
  var seclectedMenu = ActionType.use;
  Rx<Color>? cardColor = Colors.white.obs;
  final _authCtr = Get.put(AuthController());

  @override
  void onReady() {
    super.onReady();
    print('onReady');
    // fucSetCustomerList();
  }

  // 스트림 업데이트 처리를 위한 메서드
  void updateCustomerList(List<Map<String, dynamic>> dataList) {
    var tempList =
        dataList.map((data) => CustomerModel.fromJson(data)).toList();
    tempList
        .sort((a, b) => b.favorite.toString().compareTo(a.favorite.toString()));
    customerList.assignAll(tempList);
  }

  fucSetCustomerList() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      supabase
          .from('customer')
          .select()
          .eq('user_id', session.user.id)
          .then((value) {
        customerList.clear();
        for (var element in value) {
          customerList.add(CustomerModel.fromJson(element));
          print(customerList);
        }
        customerList.sort(
            (a, b) => b.favorite.toString().compareTo(a.favorite.toString()));
      });
    }
  }

  Future fucAddCustomer({
    required String co_name,
    String? co_phone,
  }) async {
    final uid = _authCtr.uid.value;
    await supabase.from('customer').insert({
      'name': co_name,
      'phone': co_phone,
      'user_id': uid,
      'created_at': DateTime.now().toIso8601String()
    }).select('*');
  }

  Future fucDeleteCustomer({
    required int customerId,
    String? co_phone,
    String? co_barcode,
  }) async {
    await supabase.from('customer').delete().match({'id': customerId});
  }

  Future fucEditCutomerInfo({
    required int customerId,
    required String co_name,
    String? co_phone,
    String? co_card,
    String? co_barcode,
  }) async {
    await supabase.from('customer').update({
      'name': co_name,
      'phone': co_phone,
      'card': co_card,
      'barcode': co_barcode,
      'updated_at': DateTime.now().toIso8601String()
    }).eq('id', customerId);
  }

  fucSearchCustomer(TextEditingController searchCtr) {
    if (searchCtr.text != '') {
      // 검색창이 비어있지 않다면 검색화면을 보여주고
      showSearchScreen.value = true;
    } else {
      // 그렇지 않으면 안보여준다 (검색결과 없음 화면을 보여주기 위해 만듦)
      showSearchScreen.value = false;
    }
    filteredItems.clear();
    for (int i = 0; i < customerList.length; i++) {
      if (customerList[i].name.toString().contains(searchCtr.text)) {
        filteredItems.add(customerList[i]);
        // showSearchScreen.value = true;
      } else if (customerList[i].phone.toString().contains(searchCtr.text) ||
          customerList[i].barcode.toString().contains(searchCtr.text)) {
        filteredItems.add(customerList[i]);
        // showSearchScreen.value = true;
      }
    }
  }

  Future fucAddOrUse({required int customerId, required int point}) async {
    var beforeBalance = balance.value;
    var enterBalance = point;

    if (seclectedMenu.state == 'add') {
      // 충전 일때

      var newBalance = beforeBalance + enterBalance;
      await supabase.from('balance_log').insert({
        'money': enterBalance,
        'type': 'add',
        'customer_id': customerId,
        'created_at': DateTime.now().toIso8601String()
      }).then((value) async {
        await supabase
            .from('customer')
            .update({'balance': newBalance}).eq('id', customerId);
      });

      balance.value = newBalance;
    }

    if (seclectedMenu.state == 'use') {
      // 사용 일때
      var newBalance = beforeBalance - enterBalance;
      if (newBalance < 0) {
        print('잔액 부족');
        await supabase.from('balance_log').insert({
          'money': enterBalance,
          'type': 'use',
          'customer_id': customerId,
          'created_at': DateTime.now().toIso8601String()
        }).then((value) async {
          await supabase
              .from('customer')
              .update({'balance': newBalance}).eq('id', customerId);
        });

        balance.value = newBalance;
      } else {
        await supabase.from('balance_log').insert({
          'money': enterBalance,
          'type': 'use',
          'customer_id': customerId,
          'created_at': DateTime.now().toIso8601String()
        }).then((value) async {
          await supabase
              .from('customer')
              .update({'balance': newBalance}).eq('id', customerId);
        });

        balance.value = newBalance;
      }
    }
  }

  fucCancleUse(
      {required bool used,
      required int id,
      required int point,
      required int customerId}) async {
    var newBalance = 0;
    if (used) {
      // 사용이  충전이면
      newBalance = balance.value - point;
    } else {
      newBalance = balance.value + point;
    }
    await supabase.from('balance_log').update({'canceled': true}).eq('id', id);
    await supabase
        .from('customer')
        .update({'balance': newBalance}).eq('id', customerId);

    balance.value = newBalance;
  }

  fucCancleToBack(
      // 취소를 되돌리는 기능
      {required bool used,
      required int id,
      required int point,
      required int customerId}) async {
    var newBalance = 0;
    if (used) {
      // 사용이  충전이면
      newBalance = balance.value + point;
    } else {
      newBalance = balance.value - point;
    }
    await supabase.from('balance_log').update({'canceled': false}).eq('id', id);
    await supabase
        .from('customer')
        .update({'balance': newBalance}).eq('id', customerId);

    balance.value = newBalance;
  }

  fucFavorite({required int customerId, required bool favorite}) async {
    await supabase.from('customer').update({'favorite': favorite}).eq(
      'id',
      customerId,
    );
  }

  fucSetUpActionButton({required int balance}) {
    if (balance == 0) {
      seclectedMenu = ActionType.add;
      type.value = ActionType.add.title;
      cardColor!.value = ActionType.add.iconColor!;
    } else {
      type.value = ActionType.use.title;
      cardColor!.value = ActionType.use.iconColor!;
      seclectedMenu = ActionType.use;
    }
  }
}
