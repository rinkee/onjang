import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/k_icon_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/new_balance_add_btn.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/common_widget/number_pad/keyboard.dart';
import 'package:jangboo_flutter/common_widget/number_pad/number_pad.dart';
import 'package:jangboo_flutter/common_widget/search/k_search_bar.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/auth_controller.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/customer/customer_screen3.dart';
import 'package:jangboo_flutter/layout/desktopLayout.dart';
import 'package:jangboo_flutter/login/login_screen.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:jangboo_flutter/user/edit_user_info_screen.dart';
import 'package:jangboo_flutter/user/user_screen_desktop.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timer_builder/timer_builder.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  final TextEditingController searchCtr = TextEditingController();
  final customerCtr = Get.put(CustomerContentController());

  final isFavorited = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCtr.addListener(() {
      print(searchCtr.text);
      customerCtr.fucSearchCustomer(searchCtr);
      if (isFavorited.value == true) {
        isFavorited.value = false;
      }
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
    return Scaffold(
      drawer: Drawer(
        width: 300,
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Obx(() => Text(userCtr.userData.value!.storeName)),
              onTap: () {
                Get.to(() => EditUserInfoScreen(
                    userName: userCtr.userData.value!.name,
                    storeName: userCtr.userData.value!.storeName));
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Updates'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('설정'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('로그아웃'),
              onTap: () async {
                final authCtr = Get.put(AuthController());
                await authCtr.signOut();
                Get.offAll(const LoginScreen());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
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
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              kBtn(
                                onTap: () {
                                  isFavorited.value = false;
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
                              kBtn(
                                onTap: () {
                                  isFavorited.value = true;
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
                              kBtn(
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

                              // KNewBalanceAddBtn(),
                            ],
                          ),
                        )),
                    Obx(
                      () => CustomerCard(
                        favorite: isFavorited.value,
                      ),
                    )
                  ],
                ),
              ),
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
                  KSearchBar(
                    textCtr: searchCtr,
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
                                    child: CustomKeyboardKey(
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
              child: BorderContainer(
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
                              child: kBtn(
                                  onTap: () async {
                                    customerCtr
                                        .fucAddCustomer(
                                      co_name: name,
                                      co_phone: phone,
                                    )
                                        .then((value) async {
                                      // await customerCtr.fucSetCustomerList();
                                      Get.back();
                                      // await supabase.from('customer').insert({
                                      //   'name': name,
                                      //   'phone': phone,
                                      //   'barcode': barcode,
                                      //   'user_id': 'testUserId'
                                      // }).select('*');
                                    });
                                    Get.back();
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
