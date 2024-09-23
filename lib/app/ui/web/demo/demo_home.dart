import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/data/enum/sort.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_add_input_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/search_bar_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:timer_builder/timer_builder.dart';

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final DemoController _demoCtr = Get.find<DemoController>();

  @override
  void initState() {
    super.initState();
    _demoCtr.searchCtr.addListener(() {
      _demoCtr.search(_demoCtr.searchCtr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('체험판', style: TextStyle(color: Colors.white)),
        actions: [
          TimerBuilder.periodic(
            const Duration(minutes: 1),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    DateFormat('M.dd (E) a hh:mm', 'ko_KR')
                        .format(DateTime.now()),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[300]),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Side menu
          Container(
            width: 300,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    searchCtr: _demoCtr.searchCtr,
                    onChanged: (_) {
                      _demoCtr.search(_demoCtr.searchCtr);
                    },
                  ),
                  const Gap(20),
                  Text('회사명 검색', style: titleText),
                  const Gap(10),
                  Obx(() => Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children:
                            ['전체', ..._demoCtr.demoCompanyList].map((company) {
                          return ChoiceChip(
                            label: Text(company),
                            selected: company == '전체'
                                ? _demoCtr.selectedCompany.isEmpty
                                : _demoCtr.selectedCompany.value == company,
                            onSelected: (selected) {
                              if (company == '전체') {
                                _demoCtr.setSelectedCompany(null);
                              } else {
                                _demoCtr.setSelectedCompany(
                                    selected ? company : null);
                              }
                            },
                            selectedColor: menuColor,
                            side: BorderSide.none,
                            backgroundColor: Colors.grey[100],
                          );
                        }).toList(),
                      )),
                  const Gap(20),
                  Text('장부 정렬', style: titleText),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: menuColor),
                          child: Obx(() =>
                              DropdownButtonFormField<SortCriteria>(
                                value: _demoCtr.currentSortCriteria.value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                onChanged: (SortCriteria? newValue) {
                                  if (newValue != null) {
                                    _demoCtr.changeSortCriteria(newValue);
                                  }
                                },
                                items: SortCriteria.values
                                    .map<DropdownMenuItem<SortCriteria>>(
                                        (SortCriteria value) {
                                  return DropdownMenuItem<SortCriteria>(
                                    value: value,
                                    child: Text(
                                        _demoCtr.getSortCriteriaString(value)),
                                  );
                                }).toList(),
                              )),
                        ),
                      ),
                      Obx(() => IconButton(
                            icon: Icon(
                              _demoCtr.currentSortOrder.value ==
                                      SortOrder.ascending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _demoCtr.toggleSortOrder();
                            },
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Customer list
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('고객 리스트', style: titleText),
                        ButtonWidget(
                          h: 50,
                          bgColor: menuColor,
                          onTap: () => ShowMakeLedgerDialog(context: context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline_rounded,
                                      size: 24, color: Colors.black),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 3, left: 8),
                                    child: Text(
                                      '장부 추가',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Expanded(
                      child: Obx(() {
                        // _demoCtr.sortCustomers();
                        if (_demoCtr.showSearchScreen.value == true) {
                          return GridView.builder(
                            itemCount: _demoCtr.searchResults.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 140,
                            ),
                            itemBuilder: (context, index) {
                              var customer = _demoCtr.searchResults[index];
                              return CustomerCardWidget(
                                customer: customer,
                                onTap: () {
                                  _demoCtr.searchCtr.clear();
                                  _demoCtr.searchCtr.text = '';
                                  _demoCtr.showSearchScreen.value = false;
                                  _demoCtr.selectCustomer(customer);
                                  _demoCtr.balance.value = customer.balance;

                                  context.pushNamed(
                                    Routes.demoCustomer,
                                  );
                                },
                              );
                            },
                          );
                        }
                        // else {
                        //   var sortedCustomers = _demoCtr.filteredCustomers;
                        //   print('home');
                        //   print(sortedCustomers);
                        //   return Text('home');
                        // }
                        var sortedCustomers = _demoCtr.filteredCustomers;
                        print(sortedCustomers.length);
                        return GridView.builder(
                          itemCount: sortedCustomers.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 140,
                          ),
                          itemBuilder: (context, index) {
                            var customer = sortedCustomers[index];
                            return CustomerCardWidget(
                              customer: customer,
                              onTap: () {
                                // _demoCtr.showLogs.value = customer.log!;
                                _demoCtr.selectCustomer(customer);
                                _demoCtr.balance.value = customer.balance;
                                // print(_demoCtr.showLogs);
                                context.pushNamed(
                                  Routes.demoCustomer,
                                );
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> ShowMakeLedgerDialog({required BuildContext context}) async {
    var company = '';
    var name = '';
    var phone = '';

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: BorderContainerWidget(
                w: 700,
                h: 250,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('고객 추가', style: menuTitle),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomerAddInputWidget(
                            title: '회사명',
                            value: company,
                            onChanged: (val) {
                              company = val;
                            },
                          ),
                          const Gap(30),
                          CustomerAddInputWidget(
                            title: '부서명 / 이름 (필수값)',
                            value: name,
                            onChanged: (val) {
                              name = val;
                            },
                          ),
                          const Gap(30),
                          CustomerAddInputWidget(
                            title: '전화번호',
                            inputType: TextInputType.phone,
                            value: phone,
                            onChanged: (val) {
                              phone = val;
                            },
                          ),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonWidget(
                              w: 150,
                              onTap: () {
                                if (name.isNotEmpty) {
                                  var newCustomer = CustomerModel(
                                    id: _demoCtr.customers.length,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    companyName: company,
                                    name: name,
                                    phone: phone,
                                    lastVisit: DateTime.now(),
                                    userId: '0',
                                    balance: 0,
                                    favorite: false,
                                    state: CTMState.active,
                                    log: [].obs,
                                  );
                                  _demoCtr.addNewCustomer(newCustomer);
                                  context.pop();
                                }
                              },
                              bgColor: sgColor,
                              child: const Center(
                                child: Text(
                                  '추가',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                )));
      },
    );

    setState(() {});
  }
}
