import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/home_menu_controller.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';

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
  final UserController _userController = Get.find<UserController>();
  static CustomerContentController get to => Get.find();
  var currentCustomerIndex = 0;
  final RxList<CustomerModel> customerList = <CustomerModel>[].obs; // 검색용
  final RxList<CustomerModel> deletedCustomerList =
      <CustomerModel>[].obs; // 삭제된 리스트 확인용
  final RxList<String> companyList = <String>[].obs;
  final RxString selectedCompany = ''.obs;

  final filteredItems = <CustomerModel>[].obs; // 검색용
  final showSearchScreen = false.obs; // 검색 화면을 보여줄지
  var type = '사용하기'.obs;
  var enterUsePrice = ''.obs;
  var enterAddPrice = ''.obs;
  var coId = 0.obs;
  var coName = ''.obs;
  var coTeamName = ''.obs;
  var coPhone = ''.obs;
  var coCard = ''.obs;
  var coBarcode = ''.obs;
  var balance = 0.obs;
  var seclectedMenu = ActionType.use;
  Rx<Color>? cardColor = Colors.white.obs;
  final _authCtr = Get.put(UserController());

  final RxBool isLoading = false.obs;
  var changedCustomerList = false.obs;

  final TextEditingController customerSearchCtr = TextEditingController();

  // 회사 선택 부분
  final currentPage = 0.obs;
  final itemsPerPage = 6.obs;
  final PageController pageController = PageController();

  void resetPage() {
    // currentPage.value = 0;
    // pageController.jumpToPage(0);
    setSelectedCompany(null);
  }

  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void nextPage() {
    if (hasNextPage()) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool hasNextPage() {
    final allItems = ['전체', ...companyList];
    final pageCount = (allItems.length / itemsPerPage.value).ceil();
    return currentPage < pageCount - 1;
  }

  @override
  void onInit() {
    super.onInit();

    ever(_userController.user, (_) => loadCustomerList());
    ever(changedCustomerList, (_) => loadCustomerList());
  }

  Future<void> loadCustomerList() async {
    print('loadCustomerList');
    if (_userController.user.value == null) return;
    isLoading.value = true;

    customerList.clear();
    companyList.clear();

    // Fetch customer list from Supabase
    final customersData = await supabase
        .from('customer')
        .select()
        .eq('user_id', _userController.user.value!.uid)
        .order('company_name');

    if (customersData.isNotEmpty) {
      customerList.value = (customersData as List)
          .map((customer) => CustomerModel.fromJson(customer))
          .toList();
    }

    updateCompanyList();
    isLoading.value = false;
  }

  // 새로운 고객을 추가한 후 이 메서드를 호출합니다.
  void refreshCustomerList() {
    changedCustomerList.toggle();
  }

  void updateCompanyList() {
    print("updateCompanyList called"); // 디버그 출력 추가
    companyList.value = customerList
        .where((customer) => customer.state == 'active')
        .map((customer) => customer.companyName)
        .where((company) => company.isNotEmpty)
        .toSet()
        .toList();
    print("Updated company list: ${companyList.value}"); // 디버그 출력 추가
  }

  List<CustomerModel> get filteredCustomers {
    if (selectedCompany.isEmpty) {
      return customerList
          .where((customer) => customer.state == 'active')
          .toList();
    }
    return customerList
        .where((customer) =>
            customer.companyName == selectedCompany.value &&
            customer.state == 'active')
        .toList();
  }

  List<CustomerModel> get deletedCustomers {
    if (selectedCompany.isEmpty) {
      return customerList
          .where((customer) =>
              customer.state == 'delete' || customer.state == 'inactive')
          .toList();
    }
    return customerList
        .where((customer) =>
            customer.companyName == selectedCompany.value &&
                customer.state == 'delete' ||
            customer.state == 'inactive')
        .toList();
  }

  List<CustomerModel> get searchCustomers {
    if (selectedCompany.isEmpty) {
      return customerList
          .where((customer) => customer.state == 'active')
          .toList();
    }
    return customerList
        .where((customer) =>
            customer.companyName == selectedCompany.value &&
            customer.state == 'active')
        .toList();
  }

  void setSelectedCompany(String? company) {
    selectedCompany.value = company ?? '';
  }

  Future fucAddCustomer({
    required String co_team,
    String? co_name,
    String? co_phone,
  }) async {
    final uid = _authCtr.user.value!.uid;
    print(uid);
    await supabase.from('customer').insert({
      'company_name': co_name,
      'name': co_team,
      'phone': co_phone,
      'user_id': uid,
      'state': 'active',
      'created_at': DateTime.now().toIso8601String()
    }).select('*');
    refreshCustomerList();
  }

  Future setActiveCustomer({
    required int customerId,
  }) async {
    await supabase
        .from('customer')
        .update({'state': 'active', 'when_delete': null}).eq('id', customerId);

    refreshCustomerList();
  }

  Future setInactiveCustomer({
    required int customerId,
  }) async {
    var whenDelte = DateTime.now().add(Duration(days: 30)).toIso8601String();
    await supabase.from('customer').update(
        {'state': 'inactive', 'when_delete': whenDelte}).eq('id', customerId);

    refreshCustomerList();
  }

  Future setDeleteCustomer({
    required int customerId,
    String? co_phone,
    String? co_barcode,
  }) async {
    var whenDelte = DateTime.now().add(Duration(days: 30)).toIso8601String();
    await supabase.from('customer').update(
        {'state': 'delete', 'when_delete': whenDelte}).eq('id', customerId);
    await supabase
        .from('deleted_customer')
        .insert({'customer_id': customerId, 'when_delete': whenDelte});
    // await supabase.from('customer').delete().match({'id': customerId});
    refreshCustomerList();
  }

  Future fucEditCutomerInfo({
    required int customerId,
    required String co_team_name,
    String? co_name,
    String? co_phone,
    String? co_card,
    String? co_barcode,
  }) async {
    await supabase.from('customer').update({
      'name': co_team_name,
      'company_name': co_name,
      'phone': co_phone,
      'card': co_card,
      'barcode': co_barcode,
      'updated_at': DateTime.now().toIso8601String()
    }).eq('id', customerId);
    refreshCustomerList();
  }

  List<CustomerModel> fucSearchCustomer(TextEditingController searchCtr) {
    final searchText = searchCtr.text.toLowerCase();
    showSearchScreen.value = searchCtr.text.isNotEmpty;
    if (selectedCompany.value != '') {
      selectedCompany.value = '';
    }

    var searchList = searchCustomers
        .where((customer) =>
            customer.state == 'active' &&
                (customer.companyName.toLowerCase().contains(searchText)) ||
            (customer.name.toLowerCase().contains(searchText)) ||
            (customer.phone?.toLowerCase().toLowerCase().contains(searchText) ??
                false) ||
            (customer.barcode
                    ?.toLowerCase()
                    .toLowerCase()
                    .contains(searchText) ??
                false))
        .toList();

    final menuCtr = Get.find<HomeMenuController>();
    if (menuCtr.menuType.value != HomeMenuType.all) {
      menuCtr.menuType.value = HomeMenuType.all;
    }
    if (filteredItems.isNotEmpty) {
      print(filteredItems.first.companyName);
    }

    return searchList;
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

  fucAddMemo({
    required int id,
    required int customerId,
    required String memo,
  }) async {
    await supabase.from('balance_log').update({'memo': memo}).eq('id', id);
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
