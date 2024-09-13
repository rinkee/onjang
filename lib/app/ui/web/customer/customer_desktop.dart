import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/controller/navigation_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';

import 'package:jangboo_flutter/app/ui/web/customer/edit_customer_info_screen.dart';
import 'package:jangboo_flutter/app/ui/web/customer/show_record_screen.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:responsive_framework/responsive_framework.dart';

CustomerContentController _customerCtr = Get.find<CustomerContentController>();

class CustomerDesktop extends StatefulWidget {
  CustomerDesktop({super.key, required this.customer});

  CustomerModel customer;

  @override
  State<CustomerDesktop> createState() {
    return _CustomerDesktopState();
  }
}

class _CustomerDesktopState extends State<CustomerDesktop> {
  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController numberPadCtr = TextEditingController();

  final TextEditingController addPointCtr = TextEditingController();

  var f = NumberFormat('###,###,###,###');
  var favorite = false.obs;
  var idx = 0;
  late CustomerModel customer;
  final openDialog = false.obs;
  var initCustomerMode = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    getCustomerModeGetStorage();
    numberPadCtr.addListener(() {
      _customerCtr.enterUsePrice.value = numberPadCtr.text;
    });

    addPointCtr.addListener(() {
      _customerCtr.enterAddPrice.value = addPointCtr.text;
    });
    // idx = customerCtr.currentCustomerIndex;m
    customer = widget.customer;
    favorite.value = customer.favorite;
    _customerCtr.coId.value = customer.id;
    _customerCtr.coTeamName.value = customer.name;
    _customerCtr.coName.value = '';
    if (customer.companyName != '') {
      _customerCtr.coName.value = customer.companyName;
    }
    if (customer.barcode != null) {
      _customerCtr.coBarcode.value = customer.barcode!;
    }
    if (customer.phone != null) {
      _customerCtr.coPhone.value = customer.phone!;
    }
    if (customer.card != null) {
      _customerCtr.coCard.value = customer.card!;
    }

    _customerCtr.balance.value = customer.balance;
    _customerCtr.enterUsePrice.value = '';

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

  // // 각 TextField를 위한 FocusNode 생성
  // final FocusNode _nameFocusNode = FocusNode();
  // final FocusNode _phoneFocusNode = FocusNode();
  // final FocusNode _cardNumberFocusNode = FocusNode();
  // final FocusNode _barcodeFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   // 리소스 해제
  //   _nameFocusNode.dispose();
  //   _phoneFocusNode.dispose();
  //   _cardNumberFocusNode.dispose();
  //   _barcodeFocusNode.dispose();
  //   super.dispose();
  // }

  final isLoading = false.obs;

