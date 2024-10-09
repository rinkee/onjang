import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/data/enum/sort.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';

class DemoController extends GetxController {
  static DemoController get to => Get.find<DemoController>();

  // 리스트
  final RxList<CustomerModel> customers = <CustomerModel>[
    CustomerModel(
      id: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      companyName: '데모회사명',
      name: '데모부서',
      lastVisit: DateTime.now(),
      userId: '0',
      balance: 0,
      favorite: false,
      state: CTMState.active,
      log: [].obs,
      useSignature: false,
    ),
    CustomerModel(
      id: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      companyName: '데모회사명2',
      name: '데모부서2',
      lastVisit: DateTime.now(),
      userId: '0',
      balance: 0,
      favorite: false,
      state: CTMState.active,
      log: [].obs,
      useSignature: false,
    ),
  ].obs;
  final RxList<String> demoCompanyList = <String>[].obs;
  final RxList<CustomerModel> searchResults = <CustomerModel>[].obs;

  //상태변경
  final selectedCompany = ''.obs;
  final showSearchScreen = false.obs; // 검색 화면을 보여줄지
  final balance = 0.obs;

  // 검색
  late TextEditingController searchCtr;

  // 선택된 고객
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  final showLog = [].obs;

  // 포인트 사용 및 충전을 위한 변수
  final RxString addPointValue = ''.obs;
  final RxString usePointValue = ''.obs;
  final usePotinValue = ''.obs;

  // 날짜 포맷터
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  // 고객 정렬
  final Rx<SortCriteria> currentSortCriteria = SortCriteria.createdAt.obs;
  final Rx<SortOrder> currentSortOrder = SortOrder.descending.obs;

  @override
  void onInit() {
    super.onInit();
    searchCtr = TextEditingController();
    // ever(customers, (_) => updateCompanyList());
    // customers.assignAll([
    //   CustomerModel(
    //     id: 0,
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //     companyName: '데모회사명',
    //     name: '데모부서',
    //     lastVisit: DateTime.now(),
    //     userId: '0',
    //     balance: 0,
    //     favorite: false,
    //     state: CTMState.active,
    //     log: [],
    //   ),
    //   CustomerModel(
    //     id: 1,
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //     companyName: '데모회사명2',
    //     name: '데모부서2',
    //     lastVisit: DateTime.now(),
    //     userId: '0',
    //     balance: 0,
    //     favorite: false,
    //     state: CTMState.active,
    //     log: [],
    //   ),
    // ]);
  }

  // 고객 선택
  void selectCustomer(CustomerModel customer) {
    selectedCustomer.value = customer;
  }

  void usePoint(int point) {
    if (selectedCustomer.value != null) {
      selectedCustomer.value!.balance -= point;
      selectedCustomer.value!.log?.insert(0, {
        'type': 'use',
        'amount': point,
        'date': DateTime.now().toIso8601String(),
        'memo': ''
      });
      updateCustomer(selectedCustomer.value!);
      balance.value = selectedCustomer.value!.balance;
      // showLogs.clear();
      // showLogs.add({
      //   'type': 'use',
      //   'amount': point,
      //   'date': DateTime.now().toIso8601String(),
      //   'memo': '포인트 사용'
      // });
    }
  }

  void chargePoint(int point) {
    if (selectedCustomer.value != null) {
      selectedCustomer.value!.balance += point;
      selectedCustomer.value!.log?.insert(0, {
        'type': 'charge',
        'amount': point,
        'date': DateTime.now().toIso8601String(),
        'memo': ''
      });
      updateCustomer(selectedCustomer.value!);
      balance.value = selectedCustomer.value!.balance;
      // updateCustomer(selectedCustomer.value!);
      // showLogs.clear();
      // showLogs.add({
      //   'type': 'charge',
      //   'amount': point,
      //   'date': DateTime.now().toIso8601String(),
      //   'memo': '포인트 충전'
      // });
    }
  }

  // 고객의 최근 사용 내역 가져오기
  Map<String, dynamic>? getLastUsage() {
    if (selectedCustomer.value != null && selectedCustomer.value!.log != null) {
      return selectedCustomer.value!.log!
          .lastWhere((log) => log['type'] == 'use', orElse: () => null);
    }
    return null;
  }

  // 고객의 평균 사용 포인트 계산
  double getAverageUsage() {
    if (selectedCustomer.value != null && selectedCustomer.value!.log != null) {
      var usages = selectedCustomer.value!.log!
          .where((log) => log['type'] == 'use')
          .map((log) => log['amount'] as int);
      if (usages.isNotEmpty) {
        return usages.reduce((a, b) => a + b) / usages.length;
      }
    }
    return 0;
  }

  // 새 고객 추가
  void addNewCustomer(CustomerModel newCustomer) {
    customers.add(newCustomer);
    updateCompanyList();
    selectedCompany.value = ''; // 선택된 회사를 리셋
    update();
  }

  // 고객 정보 업데이트
  void updateCustomer(CustomerModel updatedCustomer) {
    int index =
        customers.indexWhere((customer) => customer.id == updatedCustomer.id);
    if (index != -1) {
      customers[index] = updatedCustomer;
      updateCompanyList();
    }
  }

  // 고객 삭제 (실제로는 상태를 'delete'로 변경)
  void deleteCustomer(int customerId) {
    int index = customers.indexWhere((customer) => customer.id == customerId);
    if (index != -1) {
      customers[index].state = CTMState.delete;
      updateCompanyList();
    }
  }

  List<CustomerModel> get filteredCustomers {
    List<CustomerModel> filtered = customers
        .where((customer) => customer.state == CTMState.active)
        .toList();

    if (selectedCompany.isNotEmpty) {
      print('selectedCompany.isNotEmpty');
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
    print('filtered : ${filtered}');
    return filtered;
  }

  void updateCompanyList() {
    print("updateCompanyList called");
    demoCompanyList.value = customers
        .where((customer) => customer.state == CTMState.active)
        .map((customer) => customer.companyName)
        .where((company) => company.isNotEmpty)
        .toSet()
        .toList();
    print("Updated company list: ${demoCompanyList.value}");
    setSelectedCompany(null);
  }

  void setSelectedCompany(String? company) {
    selectedCompany.value = company ?? '';
  }

  //검색
  List<CustomerModel> get searchCustomers {
    if (selectedCompany.isEmpty) {
      return customers
          .where((customer) => customer.state == CTMState.active)
          .toList();
    }
    return customers
        .where((customer) =>
            customer.companyName == selectedCompany.value &&
            customer.state == CTMState.active)
        .toList();
  }

  void search(TextEditingController searchCtr) {
    print('search');
    final searchText = searchCtr.text.toLowerCase();
    showSearchScreen.value = searchCtr.text.isNotEmpty;
    if (selectedCompany.value != '') {
      selectedCompany.value = '';
    }

    searchResults.value = searchCustomers.where((customer) {
      bool matches = customer.state == CTMState.active &&
          (customer.companyName.toLowerCase().contains(searchText) ||
              customer.name.toLowerCase().contains(searchText) ||
              (customer.phone?.toLowerCase().contains(searchText) ?? false) ||
              (customer.barcode?.toLowerCase().contains(searchText) ?? false));
      print(matches);
      return matches;
    }).toList();

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

  void changeSortCriteria(SortCriteria criteria) {
    currentSortCriteria.value = criteria;
    update(); // GetX의 상태 업데이트 트리거
  }

  void toggleSortOrder() {
    currentSortOrder.value = currentSortOrder.value == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;

    print(currentSortOrder);
    update();
  }
}
