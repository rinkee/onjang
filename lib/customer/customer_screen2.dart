import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:jangboo_flutter/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

final contentCtr = Get.put(CustomerContentController());

class CustomerScreen2 extends StatefulWidget {
  CustomerScreen2({super.key, required this.customer});
  CustomerModel customer;

  @override
  State<CustomerScreen2> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen2> {
  var favorite = false;
  var mode = '사용하기';
  var f = NumberFormat('###,###,###,###');

  @override
  void initState() {
    favorite = widget.customer.favorite;
    contentCtr.balance.value = widget.customer.balance;
    contentCtr.enterUsePrice.value = '';
    contentCtr.type.value = ActionType.use.title;
    if (contentCtr.balance.value == 0) {
      contentCtr.type.value = ActionType.add.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1000,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('이름',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                              Text(
                                widget.customer.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('잔액 ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                    '${f.format(contentCtr.balance.value)}원',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                              ),
                              const Gap(10),
                            ],
                          ),
                        ],
                      ),
                      const Gap(10),
                      Menu(
                          onTap: () {
                            contentCtr.type.value = ActionType.add.title;
                            mode = "충전하기";
                            contentCtr.enterUsePrice.value = '';
                            // setState(() {
                            //
                            // });
                          },
                          icon: Icons.attach_money_rounded,
                          title: '충전하기',
                          type: ActionType.add),
                      Menu(
                          onTap: () {
                            contentCtr.type.value = ActionType.use.title;
                            mode = "사용하기";
                            contentCtr.enterUsePrice.value = '';
                            // setState(() {
                            //
                            // });
                          },
                          icon: Icons.sell,
                          title: '사용하기',
                          type: ActionType.use),
                      Menu(
                          onTap: () {
                            contentCtr.type.value = ActionType.card.title;
                            mode = "충전하기";
                            contentCtr.enterUsePrice.value = '';
                            // setState(() {
                            //
                            // });
                          },
                          icon: Icons.credit_card_rounded,
                          title: '카드 등록',
                          type: ActionType.card),
                      const Gap(30),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('메뉴 ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          GestureDetector(
                              onTap: () async {
                                if (favorite) {
                                  await supabase.from('customer').upsert({
                                    'id': widget.customer.id,
                                    'favorite': false,
                                  });
                                  favorite = false;
                                } else {
                                  await supabase.from('customer').upsert({
                                    'id': widget.customer.id,
                                    'favorite': true,
                                  });
                                  favorite = true;
                                }
                                setState(() {});
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: favorite
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(favorite ? '즐겨찾기 해제' : '즐겨찾기 등록'),
                                    ],
                                  ),
                                ),
                              )),
                          Menu(
                              onTap: () {
                                contentCtr.type.value = ActionType.record.title;
                                setState(() {});
                              },
                              icon: Icons.list_alt_rounded,
                              title: '기록',
                              type: ActionType.record),
                          Menu(
                              onTap: () {
                                contentCtr.type.value =
                                    ActionType.setting.title;
                                setState(() {});
                              },
                              icon: Icons.settings,
                              title: '설정',
                              type: ActionType.setting),
                        ],
                      ),

                      // Row(children: [
                      //   GestureDetector(
                      //       onTap: () {
                      //
                      //
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.grey[100]),
                      //         child: Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      //           child: Text('충전하기' ),
                      //         ),)),
                      //   SizedBox(width: 10,),
                      //   GestureDetector(
                      //       onTap: () {
                      //
                      //
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: sgColor),
                      //         child: Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      //           child: Text('사용하기',style: TextStyle(color:Colors.white),),
                      //         ),)),
                      // ],),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: VerticalDivider(
                  color: Colors.grey[200],
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Obx(() {
                    if (contentCtr.type.value == ActionType.add.title ||
                        contentCtr.type.value == ActionType.use.title) {
                      var title = ActionType.use.title;
                      var textColor = Colors.blue;
                      var text = '사용';
                      var showNumber = 0;
                      var priceSize = 24.0;
                      Color priceColor = Colors.grey;
                      var f = NumberFormat('###,###,###,###');
                      if (contentCtr.enterUsePrice.value != '') {
                        showNumber = int.parse(contentCtr.enterUsePrice.value);
                        priceSize = 30.0;
                        priceColor = Colors.grey[800]!;
                      }
                      if (contentCtr.type.value == ActionType.add.title) {
                        title = ActionType.add.title;
                        textColor = Colors.green;
                        text = "충전";
                      }

                      var content = contentCtr.enterUsePrice.value == ''
                          ? '금액을 입력해주세요'
                          : '${f.format(showNumber)}원';
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const Gap(5),
                            Text(
                                '잔액 ${f.format(contentCtr.balance.value)}원에서'
                                    .toString(),
                                style: const TextStyle(fontSize: 24)),
                            RichText(
                              text: TextSpan(
                                text: '얼마를 ',
                                style: const TextStyle(
                                    fontSize: 24), //기본style을 지정해줘야함
                                children: <TextSpan>[
                                  TextSpan(
                                      text: text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor)),
                                  const TextSpan(text: ' 할까요?'),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Center(
                                    child: Text(
                              content,
                              style: TextStyle(
                                  fontSize: priceSize, color: priceColor),
                            ))),
                            NumberPad(),
                            const Gap(50),
                            contentCtr.type.value == ActionType.use.title
                                ? MyBtn(
                                    text: ActionType.use.title,
                                    onTap: () async {
                                      addOrUseFun(ActionType.use.state);
                                    },
                                    color: ActionType.use.iconColor,
                                  )
                                : MyBtn(
                                    text: ActionType.add.title,
                                    onTap: () async {
                                      addOrUseFun(ActionType.add.state);
                                    },
                                    color: ActionType.add.iconColor,
                                  ),
                          ],
                        ),
                      );
                    }
                    if (contentCtr.type.value == ActionType.card.title) {
                      var textColor = Colors.blue;
                      var text = '사용';
                      var showNumber = 0;
                      var priceSize = 24.0;
                      Color priceColor = Colors.grey;

                      if (contentCtr.enterUsePrice.value != '') {
                        showNumber = int.parse(contentCtr.enterUsePrice.value);
                        priceSize = 30.0;
                        priceColor = Colors.grey[800]!;
                      }
                      var content = contentCtr.enterUsePrice.value == ''
                          ? '카드번호나 바코드를 입력해주세요'
                          : '$showNumber';
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ActionType.card.title,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const Gap(5),
                            Text('카드를 등록해 편리하게 사용할수있어요'.toString(),
                                style: const TextStyle(fontSize: 24)),
                            const Gap(30),
                            Expanded(
                                child: Center(
                                    child: Text(
                              content,
                              style: TextStyle(
                                  fontSize: priceSize, color: priceColor),
                            ))),
                            NumberPad(),
                            const Gap(50),
                            MyBtn(
                              text: ActionType.card.title,
                              onTap: () {},
                              color: ActionType.card.iconColor,
                            )
                          ],
                        ),
                      );
                    }
                    if (contentCtr.type.value == '기록') {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '기록',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder(
                                future: supabase
                                    .from('balance_log')
                                    .select()
                                    .eq('customer_id', widget.customer.id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text('nodata');
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (conext, index) {
                                        final logData = snapshot.data![index];
                                        return Row(
                                          children: [
                                            Text(logData['created_at']
                                                .toString()),
                                            Text(logData['money'].toString()),
                                            Text(logData['type'].toString()),
                                          ],
                                        );
                                      });
                                })
                          ],
                        ),
                      );
                    }
                    if (contentCtr.type.value == ActionType.setting.title) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '설정',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: sgColor,
                        ),
                        Text('주의!'),
                        Text('옳지 않은 경로입니다.'),
                      ],
                    ));
                  })),
              // Expanded(
              //   flex: 3,
              //   child: GetX<CustomerContentController>(builder: (ctr) {
              //     if (ctr.type.value == MenuType.add.title ||
              //         ctr.type.value == MenuType.use.title) {
              //       var title = MenuType.use.title;
              //       var textColor = Colors.blue;
              //       var text = '사용';
              //       var showNumber = 0;
              //       var priceSize = 24.0;
              //       Color priceColor = Colors.grey;
              //       var f = NumberFormat('###,###,###,###');
              //       if (ctr.enterPrice.value != '') {
              //         showNumber = int.parse(contentCtr.enterPrice.value);
              //         priceSize = 30.0;
              //         priceColor = Colors.grey[800]!;
              //       }
              //       if (ctr.type.value == MenuType.add.title) {
              //         title = MenuType.add.title;
              //         textColor = Colors.green;
              //         text = "충전";
              //       }

              //       var content = contentCtr.enterPrice.value == ''
              //           ? '금액을 입력해주세요'
              //           : '${f.format(showNumber)}원';
              //       return Padding(
              //         padding: const EdgeInsets.all(20.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               title,
              //               style: const TextStyle(
              //                   fontSize: 30, fontWeight: FontWeight.bold),
              //             ),
              //             const Gap(5),
              //             Text(
              //                 '잔액 ${f.format(contentCtr.balance.value)}에서'
              //                     .toString(),
              //                 style: const TextStyle(fontSize: 24)),
              //             RichText(
              //               text: TextSpan(
              //                 text: '얼마를 ',
              //                 style: const TextStyle(
              //                     fontSize: 24), //기본style을 지정해줘야함
              //                 children: <TextSpan>[
              //                   TextSpan(
              //                       text: text,
              //                       style: TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           color: textColor)),
              //                   const TextSpan(text: ' 할까요?'),
              //                 ],
              //               ),
              //             ),
              //             Expanded(
              //                 child: Center(
              //                     child: Text(
              //               content,
              //               style: TextStyle(
              //                   fontSize: priceSize, color: priceColor),
              //             ))),
              //             NumberPad(),
              //             AddButton(
              //               customerId: widget.customer.id,
              //               beforeBalance: widget.customer.balance,
              //               type: ctr.type.value == MenuType.use.title
              //                   ? MenuType.use.state
              //                   : MenuType.add.state,
              //             ),
              //           ],
              //         ),
              //       );
              //     }

              //     if (ctr.type.value == '기록') {
              //       return Column(
              //         children: [
              //           const Text('기록'),
              //           FutureBuilder(
              //               future: supabase
              //                   .from('balance_log')
              //                   .select()
              //                   .eq('customer_id', widget.customer.id),
              //               builder: (context, snapshot) {
              //                 if (!snapshot.hasData) {
              //                   return const Text('nodata');
              //                 }
              //                 return ListView.builder(
              //                     shrinkWrap: true,
              //                     itemCount: snapshot.data!.length,
              //                     itemBuilder: (conext, index) {
              //                       final logData = snapshot.data![index];
              //                       return Row(
              //                         children: [
              //                           Text(logData['created_at'].toString()),
              //                           Text(logData['money'].toString()),
              //                           Text(logData['type'].toString()),
              //                         ],
              //                       );
              //                     });
              //               })
              //         ],
              //       );
              //     }
              //     return const Text('null');
              //   }),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded NumberPad() {
    return Expanded(
        flex: 1,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    number_padd(number: 1),
                    number_padd(number: 2),
                    number_padd(number: 3),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    number_padd(number: 4),
                    number_padd(number: 5),
                    number_padd(number: 6),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    number_padd(number: 7),
                    number_padd(number: 8),
                    number_padd(number: 9),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            contentCtr.enterUsePrice.value = '';
                          },
                          child: const Center(child: Text('C'))),
                    ),
                    number_padd(number: 0),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            contentCtr.enterUsePrice.value = '';
                          },
                          child: const Center(child: Text('remove'))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  addOrUseFun(state) async {
    var customerId = widget.customer.id;
    var beforeBalance = contentCtr.balance.value;
    var enterBalance = int.parse(contentCtr.enterUsePrice.value);

    if (state == 'add') {
      // 충전 일때

      var newBalance = beforeBalance + enterBalance;
      await supabase.from('customer').upsert({
        'id': customerId,
        'balance': newBalance,
      });
      await supabase.from('balance_log').upsert({
        'customer_id': customerId,
        'type': 'add',
        'money': enterBalance,
      });
      contentCtr.balance.value = newBalance;
      contentCtr.enterUsePrice.value = '';
    }

    if (state == 'use') {
      // 사용 일때
      var newBalance = beforeBalance - enterBalance;
      if (newBalance < 0) {
        print('잔액 부족');
        contentCtr.enterUsePrice.value = '';
      } else {
        await supabase.from('customer').upsert({
          'id': customerId,
          'balance': newBalance,
        });
        await supabase.from('balance_log').upsert({
          'customer_id': customerId,
          'type': 'use',
          'money': enterBalance,
        });
        contentCtr.balance.value = newBalance;
        contentCtr.enterUsePrice.value = '';
      }
    }
  }

  Expanded number_padd({required int number}) {
    return Expanded(
      child: InkWell(
          onTap: () {
            contentCtr.enterUsePrice.value =
                contentCtr.enterUsePrice + number.toString();
          },
          child: Center(
              child: Text(
            number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ))),
    );
  }
}

