import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/data/enum/sort.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';

class CustomerController extends GetxController {
  //의존성
  final UserController _userController = Get.find<UserController>();
  static CustomerController get to => Get.find();
  var currentCustomerIndex = 0;

  //고객관리
  final RxList<CustomerModel> customerList = <CustomerModel>[].obs; // 전체 고객 리스트
  final RxList<String> companyList = <String>[].obs;
  final RxString selectedCompany = ''.obs;
  final RxList<CustomerModel> searchResults = <CustomerModel>[].obs;
  Rx<CustomerModel?> selectedCustomer =
      Rx<CustomerModel?>(null); // 고객 선택 화면, 수정에 보여줄 고객 리스트

  // 검색 및 필터링
  final filteredItems = <CustomerModel>[].obs; // 검색용
  final showSearchScreen = false.obs; // 검색 화면을 보여줄지

  //고객 정보
  var addPointValue = ''.obs;
  var usePotinValue = ''.obs;
  var coId = 0.obs;
  var coName = ''.obs;
  var coTeamName = ''.obs;
  var coPhone = ''.obs;
  var coCard = ''.obs;
  var coBarcode = ''.obs;
  var balance = 0.obs;

  final RxBool isLoading = false.obs;
  var changedCustomerList = false.obs;

  final TextEditingController customerSearchCtr = TextEditingController();

  // 고객 정렬
  final Rx<SortCriteria> currentSortCriteria = SortCriteria.createdAt.obs;
  final Rx<SortOrder> currentSortOrder = SortOrder.descending.obs;

  @override
  void onInit() {
    super.onInit();

    ever(_userController.user, (_) => loadCustomerList());
    ever(changedCustomerList, (_) => loadCustomerList());
    // 앱 초기화 시 localStorage에 저장된 고객 정보 불러오기
    var storedCustomer = window.localStorage['selectedCustomer'];
    if (storedCustomer != null) {
      selectedCustomer.value =
          CustomerModel.fromJson(jsonDecode(storedCustomer));
    }
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

    var storedCustomer = window.localStorage['selectedCustomer'];
    if (storedCustomer != null) {
      var storedCustomerModel =
          CustomerModel.fromJson(jsonDecode(storedCustomer));

      // Find the matching customer in the customerList
      var updatedCustomer = customerList.firstWhereOrNull(
          (customer) => customer.id == storedCustomerModel.id);

      if (updatedCustomer != null) {
        // If a matching customer is found, update selectedCustomer
        setSelectedCustomer(storedCustomerModel);
        // Update localStorage with the latest data
        window.localStorage['selectedCustomer'] =
            jsonEncode(updatedCustomer.toJson());
      } else {
        // If no matching customer is found, use the stored data
        setSelectedCustomer(storedCustomerModel);
      }
    }

    updateCompanyList();
    isLoading.value = false;
  }

  // 새로운 고객을 추가한 후 이 메서드를 호출합니다.
  void refreshCustomerList() {
    changedCustomerList.toggle();
  }

  void setSelectedCustomer(CustomerModel customer) {
    selectedCustomer.value = customer;

    // 고객 정보를 localStorage에 저장
    window.localStorage['selectedCustomer'] = jsonEncode(customer.toJson());
    print(selectedCustomer.value!.balance);
  }

  void updateSelectedCustomer(CustomerModel customer, int newBalance) {
    selectedCustomer.value!.balance = newBalance;
    var changedCutomer = selectedCustomer.value;
    setSelectedCustomer(customer);
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
    setSelectedCompany(null);
  }

  List<CustomerModel> get filteredCustomers {
    List<CustomerModel> filtered =
        customerList.where((customer) => customer.state == 'active').toList();

    if (selectedCompany.isNotEmpty) {
      filtered = filtered
          .where((customer) => customer.companyName == selectedCompany.value)
          .toList();
    }

    filtered.sort((a, b) {
      int comparison;
      switch (currentSortCriteria.value) {
        case SortCriteria.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case SortCriteria.companyName:
          comparison = (a.companyName ?? '').compareTo(b.companyName ?? '');
          break;

        case SortCriteria.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortCriteria.balance:
          comparison = a.balance.compareTo(b.balance);
          break;
        // case SortCriteria.favorite:
        //   comparison = a.favorite ? -1 : (b.favorite ? 1 : 0);
        //   break;
        // case SortCriteria.lastVisit:
        //   comparison = a.lastVisit.compareTo(b.lastVisit);
        //   break;

        // case SortCriteria.updatedAt:
        //   comparison = a.updatedAt.compareTo(b.updatedAt);
        // break;
      }
      return currentSortOrder.value == SortOrder.ascending
          ? comparison
          : -comparison;
    });

    return filtered;
  }

  void changeSortCriteria(SortCriteria criteria) {
    currentSortCriteria.value = criteria;
    update(); // GetX의 상태 업데이트 트리거
  }

  void toggleSortOrder() {
    currentSortOrder.value = currentSortOrder.value == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
    update();
  }