  getCustomerModeGetStorage() async {
    await GetStorage.init();
    final box = GetStorage();
    var tt = box.read('customerMode');
    print('getCustomerModeGetStorage');
    print(tt);
    if (tt == true) {
      initCustomerMode.value = true;
    } else {
      initCustomerMode.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(
            () => Visibility(
              visible: !initCustomerMode.value,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          final nameCtr = TextEditingController();
                          final phoneCtr = TextEditingController();
                          final cardCtr = TextEditingController();
                          final barcodeCtr = TextEditingController();
                          nameCtr.text = _customerCtr.coTeamName.value;
                          phoneCtr.text = _customerCtr.coPhone.value;
                          cardCtr.text = _customerCtr.coCard.value;
                          barcodeCtr.text = _customerCtr.coBarcode.value;

                          return SingleChildScrollView(
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          '고객 정보',
                                          style: menuTitle,
                                        ),
                                        ButtonWidget(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: const AspectRatio(
                                                aspectRatio: 1,
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  color: Colors.grey,
                                                ))),
                                      ],
                                    ),
                                    const Gap(10),
                                    Obx(() => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InfoText(
                                              title: '회사명',
                                              value: _customerCtr.coName.value,
                                            ),
                                            InfoText(
                                              title: '부서 / 이름명',
                                              value:
                                                  _customerCtr.coTeamName.value,
                                            ),
                                            InfoText(
                                              title: '전화번호',
                                              value: _customerCtr.coPhone.value,
                                            ),
                                            InfoText(
                                              title: '등록된 카드 번호',
                                              value: _customerCtr.coCard.value,
                                            ),
                                            InfoText(
                                              title: '등록된 바코드 번호',
                                              value:
                                                  _customerCtr.coBarcode.value,
                                            ),
                                          ],
                                        )),
                                    const Gap(30),
                                    ButtonWidget(
                                        bgColor: Colors.grey[200],
                                        onTap: () async {
                                          // await customerCtr.fucDeleteCustomer(
                                          //     customerId: customer.id);
                                          Get.to(() => EditCustomerInfoScreen(
                                                customerId: customer.id,
                                              ));
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Center(
                                              child: Text(
                                            '고객 정보 수정',
                                            style: TextStyle(),
                                          )),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.settings)),
            ),
          ),
          Obx(() => Visibility(
                visible: !initCustomerMode.value,
                child: IconButton(
                    onPressed: () {
                      AskDeleteLedger(context);
                    },
                    icon: const Icon(Icons.delete_outline_rounded)),
              ))
        ],
      ),
      body: StreamBuilder(
          stream: supabase
              .from('balance_log')
              .stream(primaryKey: ['id'])
              .eq(
                'customer_id',
                customer.id,
              )
              .order('created_at', ascending: false),
          builder: (context, snapshot) {
            print('rebuildd');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('잠시후 다시 시도해주세요'),
              );
            }
            var groupedTransactions = groupTransactionsByDate(snapshot.data!);
            // 날짜와 가격 처리를 위한 함수
            String formatLastUsedDate(DateTime createdAt) {
              final today = DateTime.now();
              final difference = today.difference(createdAt).inDays;

              if (difference > 0) {
                return '$difference일 전';
              } else {
                return '오늘';
              }
            }

            // 메인 로직
            var lastUsedDate = '기록 없음';
            var lastUsedPrice = 0;
            var avgUsedMoney = 0.0;

            if (snapshot.data!.isNotEmpty) {
              var logData = snapshot.data!.first;
              print(snapshot.data!.first);

              // 마지막 사용 날짜 처리
              if (logData['created_at'] != null) {
                lastUsedDate =
                    formatLastUsedDate(DateTime.parse(logData['created_at']));
              }

              // 마지막 사용 금액 처리
              lastUsedPrice = logData['money'] ?? 0;

              // 'use' 타입의 데이터 필터링 및 평균 계산
              var usedMoneyData = snapshot.data!
                  .where(
                      (data) => data['type'] == 'use' && data['money'] != null)
                  .map((data) => int.parse(data['money'].toString()))
                  .toList();

              if (usedMoneyData.isNotEmpty) {
                avgUsedMoney =
                    usedMoneyData.reduce((value, element) => value + element) /
                        usedMoneyData.length;
              }
            }

            return Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          NameAndActionButton(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 20),
                            child: Divider(
                              color: Colors.grey[100],
                            ),
                          ),
                          History(
                              groupedTransactions: groupedTransactions,
                              customer: customer,
                              f: f),
                          const Gap(30),
                          Row(
                            children: [
                              StackContent(
                                title: '마지막 사용',
                                content: lastUsedDate,
                              ),
                              const Gap(10),
                              StackContent(
                                title: '최근 사용 포인트',
                                content:
                                    '${f.format(lastUsedPrice)}P', // lastUsedPrice가 int 타입이라면, int.parse() 제거
                              ),
                              const Gap(10),
                              StackContent(
                                title: '평균 사용 포인트',
                                content:
                                    '${f.format(avgUsedMoney.floor())}P', // avgUsedMoney를 바닥 함수로 처리하고 포맷 적용
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(26),
                          const Text(
                            '사용할 포인트를 적어주세요',
                            style: TextStyle(fontSize: 20),
                          ),
                          Obx(() => Text(
                                _customerCtr.enterUsePrice.value == ''
                                    ? '0P'
                                    : '${f.format(int.parse(_customerCtr.enterUsePrice.value))}P',
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              )),
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Divider(),
                          ),
                          // const Gap(50),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: keys
                                    .map(
                                      (x) => Row(
                                        children: x.map((y) {
                                          return Expanded(
                                            child: NumberPadWidget(
                                              textCtr: numberPadCtr,
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
                          const Spacer(),
                          ButtonWidget(
                            onTap: () async {
                              _customerCtr.type.value = ActionType.use.title;
                              _customerCtr.seclectedMenu = ActionType.use;
                              if (isLoading.value == false &&
                                  _customerCtr.enterUsePrice.value != '') {
                                isLoading.value = true;
                                try {
                                  await _customerCtr
                                      .fucAddOrUse(
                                          customerId: customer.id,
                                          point: int.parse(
                                              _customerCtr.enterUsePrice.value))
                                      .then((value) {
                                    // setState(() {});

                                    isLoading.value = false;
                                    ShowDoneDialog(
                                        context: context,
                                        point: _customerCtr.enterUsePrice.value,
                                        action: ActionType.use);
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              } else {}
                            },
                            hoverColor: Colors.grey[300],
                            bgColor: sgColor,
                            child: Center(child: Obx(
                              () {
                                if (isLoading.value) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return const Text(
                                    '사용하기',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  );
                                }
                              },
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  Future<dynamic> ShowDoneDialog(
      {required BuildContext context,
      required String point,
      required ActionType action}) {
    _customerCtr.enterUsePrice.value = '';
    numberPadCtr.clear();
    openDialog.value = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            if (openDialog.value == true) {
              Navigator.pop(context);
            }
          });

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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  backgroundColor: subColor,
                                  radius: 30,
                                  child: Icon(
                                    action == ActionType.add
                                        ? Icons.wallet_rounded
                                        : Icons.check_rounded,
                                    color: sgColor,
                                  )),
                              const Gap(20),
                              Text(
                                '${f.format(int.parse(point))}P',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                action == ActionType.add ? '충전 완료' : '사용 완료',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const Gap(20),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonWidget(
                                  onTap: () async {
                                    Get.back();
                                    openDialog.value = false;
                                  },
                                  bgColor: sgColor,
                                  child: const Center(
                                    child: Text(
                                      '확인',
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

  Future<dynamic> AskDeleteLedger(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BorderContainerWidget(
                  w: 350,
                  h: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          '정말 이 장부를 삭제하시겠습니까?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonWidget(
                                  bgColor: subColor,
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Center(
                                    child: Text(
                                      '취소',
                                      style: TextStyle(color: sgColor),
                                    ),
                                  )),
                            ),
                            const Gap(15),
                            Expanded(
                              child: ButtonWidget(
                                  onTap: () async {
                                    Get.back();

                                    await _customerCtr
                                        .setDeleteCustomer(
                                            customerId: customer.id)
                                        .then((value) {
                                      Get.back();
                                      Get.snackbar(
                                          '${_customerCtr.coName.value} ${_customerCtr.coTeamName.value} ',
                                          '삭제완료',
                                          colorText: Colors.white,
                                          backgroundColor: Colors.black,
                                          snackPosition: SnackPosition.BOTTOM);
                                    });
                                  },
                                  child: const Center(
                                    child: Text('삭제'),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }

  Column NameAndActionButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _customerCtr.coName.value,
                      style: coNameText,
                    ),
                    Text(
                      _customerCtr.coTeamName.value,
                      style: coTeamText,
                    ),
                  ],
                ),
                // IconButton(
                //     onPressed: () {
                //       favorite.value = !favorite.value;
                //       _customerCtr.fucFavorite(
                //           customerId: customer.id, favorite: favorite.value);
                //     },
                //     icon: Icon(
                //       Icons.star_rounded,
                //       color: favorite.value ? Colors.amber : Colors.grey[300],
                //     ))
              ],
            )),
        Row(
          children: [
            Obx(
              () => Text(
                '${f.format(_customerCtr.balance.value)}P',
                style: const TextStyle(
                    fontSize: 36, fontWeight: FontWeight.bold, height: 1),
              ),
            ),
            const Gap(20),
            Visibility(
              visible: !initCustomerMode.value,
              child: ButtonWidget(
                  h: 50,
                  onTap: () {
                    _customerCtr.type.value = ActionType.add.title;

                    _customerCtr.enterUsePrice.value = '';
                    addPointCtr.clear();
                    numberPadCtr.clear();
                    _customerCtr.seclectedMenu = ActionType.add;
                    ActionBottomSheet();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.wallet_rounded, color: Colors.green),
                        Gap(6),
                        Text(
                          '충전하기',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        const Gap(10),
        // const Gap(30),
        // Row(
        //   children: [
        //     kBtn(
        //         onTap: () {},
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 20),
        //           child: Row(
        //             children: [
        //               Icon(
        //                 Icons.wallet_rounded,
        //                 color: sgColor,
        //               ),
        //               Gap(5),
        //               Text(
        //                 '충전하기',
        //                 style: TextStyle(),
        //               ),
        //             ],
        //           ),
        //         )),
        //     const Gap(10),
        //     Expanded(
        //       child: kBtn(
        //         onTap: () {
        //           customerCtr.type.value = ActionType.use.title;

        //           customerCtr.enterPrice.value = '';
        //           numberPadCtr.clear();
        //           customerCtr.seclectedMenu = ActionType.use;
        //           ActionBottomSheet();
        //         },
        //         hoverColor: Colors.grey[300],
        //         bgColor: sgColor,
        //         child: const Expanded(
        //           child: Center(
        //               child: Text(
        //             '사용하기',
        //             style: TextStyle(
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white),
        //           )),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }

  Future<dynamic> ActionBottomSheet() {
    var title = '사용하기';
    var useText = '얼마를 사용할까요?';
    Color color = sgColor;
    isLoading.value = false;

    if (_customerCtr.seclectedMenu == ActionType.add) {
      title = '충전하기';
      useText = '얼마를 충전할까요?';
      color = subColor;
    }
    final UserController _userCtr = Get.find<UserController>();

    final addPercent = _userCtr.user.value!.addRatio.obs;

    return showDialog(
        // backgroundColor: Colors.transparent,
        // isScrollControlled: true,
        context: context,
        builder: (context) {
          // final phoneCtr = TextEditingController();
          // final cardCtr = TextEditingController();
          // final barcodeCtr = TextEditingController();
          // nameCtr.text = customerCtr.coName.value;
          // phoneCtr.text = customerCtr.coPhone.value;
          // cardCtr.text = customerCtr.coCard.value;
          // barcodeCtr.text = customerCtr.coBarcode.value;

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Dialog(child: Obx(() {
              var entryPoint = 0.0;
              if (_customerCtr.enterAddPrice.value != '') {
                entryPoint = double.parse(_customerCtr.enterAddPrice.value);
              }
              var showAddPoint = _customerCtr.enterAddPrice.value == ''
                  ? useText
                  : '+ ${f.format(entryPoint)}P';

              var afterPoint = _customerCtr.balance.value +
                  entryPoint +
                  (entryPoint * addPercent.value / 100);

              var addPoint = entryPoint + (entryPoint * addPercent.value / 100);

              var showAfterPoint = _customerCtr.enterAddPrice.value == ''
                  ? ''
                  : '${f.format(afterPoint)}P';
              return MaxWidthBox(
                maxWidth: 700,
                child: BorderContainerWidget(
                    color: Colors.white,
                    h: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Gap(20),
                                    Text(
                                      '잔액 ${f.format(_customerCtr.balance.value)}P',
                                      style: TextStyle(
                                          fontSize: 18,
                                          height: 1.2,
                                          color: Colors.grey[700]),
                                    ),
                                    Text(
                                      showAddPoint,
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Gap(30),
                                    Text(
                                      '추가 충전',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700]),
                                    ),
                                    const Gap(5),
                                    Row(
                                      children: [
                                        BorderContainerWidget(
                                            w: 60,
                                            h: 40,
                                            radius: 15,
                                            color: Colors.grey[100],
                                            child: Center(
                                                child: Text(
                                              '$addPercent%',
                                              style: const TextStyle(
                                                  color: sgColor),
                                            ))),
                                        const Gap(10),
                                        ButtonWidget(
                                            w: 60,
                                            h: 40,
                                            onTap: () {
                                              if (addPercent.value > 0) {
                                                addPercent.value--;
                                              }
                                            },
                                            child: const Icon(Icons.remove)),
                                        const Gap(5),
                                        ButtonWidget(
                                            w: 60,
                                            h: 40,
                                            onTap: () {
                                              if (addPercent.value < 100) {
                                                addPercent.value++;
                                              }
                                            },
                                            child: const Icon(Icons.add)),
                                      ],
                                    ),
                                    const Gap(30),
                                    Text(
                                      '충전 후 포인트',
                                      style: TextStyle(
                                          fontSize: 18,
                                          height: 1.2,
                                          color: Colors.grey[700]),
                                    ),
                                    Text(
                                      showAfterPoint,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Gap(20),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: keys
                                          .map(
                                            (x) => Row(
                                              children: x.map((y) {
                                                return Expanded(
                                                  child: NumberPadWidget(
                                                    textCtr: addPointCtr,
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
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonWidget(
                                  onTap: () {
                                    Get.back();
                                    isLoading.value = false;
                                  },
                                  child: const AspectRatio(
                                      aspectRatio: 1,
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.grey,
                                      ))),
                              SizedBox(
                                width: 300,
                                child: ButtonWidget(
                                    onTap: () async {
                                      if (isLoading.value == false) {
                                        isLoading.value = true;
                                        try {
                                          await _customerCtr
                                              .fucAddOrUse(
                                                  customerId: customer.id,
                                                  point: addPoint.toInt())
                                              .then((value) {
                                            Get.back();

                                            isLoading.value = false;

                                            ShowDoneDialog(
                                                context: context,
                                                point: _customerCtr
                                                    .enterAddPrice.value,
                                                action: ActionType.add);
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                      } else {}
                                    },
                                    bgColor: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Center(
                                          child: Text(
                                        title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              );
            })),
          );
        });
  }

  Map<String, List<Map<String, dynamic>>> groupTransactionsByDate(
      List<Map<String, dynamic>> transactions) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var transaction in transactions) {
      var createdAt = DateTime.parse(transaction['created_at']);
      String date;
      if (createdAt.year == DateTime.now().year) {
        date = DateFormat('M.d').format(createdAt);
      } else {
        date = DateFormat('yy.M.d').format(createdAt);
      }

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }
    return grouped;
  }

  Expanded StackContent({
    required String title,
    required String content,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Gap(5),
            Text(
              content,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ]),
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  const History({
    super.key,
    required this.groupedTransactions,
    required this.customer,
    required this.f,
  });

  final Map<String, List<Map<String, dynamic>>> groupedTransactions;
  final CustomerModel customer;
  final NumberFormat f;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '사용 기록',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              groupedTransactions.isEmpty
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () {
                        Get.to(() => ShowRecordScreen(customerId: customer.id));
                      },
                      child: const Text('더보기'))
            ],
          ),
          groupedTransactions.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.grey,
                        ),
                        Gap(10),
                        Text(
                          '아직 기록이 없어요',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                  itemCount: groupedTransactions.keys.length,
                  itemBuilder: (context, index) {
                    String date = groupedTransactions.keys.elementAt(index);
                    List<Map<String, dynamic>> dailyTransactions =
                        groupedTransactions[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Text(date,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              )),
                        ),
                        ListView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(), // 중첩된 ListView 스크롤 문제 방지
                          shrinkWrap: true, // 내부 ListView 크기 자동 조절
                          itemCount: dailyTransactions.length,
                          itemBuilder: (context, idx) {
                            var transaction = dailyTransactions[idx];

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    MenuDialog(context, transaction);
                                    print(transaction);
                                    // if (transaction['canceled'] == true) {
                                    //   AskCanceledToBack(
                                    //       context,
                                    //       transaction['money'],
                                    //       transaction['id'],
                                    //       transaction['type'] == 'add',
                                    //       transaction);
                                    // } else {
                                    //   AskDeleteUsed(
                                    //       context,
                                    //       transaction['money'],
                                    //       transaction['id'],
                                    //       transaction['type'] == 'add',
                                    //       transaction);
                                    // }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        transaction['type'] == 'add'
                                            ? CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    Colors.green[100],
                                                child: const Icon(
                                                  size: 18,
                                                  Icons.add_rounded,
                                                  color: Colors.green,
                                                ))
                                            : CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[100],
                                                radius: 16,
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                  color: Colors.grey,
                                                )),
                                        const Gap(14),
                                        Text(
                                          '${f.format(transaction['money'])}P',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: transaction['canceled'] ==
                                                      true
                                                  ? Colors.grey
                                                  : Colors.grey[700]),
                                        ),
                                        // const Gap(20),
                                        // Icon(
                                        //   Icons.sticky_note_2_rounded,
                                        //   color: Colors.grey[300],
                                        // ),

                                        transaction['memo'] != null
                                            ? Expanded(
                                                child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .sticky_note_2_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  const Gap(5),
                                                  Text(transaction['memo']),
                                                ],
                                              ))
                                            : const Spacer(),
                                        Text(
                                          transaction['canceled'] == true
                                              ? '취소 됨'
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.blue),
                                        ),
                                        const Gap(10),
                                        Text(
                                          DateFormat('HH:mm').format(
                                              DateTime.parse(
                                                  transaction['created_at'])),
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        const Gap(10),
                                        // Text(
                                        //   transaction['type'] == 'add'
                                        //       ? '충전'
                                        //       : '사용',
                                        //   style: TextStyle(
                                        //       fontSize: 14,
                                        //       color: transaction['type'] == 'add'
                                        //           ? sgColor
                                        //           : Colors.grey),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey[100],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                )),
        ],
      ),
    );
  }

  Future<dynamic> MenuDialog(BuildContext context, Map<String, dynamic> data) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BorderContainerWidget(
              w: 300,
              h: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                    ButtonWidget(
                        bgColor: Colors.white,
                        onTap: () {
                          Get.back();
                          if (data['canceled'] == true) {
                            AskCanceledToBack(context, data['money'],
                                data['id'], data['type'] == 'add', data);
                          } else {
                            AskDeleteUsed(context, data['money'], data['id'],
                                data['type'] == 'add', data);
                          }
                        },
                        child: const Text('이 사용 취소하기')),
                    const Divider(),
                    ButtonWidget(
                        bgColor: Colors.white,
                        onTap: () {
                          Get.back();
                          var beforeMemo = data['memo'] ?? '';
                          MemoDialog(context, data['id'], beforeMemo);
                        },
                        child: const Text('메모 남기기')),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> MemoDialog(BuildContext context, int id, String beforeMemo) {
    TextEditingController memoCtr = TextEditingController();
    memoCtr.text = beforeMemo;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BorderContainerWidget(
              w: 500,
              h: 350,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      '이 사용에 대한 메모를 남길 수 있어요.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Gap(10),
                    BorderContainerWidget(
                      h: 150,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 5,
                          controller: memoCtr,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) async {
                            await _customerCtr.fucAddMemo(
                                id: id,
                                customerId: customer.id,
                                memo: memoCtr.text);
                            Get.back();
                          },
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                    const Gap(20),
                    ButtonWidget(
                        onTap: () async {
                          await _customerCtr.fucAddMemo(
                              id: id,
                              customerId: customer.id,
                              memo: memoCtr.text);
                          Get.back();
                        },
                        bgColor: Colors.blue,
                        hoverColor: Colors.blue[600],
                        child: const Text(
                          '저장하기',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> AskDeleteUsed(BuildContext context, int point, int id,
      bool used, Map<String, dynamic> data) {
    var isLoading = false;
    var showText = '충전'; // used가 트루면 충전 false면 사용
    if (used == false) {
      showText = '사용';
    }

    var password = ''.obs;
    const storage = FlutterSecureStorage();
    TextEditingController passwordCtr = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BorderContainerWidget(
                  w: 450,
                  h: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                                DateFormat(
                                  'yy년MM월dd일  HH시mm분ss초',
                                ).format(DateTime.parse(
                                    data['created_at'].toString())),
                                style: const TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  // CircleAvatar(
                                  //   radius: 16,
                                  //   backgroundColor: showText == '충전'
                                  //       ? Colors.green[100]
                                  //       : Colors.grey[100],
                                  //   child: Icon(
                                  //     showText == '충전'
                                  //         ? Icons.add
                                  //         : Icons.remove,
                                  //     size: 18,
                                  //     color: showText == '충전'
                                  //         ? Colors.green
                                  //         : Colors.grey,
                                  //   ),
                                  // ),
                                  // const Gap(5),
                                  Text(
                                    '${f.format(point)}P',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            password.value.length > index
                                                ? Colors.black
                                                : Colors.grey[300],
                                      ),
                                    ));
                              }),
                        ),
                        const Gap(10),
                        const Text(
                          '취소하려면 비밀번호를 입력해주세요',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Container(
                          width: 350,
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
                                            textCtr: passwordCtr,
                                            label: y,
                                            ratio: 3,
                                            onTap: (val) async {
                                              password.value = password + val;
                                              print(password);
                                              if (password.value.length == 4) {
                                                if (password.value == '0000') {
                                                  print('비번 확인');
                                                  if (isLoading == false) {
                                                    isLoading = true;
                                                    await _customerCtr
                                                        .fucCancleUse(
                                                            used: used,
                                                            id: id,
                                                            point: point,
                                                            customerId:
                                                                customer.id);

                                                    isLoading = false;
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
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: kBtn(
                        //           bgColor: subColor,
                        //           onTap: () {
                        //             Get.back();
                        //           },
                        //           child: const Center(
                        //             child: Text(
                        //               '아니요',
                        //               style: TextStyle(color: sgColor),
                        //             ),
                        //           )),
                        //     ),
                        //     const Gap(15),
                        //     Expanded(
                        //       child: kBtn(
                        //           onTap: () async {
                        //             if (isLoading == false) {
                        //               isLoading = true;
                        //               await customerCtr.fucCancleUse(
                        //                   used: used,
                        //                   id: id,
                        //                   point: point,
                        //                   customerId: customer.id);

                        //               isLoading = false;
                        //               Get.back();
                        //             }
                        //           },
                        //           child: const Center(
                        //             child: Text('네'),
                        //           )),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  )));
        });
  }

  Future<dynamic> AskCanceledToBack(BuildContext context, int point, int id,
      bool used, Map<String, dynamic> data) {
    var isLoading = false;
    var showText = '충전을 취소 할까요?'; // used가 트루면 충전 false면 사용
    if (used == false) {
      showText = '사용을 취소 할까요?';
    }

    var password = ''.obs;
    const storage = FlutterSecureStorage();
    TextEditingController passwordCtr = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BorderContainerWidget(
                  w: 450,
                  h: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat(
                                    'yy년MM월dd일  HH시mm분ss초',
                                  ).format(DateTime.parse(
                                      data['created_at'].toString())),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${f.format(point)}P',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                const Gap(10),
                                const Text(
                                  '취소됨',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 22),
                                ),
                              ],
                            ),
                          ],
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            password.value.length > index
                                                ? Colors.black
                                                : Colors.grey[300],
                                      ),
                                    ));
                              }),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(
                            '취소를 되돌리려면 비밀번호를 입력해주세요',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: 350,
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
                                            textCtr: passwordCtr,
                                            label: y,
                                            ratio: 3,
                                            onTap: (val) async {
                                              password.value = password + val;
                                              print(password);
                                              if (password.value.length == 4) {
                                                if (password.value == '0000') {
                                                  print('비번 확인');
                                                  if (isLoading == false) {
                                                    isLoading = true;
                                                    await _customerCtr
                                                        .fucCancleToBack(
                                                            used: used,
                                                            id: id,
                                                            point: point,
                                                            customerId:
                                                                customer.id);

                                                    isLoading = false;
                                                    Get.back();
                                                  }
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
                        // 네 아니요 버튼
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: kBtn(
                        //           bgColor: subColor,
                        //           onTap: () {
                        //             Get.back();
                        //           },
                        //           child: const Center(
                        //             child: Text(
                        //               '아니요',
                        //               style: TextStyle(color: sgColor),
                        //             ),
                        //           )),
                        //     ),
                        //     const Gap(15),
                        //     Expanded(
                        //       child: kBtn(
                        //           onTap: () async {
                        //             if (isLoading == false) {
                        //               isLoading = true;
                        //               await customerCtr.fucCancleToBack(
                        //                   used: used,
                        //                   id: id,
                        //                   point: point,
                        //                   customerId: customer.id);

                        //               isLoading = false;
                        //               Get.back();
                        //             }
                        //           },
                        //           child: const Center(
                        //             child: Text('네'),
                        //           )),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  )));
        });
  }
}

class InfoText extends StatelessWidget {
  const InfoText({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: cardBalance,
        ),
        const Gap(3),
        Text(
          value,
          style: cardTitle,
        ),
        const Gap(15),
      ],
    );
  }
}
