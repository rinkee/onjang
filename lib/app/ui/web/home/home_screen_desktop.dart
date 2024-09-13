import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:jangboo_flutter/app/data/service/auth_service.dart';
import 'package:jangboo_flutter/app/ui/web/customer/deleted_customer_screen.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/icon_button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/search_bar_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/controller/home_menu_controller.dart';

import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/ui/web/setting/setting_screen.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:jangboo_flutter/app/ui/web/user/edit_user_info_screen.dart';
import 'package:jangboo_flutter/app/ui/web/user/user_screen_desktop.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  final menuCtr = Get.put(HomeMenuController());
  final AuthService _authService = Get.find<AuthService>();
  final UserController _userCtr = Get.find<UserController>();

  final CustomerContentController _customerCtr =
      Get.find<CustomerContentController>();
  // final isFavorited = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getCustomerMode(); // 비동기 메서드 호출
    // });
    getCustomerModeGetStorage();

    _customerCtr.customerSearchCtr.addListener(() {
      _customerCtr.fucSearchCustomer(_customerCtr.customerSearchCtr);
      // if (isFavorited.value == true) {
      //   isFavorited.value = false;
      // }
    });
  }

  var initCustomerMode = false.obs;

  getCustomerModeGetStorage() async {
    await GetStorage.init();
    final box = GetStorage();
    var tt = box.read('customerMode');
    print(tt);
    if (tt == null) {
      box.write('customerMode', false);
    } else {
      if (tt == true) {
        initCustomerMode.value = true;
      } else {
        initCustomerMode.value = false;
      }
      print(initCustomerMode.value);
    }
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: Text('내정보'),
                onTap: () {
                  Get.to(() => EditUserInfoScreen(
                      userName: _userCtr.user.value!.name,
                      storeName: _userCtr.user.value!.storeName));
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: Text('비활성화 장부'),
                onTap: () {
                  Get.to(() => DeletedCustomerScreen());
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
                  Get.to(() => SettingScreen());
                },
              ),
              Spacer(),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('로그아웃'),
                onTap: () async {
                  ;

                  await _authService.logout();
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
          // Obx(
          //   () => Text(
          //     userCtr.storeName.value,
          //     style: const TextStyle(color: Colors.black),
          //   ),
          // ),
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
            Container(
              width: 300,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 20, top: 30),
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
                      final allItems = ['전체', ..._customerCtr.companyList];
                      return Wrap(
                        spacing: 8.0, // chip 간 가로 간격
                        runSpacing: 4.0, // 줄 간 세로 간격
                        children: allItems
                            .map((item) => Obx(() {
                                  return ChoiceChip(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    label: Text(item),
                                    selected: item == '전체'
                                        ? _customerCtr.selectedCompany.isEmpty
                                        : _customerCtr.selectedCompany.value ==
                                            item,
                                    onSelected: (bool selected) {
                                      if (item == '전체') {
                                        _customerCtr.setSelectedCompany(null);
                                      } else {
                                        _customerCtr.setSelectedCompany(
                                            selected ? item : null);
                                      }
                                    },
                                    backgroundColor: Colors.grey[100],
                                    side: BorderSide.none,
                                    labelStyle: TextStyle(
                                        color: (_customerCtr.selectedCompany
                                                        .isEmpty &&
                                                    item == '전체') ||
                                                _customerCtr.selectedCompany
                                                        .value ==
                                                    item
                                            ? Colors.black
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  );
                                }))
                            .toList(),
                      );
                    })
                  ],
                ),
              ),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                    width: 440, child: SearchBarWidget()),
                              ),
                              ButtonWidget(
                                h: 50,
                                bgColor: subColor,
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
                                          size: 26,
                                          color: Colors.blue[300],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '장부 추가',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.blue[400],
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
                            CustomerAddInput(
                              title: '회사명',
                              value: company,
                              onChanged: (val) {
                                company = val;
                              },
                            ),
                            const Gap(30),
                            CustomerAddInput(
                              title: '부서명 / 이름 (필수값)',
                              value: name,
                              onChanged: (val) {
                                name = val;
                              },
                            ),
                            const Gap(30),
                            CustomerAddInput(
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
                                          .fucAddCustomer(
                                        co_name: company,
                                        co_team: name,
                                        co_phone: phone,
                                      )
                                          .then((value) {
                                        Get.back();
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

  Future<dynamic> ShowCustomerMode({
    required BuildContext context,
    required bool customerMode,
  }) {
    var password = ''.obs;

    TextEditingController passwordCtr = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BorderContainerWidget(
                  w: 350,
                  h: 450,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                color: Colors.grey,
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                        const Text(
                          '고객용 장부 모드란?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              '금액 충전, 장부 수정, 삭제등 민감한 기능이 선택되는걸 방지하는 기능입니다.'),
                        ),
                        const Gap(10),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Obx(() => Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            password.value.length > index
                                                ? Colors.black
                                                : Colors.grey[300],
                                      ),
                                    ));
                              }),
                        ),
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
                                            ratio: 3,
                                            textCtr: passwordCtr,
                                            label: y,
                                            onTap: (val) async {
                                              password.value = password + val;
                                              print(password);
                                              await GetStorage.init();
                                              final box = GetStorage();
                                              if (password.value.length == 4) {
                                                if (password.value ==
                                                    _userCtr.user.value!
                                                        .certificationPassword) {
                                                  print('비번 확인');
                                                  if (customerMode == true) {
                                                    box.write(
                                                        'customerMode', false);
                                                    initCustomerMode.value =
                                                        false;
                                                  } else {
                                                    await box.write(
                                                        'customerMode', true);

                                                    initCustomerMode.value =
                                                        true;
                                                  }

                                                  Get.back();
                                                } else {
                                                  print('비번 실패');
                                                  password.value = '';
                                                }
                                              }
                                            },
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
                  )));
        });
  }
}

class HomeContent extends StatelessWidget {
  HomeContent({super.key});
  final _customerCtr = Get.find<CustomerContentController>();

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
            itemCount: _customerCtr
                .fucSearchCustomer(_customerCtr.customerSearchCtr)
                .length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 140),
            itemBuilder: (context, index) {
              CustomerModel customer = _customerCtr
                  .fucSearchCustomer(_customerCtr.customerSearchCtr)[index];
              return CustomerCardWidget(customer: customer);
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
              return CustomerCardWidget(customer: customer);
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
                            CustomerAddInput(
                              title: '회사명',
                              value: company,
                              onChanged: (val) {
                                company = val;
                              },
                            ),
                            const Gap(30),
                            CustomerAddInput(
                              title: '부서명 / 이름 (필수값)',
                              value: name,
                              onChanged: (val) {
                                name = val;
                              },
                            ),
                            const Gap(30),
                            CustomerAddInput(
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
                                          .fucAddCustomer(
                                        co_name: company,
                                        co_team: name,
                                        co_phone: phone,
                                      )
                                          .then((value) {
                                        Get.back();
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

class CustomerAddInput extends StatelessWidget {
  CustomerAddInput(
      {super.key,
      required this.title,
      required this.value,
      this.inputType,
      required this.onChanged});

  String title;
  String value;
  TextInputType? inputType;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Gap(3),
        Container(
          width: 200,
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'[\s-]')), // 공백과 하이픈을 모두 거부합니다
                ],
                decoration: InputDecoration(border: InputBorder.none),
                keyboardType: inputType ?? TextInputType.text,
                onChanged: onChanged),
          ),
        ),
      ],
    );
  }
}
