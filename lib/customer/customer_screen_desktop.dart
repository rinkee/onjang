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
import 'package:jangboo_flutter/layout/desktopLayout.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomerScreenDesktop extends StatefulWidget {
  CustomerScreenDesktop({super.key, required this.customer});
  CustomerModel customer;

  @override
  State<CustomerScreenDesktop> createState() => _CustomerScreenDesktopState();
}

class _CustomerScreenDesktopState extends State<CustomerScreenDesktop> {
  final TextEditingController numberPadCtr = TextEditingController();
  final customerCtr = Get.put(CustomerContentController());
  var favorite = false.obs;
  var f = NumberFormat('###,###,###,###');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberPadCtr.addListener(() {
      customerCtr.enterUsePrice.value = numberPadCtr.text;
    });
    favorite.value = widget.customer.favorite;
    customerCtr.coName.value = widget.customer.name;
    customerCtr.balance.value = widget.customer.balance;
    customerCtr.enterUsePrice.value = '';
    customerCtr.type.value = ActionType.use.title;
    customerCtr.cardColor!.value = ActionType.use.iconColor!;
    customerCtr.seclectedMenu = ActionType.use;
    if (customerCtr.balance.value == 0) {
      customerCtr.seclectedMenu = ActionType.add;
      customerCtr.type.value = ActionType.add.title;
      customerCtr.cardColor!.value = ActionType.add.iconColor!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
        child: Row(
      children: [
        // main content
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Gap(20),
              Row(
                children: [
                  kBtn(
                      onTap: () {
                        Get.back();
                      },
                      child: const AspectRatio(
                          aspectRatio: 1, child: Icon(Icons.arrow_back))),
                  const Spacer(),
                  kBtn(
                      onTap: () {},
                      child: const AspectRatio(
                          aspectRatio: 1, child: Icon(Icons.star_rounded))),
                  const Gap(10),
                  kBtn(
                      onTap: () {},
                      child: const AspectRatio(
                          aspectRatio: 1, child: Icon(Icons.settings_rounded))),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          bgColor:
                              customerCtr.type.value == ActionType.use.title
                                  ? sgColor
                                  : Colors.white,
                        ),
                        KIconBtn(
                            onTap: () {
                              customerCtr.type.value = ActionType.add.title;
                              customerCtr.enterUsePrice.value = '';
                              numberPadCtr.clear();
                              customerCtr.seclectedMenu = ActionType.add;
                            },
                            title: '충전하기',
                            bgColor:
                                customerCtr.type.value == ActionType.add.title
                                    ? sgColor
                                    : Colors.white,
                            icon: Icons.attach_money_rounded),
                        KIconBtn(
                            onTap: () {
                              customerCtr.type.value = ActionType.card.title;
                              customerCtr.enterUsePrice.value = '';
                              customerCtr.seclectedMenu = ActionType.card;
                              numberPadCtr.clear();
                            },
                            title: '카드등록',
                            bgColor:
                                customerCtr.type.value == ActionType.card.title
                                    ? sgColor
                                    : Colors.white,
                            icon: Icons.add_card_rounded),
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
                              Text('날짜'),
                              Text('가격'),
                              Text('옵션'),
                            ],
                          ),
                          const Gap(10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                customerCtr.cardColor!.value = Colors.black87;
                                customerCtr.type.value =
                                    ActionType.record.title;
                              },
                              child: SizedBox(
                                child: FutureBuilder(
                                    future: supabase
                                        .from('balance_log')
                                        .select()
                                        .eq('customer_id', widget.customer.id)
                                        .order('created_at', ascending: false),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Text('nodata');
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (conext, index) {
                                            final logData =
                                                snapshot.data![index];

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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(DateFormat(
                                                          'yy년MM월dd일 HH시mm분ss초')
                                                      .format(time)),
                                                  Text(
                                                      '${f.format(logData['money'])}원'),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    20)),
                                                        color:
                                                            Colors.grey[100]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        title,
                                                        style: TextStyle(
                                                            color: optionColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }),
                              ),
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
                100,
                crossAxisExtent: 100,
                color: Colors.red,
              ),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Obx(() {
                    var textColor = Colors.grey[500];
                    var showNumber = 0;
                    if (customerCtr.enterUsePrice.value != '') {
                      textColor = const Color.fromRGBO(0, 0, 0, 1);
                      showNumber = int.parse(customerCtr.enterUsePrice.value);
                    }

                    var showPriceSideCard =
                        customerCtr.enterUsePrice.value == ''
                            ? '금액을 입력해주세요'
                            : '${f.format(showNumber)}원';
                    if (customerCtr.type.value == ActionType.use.title) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: f.format(customerCtr.balance.value),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  children: const [
                                TextSpan(
                                  text: '원에서',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal),
                                )
                              ])),
                          const Text(
                            '얼마를 사용할까요?',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          // TextField(
                          //   controller: numberPadCtr,
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: FittedBox(
                              child: Text(
                                showPriceSideCard,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: NumberPad(
                              textCtr: numberPadCtr,
                            ),
                          ),
                        ],
                      );
                    }
                    if (customerCtr.type.value == ActionType.card.title) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: '${customerCtr.balance.value}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  children: const [
                                TextSpan(
                                  text: '원에서',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal),
                                )
                              ])),
                          const Text(
                            '얼마를 카드할까요?',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                '${customerCtr.enterUsePrice.value}원',
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: NumberPad(
                              textCtr: numberPadCtr,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: f.format(customerCtr.balance.value),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                children: const [
                              TextSpan(
                                text: '원에서',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.normal),
                              )
                            ])),
                        const Text(
                          '얼마를 충전할까요?',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        // TextField(
                        //   controller: numberPadCtr,
                        // ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: FittedBox(
                            child: Text(
                              showPriceSideCard,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: NumberPad(
                            textCtr: numberPadCtr,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              // Column(
              //   children: [
              //     Obx(() => Text('${contentCtr.enterPrice.value}원')),
              //     SizedBox(
              //       height: 300,
              //       child: NumberPad(
              //         textCtr: numberPadCtr,
              //       ),
              //     ),
              //   ],
              // ),
              const Gap(20),
              kBtn(
                bgColor: sgColor,
                child: const Center(
                    child: Text(
                  '사용하기',
                  style: TextStyle(color: Colors.white),
                )),
                onTap: () async {
                  // await customerCtr.fucAddOrUse(customerId: widget.customer.id);

                  setState(() {
                    numberPadCtr.clear();
                    customerCtr.enterUsePrice.value = '';
                  });
                },
              )
            ],
          ),
        ),
      ],
    ));
  }
}
