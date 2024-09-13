import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/icon_button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/search_bar_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';

import 'package:jangboo_flutter/app/ui/web/demo/demo_customer.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/instroduceLayout.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:jangboo_flutter/app/ui/web/user/edit_user_info_screen.dart';
import 'package:jangboo_flutter/app/ui/web/user/user_screen_desktop.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timer_builder/timer_builder.dart';

// List의 정의를 수정합니다.
List<Map<String, Object>> demoCustomers = [
  {
    'customer': CustomerModel(
        id: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        companyName: '',
        name: '고객 1',
        lastVisit: DateTime.now(),
        userId: '0',
        balance: 0,
        favorite: false,
        state: 'active'),
    'log': <Map<String, dynamic>>[],
  },
  {
    'customer': CustomerModel(
        id: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        companyName: '',
        name: '고객 2',
        lastVisit: DateTime.now(),
        userId: '1',
        balance: 0,
        favorite: true,
        state: 'active'),
    'log': <Map<String, dynamic>>[],
  }
];

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final TextEditingController searchCtr = TextEditingController();
  final customerCtr = Get.put(CustomerContentController());

  final isFavorited = false.obs;

  @override
  void initState() {
    super.initState();
    searchCtr.addListener(() {
      print(searchCtr.text);
      customerCtr.fucSearchCustomer(searchCtr);
      if (isFavorited.value == true) {
        isFavorited.value = false;
      }
      setState(() {});
    });
  }

  TextStyle isClikedStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle isNotClikedStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    // 검색어에 따른 필터링된 리스트 생성
    List<Map<String, Object>> filteredCustomers =
        demoCustomers.where((customer) {
      var customerModel = customer['customer'] as CustomerModel;
      var searchQuery = searchCtr.text.toLowerCase();
      return customerModel.name.toLowerCase().contains(searchQuery);
    }).toList();

    // 현재 즐겨찾기 상태에 따라 리스트 필터링
    if (isFavorited.value) {
      filteredCustomers = filteredCustomers
          .where((customer) => (customer['customer'] as CustomerModel).favorite)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '체험판',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          onPressed: () {
            Get.offAll(const IntroduceLayout());
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TimerBuilder.periodic(
              const Duration(seconds: 60),
              builder: (context) {
                return Text(
                  DateFormat('M.dd (E) a hh:mm', 'ko_KR')
                      .format(DateTime.now()),
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey[300]),
                );
              },
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Obx(
                    () => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ButtonWidget(
                                onTap: () {
                                  searchCtr.clear();
                                  isFavorited.value = false;
                                  setState(() {}); // 상태 업데이트
                                },
                                child: SizedBox(
                                  width: 120,
                                  child: Center(
                                      child: Text('모든 고객',
                                          style: isFavorited.value
                                              ? isNotClikedStyle
                                              : isClikedStyle)),
                                ),
                              ),
                              ButtonWidget(
                                onTap: () {
                                  searchCtr.clear();
                                  isFavorited.value = true;
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      '즐겨찾기',
                                      style: !isFavorited.value
                                          ? isNotClikedStyle
                                          : isClikedStyle,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ButtonWidget(
                                bgColor: subColor,
                                onTap: () {
                                  ShowMakeLedgerDialog(context: context);
                                },
                                child: const SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      '장부 추가',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: sgColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                            itemCount: filteredCustomers.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 120,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 4,
                            ),
                            itemBuilder: (context, index) {
                              var customer = filteredCustomers[index]
                                  ['customer'] as CustomerModel;
                              var log = filteredCustomers[index]['log']
                                  as List<Map<String, dynamic>>;
                              return ButtonWidget(
                                hoverColor: Colors.grey[300],
                                bgColor: Colors.white,
                                onTap: () async {
                                  final customerCtr =
                                      Get.put(CustomerContentController());
                                  customerCtr.currentCustomerIndex = index;
                                  customerCtr.fucSetUpActionButton(
                                      balance: customer.balance);
                                  customerCtr.filteredItems.clear();
                                  customerCtr.showSearchScreen.value = false;

                                  var result = await Get.to(DemoCustomer(
                                    customer: customer,
                                    balanceLog: log,
                                  ));

                                  if (result != null &&
                                      result is Map<String, Object>) {
                                    setState(() {
                                      filteredCustomers[index] = result;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      customer.favorite == true
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  color: Colors.amber,
                                                  size: 20,
                                                ),
                                              ],
                                            )
                                          : const Icon(
                                              Icons.star_rounded,
                                              color: Colors.transparent,
                                              size: 20,
                                            ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  customer.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: cardTitle,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    f.format(customer.balance),
                                                    style: cardBalance,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  )),
            ),
          ),

          // side content
          Container(
            width: 350,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SearchBarWidget(),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: keys
                            .map(
                              (x) => Row(
                                children: x.map((y) {
                                  return Expanded(
                                    child: NumberPadWidget(
                                      textCtr: searchCtr,
                                      label: y,
                                      onTap: (val) {},
                                      value: y,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> ShowMakeLedgerDialog({
    required BuildContext context,
  }) {
    var name = '';
    var phone = '';
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BorderContainerWidget(
                  w: 350,
                  h: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('이름'),
                              TextField(
                                onChanged: (val) {
                                  name = val;
                                },
                              ),
                              const Gap(30),
                              const Text('전화번호'),
                              TextField(
                                keyboardType: TextInputType.phone,
                                onChanged: (val) {
                                  phone = val;
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonWidget(
                                  onTap: () async {
                                    var id =
                                        (demoCustomers.length + 1).toString();

                                    demoCustomers.add({
                                      'customer': CustomerModel(
                                          id: demoCustomers.length + 1,
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                          companyName: '',
                                          name: name,
                                          lastVisit: DateTime.now(),
                                          userId: 'demo',
                                          balance: 0,
                                          favorite: false,
                                          state: 'active'),
                                      'log': <Map<String, dynamic>>[],
                                    });

                                    Get.back();
                                    setState(() {});
                                  },
                                  bgColor: sgColor,
                                  child: const Center(
                                    child: Text(
                                      '추가',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }
}