  String getSortCriteriaString(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.createdAt:
        return '생성일';
      case SortCriteria.companyName:
        return '회사명';
      case SortCriteria.name:
        return '부서/이름명';
      case SortCriteria.balance:
        return '잔액';
      // case SortCriteria.favorite:
      //   return '즐겨찾기';
      // case SortCriteria.lastVisit:
      //   return '최근 방문일';

      // case SortCriteria.updatedAt:
      // return '수정일';
    }
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

  Future addCustomer({
    required String co_team,
    String? co_name,
    String? co_phone,
  }) async {
    final authCtr = Get.put(UserController());
    final uid = authCtr.user.value!.uid;
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

  Future editCustomer({
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

  Future deleteCustomer({
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

  Future setActive({
    required int customerId,
  }) async {
    await supabase
        .from('customer')
        .update({'state': 'active', 'when_delete': null}).eq('id', customerId);

    refreshCustomerList();
  }

  Future setInactive({
    required int customerId,
  }) async {
    var whenDelte = DateTime.now().add(Duration(days: 30)).toIso8601String();
    await supabase.from('customer').update(
        {'state': 'inactive', 'when_delete': whenDelte}).eq('id', customerId);

    refreshCustomerList();
  }

  void search(TextEditingController searchCtr) {
    final searchText = searchCtr.text.toLowerCase();
    showSearchScreen.value = searchCtr.text.isNotEmpty;
    if (selectedCompany.value != '') {
      selectedCompany.value = '';
    }

    searchResults.value = searchCustomers.where((customer) {
      bool matches = customer.state == 'active' &&
          (customer.companyName.toLowerCase().contains(searchText) ||
              customer.name.toLowerCase().contains(searchText) ||
              (customer.phone?.toLowerCase().contains(searchText) ?? false) ||
              (customer.barcode?.toLowerCase().contains(searchText) ?? false));

      if (matches) {
        // print('Matched customer: ${customer.name}, Search text: $searchText');
      }

      return matches;
    }).toList();

    // print('Search text: $searchText');
    // print('Total matches: ${searchResults.length}');

    if (searchResults.isNotEmpty) {
      // print('First match: ${searchResults.first.name}');
    }

    update();
  }

  Future chargePoint({required int customerId, required int point}) async {
    var beforeBalance = balance.value;
    var enterBalance = point;

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
    // selectedCustomer.value!.balance = newBalance;
    // var changedCutomer = selectedCustomer.value;
    // setSelectedCustomer(changedCutomer!);
  }

  Future usePoint({required int customerId, required int point}) async {
    var beforeBalance = balance.value;
    var enterBalance = point;

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
      // selectedCustomer.value!.balance = newBalance;
      // var changedCutomer = selectedCustomer.value;
      // setSelectedCustomer(changedCutomer!);
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
      // selectedCustomer.value!.balance = newBalance;
      // var changedCutomer = selectedCustomer.value;
      // setSelectedCustomer(changedCutomer!);
    }
  }

  // 취소 기능
  Future<void> toggleTransactionStatus({
    required int id,
    required int point,
    required int customerId,
    required bool currentCanceledStatus,
  }) async {
    bool newCanceledStatus = !currentCanceledStatus;
    int balanceChange = calculateBalanceChange(newCanceledStatus, point);
    int newBalance = balance.value + balanceChange;

    await supabase
        .from('balance_log')
        .update({'canceled': newCanceledStatus}).eq('id', id);
    await supabase
        .from('customer')
        .update({'balance': newBalance}).eq('id', customerId);

    balance.value = newBalance;
  }

  int calculateBalanceChange(bool isCanceled, int point) {
    return isCanceled ? point : -point;
  }

  // 아래부터 부가기능
  // 사용을 취소하는 기능
  // useToCancle(
  //     {required bool canceled,
  //     required int id,
  //     required int point,
  //     required int customerId}) async {
  //   var newBalance = 0;
  //   if (canceled) {
  //     // 사용이  충전이면
  //     newBalance = balance.value - point;
  //   } else {
  //     newBalance = balance.value + point;
  //   }
  //   await supabase.from('balance_log').update({'canceled': true}).eq('id', id);
  //   await supabase
  //       .from('customer')
  //       .update({'balance': newBalance}).eq('id', customerId);

  //   balance.value = newBalance;
  // }

  // // 취소를 되돌리는 기능
  // cancleToBack(
  //     {required bool canceled,
  //     required int id,
  //     required int point,
  //     required int customerId}) async {
  //   var newBalance = 0;
  //   if (canceled) {
  //     // 사용이  충전이면
  //     newBalance = balance.value + point;
  //   } else {
  //     newBalance = balance.value - point;
  //   }
  //   await supabase.from('balance_log').update({'canceled': false}).eq('id', id);
  //   await supabase
  //       .from('customer')
  //       .update({'balance': newBalance}).eq('id', customerId);

  //   balance.value = newBalance;
  // }

  addMemo({
    required int id,
    required int customerId,
    required String memo,
  }) async {
    await supabase.from('balance_log').update({'memo': memo}).eq('id', id);
  }

  setFavorite({required int customerId, required bool favorite}) async {
    await supabase.from('customer').update({'favorite': favorite}).eq(
      'id',
      customerId,
    );
  }
}
