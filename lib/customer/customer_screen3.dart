// 배경 색 바뀌는거

import 'dart:ui';

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

class CustomerScreen3 extends StatefulWidget {
  CustomerScreen3({super.key, required this.customer});
  CustomerModel customer;

  @override
  State<CustomerScreen3> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen3> {
  var favorite = false.obs;
  var showCheckBox = false.obs;
  var mode = '사용하기';
  var f = NumberFormat('###,###,###,###');
  double _containerO = 0.0;
  double _containerW = 50;
  double _containerH = 50;

  @override
  void initState() {
    favorite.value = widget.customer.favorite;
    contentCtr.balance.value = widget.customer.balance;
    contentCtr.enterUsePrice.value = '';
    contentCtr.type.value = ActionType.use.title;
    contentCtr.cardColor!.value = ActionType.use.iconColor!;
    if (contentCtr.balance.value == 0) {
      contentCtr.type.value = ActionType.add.title;
      contentCtr.cardColor!.value = ActionType.add.iconColor!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1000,
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.customer.name,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                Obx(
                                  () => Text(
                                      '${f.format(contentCtr.balance.value)}원',
                                      style: const TextStyle(
                                          fontSize: 50,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Menu(
                                  onTap: () {
                                    contentCtr.cardColor!.value =
                                        ActionType.add.iconColor!;
                                    contentCtr.type.value =
                                        ActionType.add.title;
                                    mode = "충전하기";
                                    contentCtr.enterUsePrice.value = '';
                                    // setState(() {
                                    //
                                    // });
                                  },
                                  icon: Icons.attach_money_rounded,
                                  title: '충전하기',
                                  type: ActionType.add),
                            ),
                            const Gap(5),
                            Expanded(
                              child: Menu(
                                  onTap: () {
                                    contentCtr.cardColor!.value =
                                        ActionType.use.iconColor!;
                                    contentCtr.type.value =
                                        ActionType.use.title;
                                    mode = "사용하기";
                                    contentCtr.enterUsePrice.value = '';
                                    // setState(() {
                                    //
                                    // });
                                  },
                                  icon: Icons.sell,
                                  title: '사용하기',
                                  type: ActionType.use),
                            ),
                            const Gap(5),
                            Expanded(
                              child: Menu(
                                  onTap: () {
                                    contentCtr.cardColor!.value =
                                        ActionType.card.iconColor!;
                                    contentCtr.type.value =
                                        ActionType.card.title;
                                    mode = "충전하기";
                                    contentCtr.enterUsePrice.value = '';
                                    // setState(() {
                                    //
                                    // });
                                  },
                                  icon: Icons.credit_card_rounded,
                                  title: '즐겨찾기',
                                  type: ActionType.card),
                            ),
                            const Gap(5),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    if (favorite.value) {
                                      await supabase.from('customer').upsert({
                                        'id': widget.customer.id,
                                        'favorite': false,
                                      });
                                      favorite.value = false;
                                    } else {
                                      await supabase.from('customer').upsert({
                                        'id': widget.customer.id,
                                        'favorite': true,
                                      });
                                      favorite.value = true;
                                    }
                                  },
                                  child: Obx(() => Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: favorite.value
                                                    ? Colors.amber
                                                    : Colors.grey,
                                                size: 45,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.grey[100]),
                                child: const Center(child: Text('sample')))),
                        const Gap(10),

                        Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.grey[100]),
                                child:
                                    const Center(child: Icon(Icons.qr_code)))),
                        const Gap(10),
                        // 기록 카드 부분
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Colors.grey[100]),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        contentCtr.cardColor!.value =
                                            Colors.black87;
                                        contentCtr.type.value =
                                            ActionType.record.title;
                                      },
                                      child: SizedBox(
                                        child: FutureBuilder(
                                            future: supabase
                                                .from('balance_log')
                                                .select()
                                                .eq('customer_id',
                                                    widget.customer.id)
                                                .order('created_at',
                                                    ascending: false),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Text('nodata');
                                              }
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder: (conext, index) {
                                                    final logData =
                                                        snapshot.data![index];

                                                    var option = 'add';
                                                    var title = '충전';
                                                    var optionColor =
                                                        Colors.green;
                                                    if (logData['type']
                                                            .toString() ==
                                                        'use') {
                                                      option = 'use';
                                                      title = '사용';
                                                      optionColor = Colors.grey;
                                                    }
                                                    var time = DateTime.parse(
                                                        logData['created_at']);
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                color: Colors
                                                                    .grey[100]),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                title,
                                                                style: TextStyle(
                                                                    color:
                                                                        optionColor),
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
                        ),

                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text('메뉴 ',
                        //         style:
                        //             TextStyle(fontSize: 16, color: Colors.grey)),
                        //     Menu(
                        //         onTap: () {
                        //           contentCtr.type.value = MenuType.record.title;
                        //           // setState(() {});
                        //         },
                        //         icon: Icons.list_alt_rounded,
                        //         title: '기록',
                        //         type: MenuType.record),
                        //     Menu(
                        //         onTap: () {
                        //           contentCtr.type.value = MenuType.setting.title;
                        //           // setState(() {});
                        //         },
                        //         icon: Icons.settings,
                        //         title: '설정',
                        //         type: MenuType.setting),
                        //   ],
                        // ),

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
                  const Gap(10),
                  // 오른쪽 카드
                  !showCheckBox.value
                      ? Expanded(
                          child: Obx(() => Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: contentCtr.cardColor!.value),
                                child: Obx(() {
                                  if (contentCtr.type.value ==
                                          ActionType.add.title ||
                                      contentCtr.type.value ==
                                          ActionType.use.title) {
                                    var title = ActionType.use.title;
                                    var textColor = Colors.blue;
                                    var text = '사용';
                                    var showNumber = 0;
                                    var priceSize = 30.0;
                                    Color? priceColor = Colors.grey[100];
                                    var f = NumberFormat('###,###,###,###');
                                    if (contentCtr.enterUsePrice.value != '') {
                                      showNumber = int.parse(
                                          contentCtr.enterUsePrice.value);
                                      priceSize = 50.0;
                                      priceColor = Colors.white;
                                    }
                                    if (contentCtr.type.value ==
                                        ActionType.add.title) {
                                      title = ActionType.add.title;
                                      textColor = Colors.green;
                                      text = "충전";
                                    }

                                    var content =
                                        contentCtr.enterUsePrice.value == ''
                                            ? '금액을 입력해주세요'
                                            : '${f.format(showNumber)}원';
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(5),
                                          RichText(
                                            text: TextSpan(
                                              text: '잔액 ',
                                              style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize:
                                                      24), //기본style을 지정해줘야함
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: f.format(contentCtr
                                                        .balance.value),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                const TextSpan(text: '원에서'),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: '얼마를 ',
                                              style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize:
                                                      24), //기본style을 지정해줘야함
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: text,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                const TextSpan(text: '할까요?'),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            content,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: priceSize,
                                                color: priceColor),
                                          ))),
                                          NumberPad(),
                                          const Gap(10),
                                          contentCtr.type.value ==
                                                  ActionType.use.title
                                              ? MyBtn(
                                                  text: ActionType.use.title,
                                                  menuType: ActionType.use,
                                                  onTap: () async {
                                                    addOrUseFun(
                                                        ActionType.use.state);
                                                  },
                                                  color:
                                                      ActionType.use.iconColor,
                                                )
                                              : MyBtn(
                                                  menuType: ActionType.add,
                                                  text: ActionType.add.title,
                                                  onTap: () async {
                                                    addOrUseFun(
                                                        ActionType.add.state);
                                                  },
                                                  color:
                                                      ActionType.add.iconColor,
                                                ),
                                        ],
                                      ),
                                    );
                                  }
                                  if (contentCtr.type.value ==
                                      ActionType.card.title) {
                                    var textColor = Colors.blue;
                                    var text = '사용';
                                    var showNumber = 0;
                                    var priceSize = 24.0;
                                    Color? priceColor = Colors.grey;

                                    if (contentCtr.enterUsePrice.value != '') {
                                      showNumber = int.parse(
                                          contentCtr.enterUsePrice.value);
                                      priceSize = 30.0;
                                      priceColor = Colors.white;
                                    }
                                    var content =
                                        contentCtr.enterUsePrice.value == ''
                                            ? '카드번호나 바코드를 입력해주세요'
                                            : '$showNumber';
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ActionType.card.title,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(5),
                                          Text(
                                              '카드를 등록해 편리하게 사용할수있어요'.toString(),
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                              )),
                                          const Gap(30),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            content,
                                            style: TextStyle(
                                                fontSize: priceSize,
                                                color: priceColor),
                                          ))),
                                          NumberPad(),
                                          const Gap(10),
                                          MyBtn(
                                            menuType: ActionType.card,
                                            text: ActionType.card.title,
                                            onTap: () {},
                                            color: ActionType.card.iconColor,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  if (contentCtr.type.value == '기록') {
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '기록',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Gap(20),
                                            FutureBuilder(
                                                future: supabase
                                                    .from('balance_log')
                                                    .select()
                                                    .eq('customer_id',
                                                        widget.customer.id)
                                                    .order('id',
                                                        ascending: false),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Text('nodata');
                                                  }
                                                  return Expanded(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        physics:
                                                            const AlwaysScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (conext, index) {
                                                          final logData =
                                                              snapshot
                                                                  .data![index];
                                                          var option = 'add';
                                                          var title = '충전';
                                                          var optionColor =
                                                              Colors.green;
                                                          if (logData['type']
                                                                  .toString() ==
                                                              'use') {
                                                            option = 'use';
                                                            title = '사용';
                                                            optionColor =
                                                                Colors.blue;
                                                          }
                                                          var time = DateTime
                                                              .parse(logData[
                                                                  'created_at']);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 5),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                          .grey[
                                                                      100]),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(DateFormat(
                                                                            'yy년MM월dd일 HH시mm분ss초')
                                                                        .format(
                                                                            time)),
                                                                    Text(
                                                                        '${f.format(logData['money'])}원'),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              20)),
                                                                          color:
                                                                              optionColor),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          title,
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  if (contentCtr.type.value ==
                                      ActionType.setting.title) {
                                    return const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '설정',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
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
                                }),
                              )))
                      : Expanded(
                          child: Opacity(
                            opacity: _containerO,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _containerO = 0.0;
                                });
                              },
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _containerO = 1.0;
                                      _containerH = 150;
                                      _containerW = 150;
                                    });
                                  },
                                  child: AnimatedContainer(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.white),
                                      width: _containerW,
                                      height: _containerH,
                                      duration:
                                          const Duration(milliseconds: 800),
                                      curve: Curves.fastOutSlowIn,
                                      child: const Center(
                                          child: FittedBox(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 100,
                                          ),
                                        ),
                                      ))),
                                ),
                              ),
                            ),
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }

  Expanded NumberPad() {
    return Expanded(
        flex: 1,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
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

    setState(() {
      showCheckBox.value = true;
      _containerO = 1.0;
      _containerW = 100;
      _containerH = 100;
      Future.delayed(const Duration(seconds: 1), () {
        showCheckBox.value = false;

        setState(() {
          _containerW = 50;
          _containerH = 50;
        });
      });
      Future.delayed(const Duration(milliseconds: 1700), () {
        showCheckBox.value = false;

        setState(() {
          _containerO = 0.0;
        });
      });
    });
  }

  Expanded number_padd({required int number}) {
    return Expanded(
      child: InkWell(
          onTap: () {
            contentCtr.enterUsePrice.value =
                contentCtr.enterUsePrice + number.toString();
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
                child: Text(
              number.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
          )),
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
    return InkWell(
        onTap: onTap,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[100],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: type.iconColor,
                  size: 35,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                // Text(
                //   type.title,
                //   style: const TextStyle(color: Colors.white),
                // ),
              ],
            ),
          ),
        ));
  }
}

class MyBtn extends StatelessWidget {
  const MyBtn({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
    required this.menuType,
  });

  final GestureTapCallback onTap;
  final Color? color;
  final String text;
  final ActionType menuType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: menuType.buttonColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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

            // double newBalance = beforeBalance + enterBalance;
            // await supabase.from('customer').upsert({
            //   'id': customerId,
            //   'balance': newBalance,
            // });
            // await supabase.from('balance_log').upsert({
            //   'customer_id': customerId,
            //   'type': 'add',
            //   'money': enterBalance,
            // });
            // contentCtr.balance.value = newBalance;
            // contentCtr.enterPrice.value = '';
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

