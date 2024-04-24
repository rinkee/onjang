import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/k_icon_btn.dart';
import 'package:jangboo_flutter/common_widget/Button/new_balance_add_btn.dart';
import 'package:jangboo_flutter/common_widget/k_customer_card.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/common_widget/number_pad/number_pad.dart';
import 'package:jangboo_flutter/common_widget/search/k_search_bar.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/navigation_controller.dart';
import 'package:jangboo_flutter/customer/customer_screen3.dart';
import 'package:jangboo_flutter/layout/desktopLayout.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

final customerCtr = Get.put(CustomerContentController());

class SettingCustomerDesktop extends StatefulWidget {
  const SettingCustomerDesktop({super.key});

  @override
  State<SettingCustomerDesktop> createState() {
    return _SettingCustomerDesktopState();
  }
}

class _SettingCustomerDesktopState extends State<SettingCustomerDesktop> {
  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController numberPadCtr = TextEditingController();

  var f = NumberFormat('###,###,###,###');
  var favorite = false.obs;
  var idx = 0;

  @override
  void initState() {
    // TODO: implement initState

    numberPadCtr.addListener(() {
      customerCtr.enterUsePrice.value = numberPadCtr.text;
    });
    idx = customerCtr.currentCustomerIndex;
    var customer = customerCtr.customerList[idx];
    favorite.value = customer.favorite;
    customerCtr.coId.value = customer.id;
    customerCtr.coName.value = customer.name;
    customerCtr.balance.value = customer.balance;
    customerCtr.enterUsePrice.value = '';
    // customerCtr.type.value = ActionType.use.title;
    // customerCtr.cardColor!.value = ActionType.use.iconColor!;
    // customerCtr.seclectedMenu = ActionType.use;

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (customerCtr.balance.value == 0) {
    //     customerCtr.seclectedMenu = ActionType.add;
    //     customerCtr.type.value = ActionType.add.title;
    //     customerCtr.cardColor!.value = ActionType.add.iconColor!;
    //   } else {
    //     customerCtr.type.value = ActionType.use.title;
    //     customerCtr.cardColor!.value = ActionType.use.iconColor!;
    //     customerCtr.seclectedMenu = ActionType.use;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  kBtn(
                      onTap: () {
                        final naviCtr = Get.put(NavigationController());
                        naviCtr.currentMenu.value = MenuType.Home;
                      },
                      child: const AspectRatio(
                          aspectRatio: 1,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.grey,
                          ))),
                  const Spacer(),
                  kBtn(
                      onTap: () {
                        favorite.value = !favorite.value;
                        customerCtr.fucFavorite(
                            customerId: customerCtr.coId.value,
                            favorite: favorite.value);
                      },
                      child: Obx(() => AspectRatio(
                          aspectRatio: 1,
                          child: Icon(Icons.star_rounded,
                              color: favorite.value
                                  ? Colors.amber
                                  : Colors.grey)))),
                  const Gap(10),
                  kBtn(
                      onTap: () {},
                      child: const AspectRatio(
                          aspectRatio: 1,
                          child: Icon(Icons.settings_rounded,
                              color: Colors.grey))),
                ],
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerCtr.coName.value,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Obx(
                    () => Text(
                      '${f.format(customerCtr.balance.value)}원',
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Gap(20),
                  Obx(
                    () => Row(
                      children: [
                        KIconBtn(
                          onTap: () {
                            customerCtr.type.value = ActionType.use.title;

                            customerCtr.enterUsePrice.value = '';
                            numberPadCtr.clear();
                            customerCtr.seclectedMenu = ActionType.use;
                          },
                          title: '사용하기',
                          icon: Icons.draw_rounded,
                          select:
                              customerCtr.type.value == ActionType.use.title,
                          bgColor:
                              customerCtr.type.value == ActionType.use.title
                                  ? sgColor
                                  : Colors.white,
                        ),
                        const Gap(10),
                        KIconBtn(
                            onTap: () {
                              customerCtr.type.value = ActionType.add.title;
                              customerCtr.enterUsePrice.value = '';
                              numberPadCtr.clear();
                              customerCtr.seclectedMenu = ActionType.add;
                            },
                            title: '충전하기',
                            select:
                                customerCtr.type.value == ActionType.add.title,
                            bgColor:
                                customerCtr.type.value == ActionType.add.title
                                    ? sgColor
                                    : Colors.white,
                            icon: Icons.attach_money_rounded),
                      ],
                    ),
                  ),
                  const Gap(20),
                  BorderContainer(
                    h: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '기록',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          const Gap(10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 2, child: Text('날짜')),
                              Expanded(child: Text('가격')),
                              Expanded(child: Text('정보')),
                            ],
                          ),
                          const Gap(10),
                          Expanded(
                            child: SizedBox(
                              child: FutureBuilder(
                                  future: supabase
                                      .from('balance_log')
                                      .select()
                                      .eq(
                                        'customer_id',
                                        customerCtr.customerList[idx].id,
                                      )
                                      .order('created_at', ascending: false),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Text('nodata');
                                    }
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (conext, index) {
                                          final logData = snapshot.data![index];

                                          var option = 'add';
                                          var title = '충전';
                                          var optionColor = Colors.green;
                                          if (logData['type'].toString() ==
                                              'use') {
                                            option = 'use';
                                            title = '사용';
                                            optionColor = Colors.grey;
                                          }
                                          var time = DateTime.parse(
                                              logData['created_at']);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(DateFormat(
                                                          'yy년MM월dd일 HH시mm분ss초')
                                                      .format(time)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      '${f.format(logData['money'])}원'),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        title,
                                                        style: TextStyle(
                                                            color: optionColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const Gap(20),
        // side content
        Expanded(
          child: Column(
            children: [
              const Gap(
                80,
                crossAxisExtent: 100,
              ),
              kBtn(
                child: const Center(
                    child: Text(
                  '이 장부 삭제',
                  style: TextStyle(color: Colors.white),
                )),
                onTap: () async {
                  // await customerCtr.fucAddOrUse(
                  //     customerId: customerCtr.customerList[idx].id);

                  setState(() {
                    numberPadCtr.clear();
                    customerCtr.enterUsePrice.value = '';
                  });
                },
              ),
              const Gap(20),
            ],
          ),
        ),
      ],
    );
  }
}
