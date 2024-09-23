import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/data/enum/sort.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/introduce_screen.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_add_input_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/search_bar_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = Get.find<AuthService>();
  final UserController _userCtr = Get.find<UserController>();

  final CustomerController _customerCtr = Get.find<CustomerController>();
  // final isFavorited = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getCustomerMode(); // 비동기 메서드 호출
    // });

    _customerCtr.customerSearchCtr.addListener(() {
      _customerCtr.search(_customerCtr.customerSearchCtr);
      // if (isFavorited.value == true) {
      //   isFavorited.value = false;
      // }
    });
  }

  TextStyle isClikedStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle isNotClikedStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  var customerState = CTMState.active;

  @override
  Widget build(BuildContext context) {
    print('home');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        width: 300,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '모두의 장부',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: Text('내정보'),
                onTap: () {
                  context.goNamed(Routes.userEdit);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: Text('비활성화 장부'),
                onTap: () {
                  context.goNamed(Routes.customerInactive);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.update),
              //   title: const Text('Updates'),
              //   onTap: () {},
              // ),
              ListTile(
                leading: const Icon(Icons.settings_rounded),
                title: const Text('설정'),
                onTap: () {
                  context.goNamed(Routes.setting);
                },
              ),
              Spacer(),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('로그아웃'),
                onTap: () async {
                  await _authService.logout().then((_) {
                    context.replaceNamed(Routes.introduce);
                  });
                  // Get.offAll(const LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '모두의장부',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          // TextButton(
          //     onPressed: () {
          //       print('home user value : ${_userCtr.user.value!}');
          //     },
          //     child: Text('test')),
          Obx(() {
            if (_userCtr.initCustomerMode.value) {
              return Row(children: [
                Text(
                  '고객모드',
                  style: const TextStyle(color: Colors.grey),
                ),
                Gap(5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.green,
                  ),
                )
              ]);
            }
            return SizedBox();
          }),
          Gap(10),
          // Text(userCtr.uid.value),
          // const Gap(20),
          // Obx(() => Padding(
          //       padding: const EdgeInsets.only(right: 10),
          //       child: SizedBox(
          //           height: 45,
          //           child: kBtn(
          //               onTap: () async {
          //                 Get.to(() => const UserScreenDesktop());
          //               },
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 14),
          //                 child: Center(
          //                   child: Text(userCtr.userData.value!.name),
          //                 ),
          //               ))),
          //     )),
          // Gap(170),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Row(
          //     children: [
          //       Text(
          //         '고객 모드',
          //         style: TextStyle(
          //             fontWeight: FontWeight.w600, color: Colors.grey),
          //       ),
          //       Gap(5),
          //       Obx(
          //         () => Switch(
          //             value: initCustomerMode.value,
          //             onChanged: (_) async {
          //               ShowCustomerMode(
          //                   context: context,
          //                   customerMode: initCustomerMode.value);
          //             }),
          //       )
          //     ],
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TimerBuilder.periodic(
              const Duration(seconds: 60),
              builder: (context) {
                return Text(
                  DateFormat('M.dd (E) a hh:mm', 'ko_KR')
                      .format(DateTime.now()),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Row(
          children: [
            // side content
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: 300,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 30, right: 10, bottom: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SearchBarWidget(),
                            // Container(
                            //   decoration: const BoxDecoration(
                            //     borderRadius: BorderRadius.all(Radius.circular(20)),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(10.0),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: keys
                            //           .map(
                            //             (x) => Row(
                            //               children: x.map((y) {
                            //                 return Expanded(
                            //                   child: NumberPadWidget(
                            //                     ratio: 2,
                            //                     textCtr: _customerCtr.customerSearchCtr,
                            //                     label: y,
                            //                     onTap: (val) {
                            //                       print('onTap');
                            //                       _customerCtr.showSearchScreen.value =
                            //                           true;
                            //                     },
                            //                     value: y,
                            //                   ),
                            //                 );
                            //               }).toList(),
                            //             ),
                            //           )
                            //           .toList(),
                            //     ),
                            //   ),
                            // ),
                            MaxWidthBox(
                                maxWidth: 440,
                                child: SearchBarWidget(
                                  searchCtr: _customerCtr.customerSearchCtr,
                                  onChanged: (_) {
                                    _customerCtr
                                        .search(_customerCtr.customerSearchCtr);
                                  },
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, bottom: 20, top: 30),
                              child: Row(
                                children: [
                                  Icon(Icons.folder_outlined),
                                  Gap(10),
                                  Text(
                                    '회사명 검색',
                                    style: titleText,
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final allItems = [
                                '전체',
                                ..._customerCtr.companyList
                              ];
                              return Wrap(
                                spacing: 8.0, // chip 간 가로 간격
                                runSpacing: 4.0, // 줄 간 세로 간격
                                children: allItems
                                    .map((item) => Obx(() {
                                          return ChoiceChip(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            label: Text(item),
                                            selectedColor: menuColor,
                                            selected: item == '전체'
                                                ? _customerCtr
                                                    .selectedCompany.isEmpty
                                                : _customerCtr.selectedCompany
                                                        .value ==
                                                    item,
                                            onSelected: (bool selected) {
                                              if (item == '전체') {
                                                _customerCtr
                                                    .setSelectedCompany(null);
                                              } else {
                                                _customerCtr.setSelectedCompany(
                                                    selected ? item : null);
                                              }
                                            },
                                            backgroundColor: Colors.grey[100],
                                            side: BorderSide.none,
                                            labelStyle: TextStyle(
                                                color: (_customerCtr
                                                                .selectedCompany
                                                                .isEmpty &&
                                                            item == '전체') ||
                                                        _customerCtr
                                                                .selectedCompany
                                                                .value ==
                                                            item
                                                    ? Colors.black
                                                    : Colors.black,
                                                ),
                                          );
                                        }))
                                    .toList(),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, bottom: 15, top: 30),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.filter_alt_outlined,
                                  ),
                                  Gap(10),
                                  Text(
                                    '장부 정렬',
                                    style: titleText,
                                  ),
                                  Spacer(),
                                  Obx(() => IconButton(
                                        icon: Icon(
                                          _customerCtr.currentSortOrder.value ==
                                                  SortOrder.ascending
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _customerCtr.toggleSortOrder,
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(() => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: menuColor),
                                        child: DropdownButtonFormField<
                                            SortCriteria>(
                                          style: TextStyle(
                                        
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          value: _customerCtr
                                              .currentSortCriteria.value,
                                          onChanged: (SortCriteria? newValue) {
                                            if (newValue != null) {
                                              _customerCtr
                                                  .changeSortCriteria(newValue);
                                            }
                                          },
                                          items: SortCriteria.values.map<
                                                  DropdownMenuItem<
                                                      SortCriteria>>(
                                              (SortCriteria value) {
                                            return DropdownMenuItem<
                                                SortCriteria>(
                                              value: value,
                                              child: Text(_customerCtr
                                                  .getSortCriteriaString(
                                                      value)),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.grey[100],
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 고객 카드 목록
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisAlignment: MainAxisAlignment.end,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '고객 리스트',
                                    style: titleText,
                                  ),
                                  // Gap(5),
                                  IconButton(
                                      onPressed: () {
                                        print('유저정보리프레쉬');
                                        _userCtr.loadUserData();
                                        _customerCtr.updateCompanyList();
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.refresh)),
                                ],
                              ),

                              // Spacer(),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Icon(
                              //         Icons.add_circle_outline_rounded,
                              //         size: 24,
                              //         color: sgColor,
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.all(8.0),
                              //         child: Text(
                              //           '장부 추가',
                              //           style: TextStyle(
                              //               fontSize: 16,
                              //               color: sgColor,
                              //               fontWeight: FontWeight.bold),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              ButtonWidget(
                                h: 50,
                                bgColor: menuColor,
                                onTap: () {
                                  ShowMakeLedgerDialog(context: context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: 120,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline_rounded,
                                          size: 24,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 3, left: 8),
                                          child: Text(
                                            '장부 추가',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10),
                        HomeContent()
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> ShowMakeLedgerDialog({
    required BuildContext context,
  }) {
    var company = '';
    var name = '';
    var phone = '';
    return showDialog(
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
                        Text(
                          '고객 추가',
                          style: menuTitle,
                        ),
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
                                onTap: () async {
                                  if (name.isEmpty) {
                                    print('E');
                                  }

                                  if (name.isNotEmpty) {
                                    print('notE');
                                    try {
                                      _customerCtr
                                          .addCustomer(
                                        co_name: company,
                                        co_team: name,
                                        co_phone: phone,
                                      )
                                          .then((value) {
                                        context.pop();
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
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
        });
  }
}

class HomeContent extends StatelessWidget {
  HomeContent({super.key});
  final _customerCtr = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 고객 카드 목록
      if (_customerCtr.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (_customerCtr.showSearchScreen.value == true) {
        return Expanded(
          child: GridView.builder(
            itemCount: _customerCtr.searchResults.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 140),
            itemBuilder: (context, index) {
              CustomerModel customer = _customerCtr.searchResults[index];
              return CustomerCardWidget(
                customer: customer,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.goNamed('customer');
                  _customerCtr.customerSearchCtr.clear();
                  _customerCtr.customerSearchCtr.text = '';
                  _customerCtr.filteredItems.clear();
                  _customerCtr.showSearchScreen.value = false;
                  print(customer.name);
                  _customerCtr.setSelectedCustomer(customer);
                  print('선택 ${_customerCtr.selectedCustomer.value!.name}');
                },
              );
            },
          ),
        );
      }
      if (_customerCtr.filteredCustomers.length != 0) {
        return Expanded(
          child: GridView.builder(
            itemCount: _customerCtr.filteredCustomers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 140),
            itemBuilder: (context, index) {
              CustomerModel customer = _customerCtr.filteredCustomers[index];
              return CustomerCardWidget(
                customer: customer,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.goNamed('customer');
                  _customerCtr.customerSearchCtr.clear();
                  _customerCtr.customerSearchCtr.text = '';
                  _customerCtr.filteredItems.clear();
                  _customerCtr.showSearchScreen.value = false;
                  print(customer.name);
                  _customerCtr.setSelectedCustomer(customer);
                  print('선택 ${_customerCtr.selectedCustomer.value!.name}');
                },
              );
            },
          ),
        );
      }

      return Expanded(
        child: GestureDetector(
          onTap: () {
            ShowMakeLedgerDialog(context: context);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: BorderContainerWidget(
                color: Colors.grey[100],
                h: 160,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: sgColor,
                        size: 50,
                      ),
                      Gap(14),
                      Text(
                        '새로운 장부를 추가 해주세요',
                        style: cardTitle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<dynamic> ShowMakeLedgerDialog({
    required BuildContext context,
  }) {
    var company = '';
    var name = '';
    var phone = '';
    return showDialog(
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
                        Text(
                          '고객 추가',
                          style: menuTitle,
                        ),
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
                                onTap: () async {
                                  if (name.isEmpty) {
                                    print('E');
                                  }

                                  if (name.isNotEmpty) {
                                    print('notE');
                                    try {
                                      _customerCtr
                                          .addCustomer(
                                        co_name: company,
                                        co_team: name,
                                        co_phone: phone,
                                      )
                                          .then((value) {
                                        context.pop();
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
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
        });
  }
}