class Menu extends StatelessWidget {
  Menu({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.type,
  });
  GestureTapCallback onTap;
  IconData icon;
  String title;
  ActionType type;
  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: type.title == contentCtr.type.value
                ? Colors.grey[100]
                : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: type.iconColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(type.title),
              ],
            ),
          ),
        )));
  }
}

class MyBtn extends StatelessWidget {
  const MyBtn({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
  });

  final GestureTapCallback onTap;
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
        ));
  }
}

class AddButton extends StatelessWidget {
  AddButton({
    super.key,
    required this.customerId,
    required this.beforeBalance,
    required this.type,
  });
  final int customerId;
  final int beforeBalance;
  final String type;
  final contentCtr = Get.put(CustomerContentController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          var enterBalance = int.parse(contentCtr.enterUsePrice.value);

          if (type == 'add') {
            // 충전 일때

            var newBalance = beforeBalance + enterBalance;
            await supabase.from('customer').upsert({
              'id': customerId,
              'balance': newBalance,
            });
            await supabase.from('balance_log').upsert({
              'customer_id': customerId,
              'type': 'add',
              'money': enterBalance,
            });
            // contentCtr.balance.value = newBalance;
            contentCtr.enterUsePrice.value = '';
          }

          if (type == 'use') {
            // 사용 일때
            var newBalance = beforeBalance - enterBalance;
            if (newBalance < 0) {
              print('잔액 부족');
              contentCtr.enterUsePrice.value = '';
            } else {
              await supabase.from('customer').upsert({
                'id': customerId,
                'balance': newBalance,
              });
              await supabase.from('balance_log').upsert({
                'customer_id': customerId,
                'type': 'use',
                'money': enterBalance,
              });
              // contentCtr.balance.value = newBalance;
              contentCtr.enterUsePrice.value = '';
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: type == 'add' ? sgColor : Colors.blue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Text(
              type == 'add' ? '충전하기' : '사용하기',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}

// class NumberPad extends StatelessWidget {
//   const NumberPad({
//     super.key,
//     required this.number,
//   });
//   final String number;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//           onTap: (){
//             enter_price = enter_price + number;
//
//
//
//           },
//           child: Center(child: Text(number))),
//     );
//   }
// }
