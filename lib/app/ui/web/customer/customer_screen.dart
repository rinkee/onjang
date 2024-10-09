import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/controller/signature_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/introduce_screen.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';
import 'package:jangboo_flutter/app/ui/widget/password_dots_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/state_change_button_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:signature/signature.dart';

CustomerController _customerCtr = Get.find<CustomerController>();

class CustomerScreen extends StatefulWidget {
  CustomerScreen({
    super.key,
  });

  // CustomerModel customer;

  @override
  State<CustomerScreen> createState() {
    return _CustomerScreenState();
  }
}

class _CustomerScreenState extends State<CustomerScreen> {
  var favorite = false.obs;
  late CustomerModel customer;
  final openDialog = false.obs;
  var initCustomerMode = false.obs;
  final isLoading = false.obs;
  final ForSignatureController _signatureController = Get.find();
  final initUseSignature = false.obs;

// INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD

  @override
  void initState() {
    // TODO: implement initState
    getCustomerModeGetStorage();

    // idx = customerCtr.currentCustomerIndex;m
    customer = _customerCtr.selectedCustomer.value!;
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
    _customerCtr.addPointValue.value = '';
    initUseSignature.value = customer.useSignature;
    super.initState();
  }

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
      resizeToAvoidBottomInset: false,
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
                                              context.pop();
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
                                          context.pop();
                                          var customerId = customer.id;
                                          print(customerId);

                                          context.goNamed(
                                            Routes.customerEdit,
                                            pathParameters: {
                                              'id': customerId.toString()
                                            },
                                          );
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
                Container(
                  width: 430,
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
                                _customerCtr.addPointValue.value == ''
                                    ? '0P'
                                    : '${f.format(int.parse(_customerCtr.addPointValue.value))}P',
                                style: const TextStyle(
                                    height: 1.2,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold),
                              )),

                          // Divider(),
                          Gap(20),
                          Obx(
                            () => Center(
                              child: MaxWidthBox(
                                maxWidth: 450,
                                child: NumberPadWidget(
                                  value: _customerCtr.addPointValue.value,
                                  aspectRatio: 1.8,
                                  numberStyle: TextStyle(fontSize: 26),
                                  onChanged: (newValue) {
                                    _customerCtr.addPointValue.value = newValue;
                                    // inputValue.value = newValue;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '결제 시 서명 사용',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const Gap(3),
                              Obx(
                                () => Switch(
                                    value: initUseSignature.value,
                                    onChanged: (newV) async {
                                      initUseSignature.value = newV;
                                      await _customerCtr.toggleUseSignature(
                                          customerId: customer.id, newV: newV);
                                      _customerCtr.loadCustomerList();
                                    }),
                              )
                            ],
                          ),

                          const Spacer(),
                          ButtonWidget(
                            onTap: () async {
                              var point =
                                  int.parse(_customerCtr.addPointValue.value);
                              if (isLoading.value == false &&
                                  _customerCtr.addPointValue.value != '' &&
                                  point != 0) {
                                print('use');
                                isLoading.value = true;
                                if (initUseSignature.value) {
                                  print('this customer use signautre ');
                                  _signatureController.SignatureDialog(
                                      context, customer.id, () async {
                                    await _customerCtr
                                        .usePoint(
                                      customerId: customer.id,
                                      point: int.parse(
                                        _customerCtr.addPointValue.value,
                                      ),
                                      signature: _signatureController
                                          .signatureName.value,
                                    )
                                        .then((value) {
                                      context.pop();
                                      isLoading.value = false;
                                      _customerCtr.loadCustomerList();
                                      _signatureController.clearSignature();

                                      ShowDoneDialog(
                                        context: context,
                                        point: _customerCtr.addPointValue.value,
                                        action: 'use',
                                      );
                                    });
                                  });
                                } else {
                                  print('this customer not use signautre ');
                                  await _customerCtr
                                      .usePoint(
                                    customerId: customer.id,
                                    point: int.parse(
                                      _customerCtr.addPointValue.value,
                                    ),
                                    signature: _signatureController
                                        .signatureName.value,
                                  )
                                      .then((value) {
                                    // context.pop();
                                    isLoading.value = false;
                                    _customerCtr.loadCustomerList();
                                    _signatureController.clearSignature();

                                    ShowDoneDialog(
                                      context: context,
                                      point: _customerCtr.addPointValue.value,
                                      action: 'use',
                                    );
                                  });
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

  // void SignatureDialog(BuildContext context) {
  //   try {
  //     showDialog(
  //         context: context,
  //         builder: (context) => Dialog(
  //               backgroundColor: Colors.white,
  //               child: SizedBox(
  //                   width: 500,
  //                   height: 400,
  //                   child: StatefulBuilder(builder: (context, setDialog) {
  //                     return Padding(
  //                       padding: const EdgeInsets.all(20.0),
  //                       child: Column(
  //                         children: [
  //                           Text(
  //                             '서명을 해주세요',
  //                             style: coNameText,
  //                           ),
  //                           Gap(10),
  //                           Center(child: _signatureController.signatureCanvas),
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 IconButton(
  //                                     onPressed: () {
  //                                       _sigCtr.undo();
  //                                     },
  //                                     icon: Icon(Icons.undo_rounded)),
  //                                 IconButton(
  //                                     onPressed: () {
  //                                       _sigCtr.clear();
  //                                     },
  //                                     icon: Icon(Icons.close)),
  //                               ],
  //                             ),
  //                           ),
  //                           Spacer(),
  //                           ButtonWidget(
  //                               bgColor:
  //                                   _sigCtr.value.isEmpty ? null : Colors.blue,
  //                               onTap: () async {
  //                                 var signatureName = '';

  //                                 var image = await _sigCtr.toPngBytes();
  //                                 if (_sigCtr.value.isNotEmpty &&
  //                                     image != null) {
  //                                   signatureName = customer.id.toString() +
  //                                       DateTime.now().toString() +
  //                                       '.png';
  //                                   print(signatureName);
  //                                   final String fullPath = await supabase
  //                                       .storage
  //                                       .from('signatures/${customer.id}')
  //                                       .uploadBinary(
  //                                         signatureName,
  //                                         image,
  //                                       );
  //                                 }

  //                                 await _customerCtr
  //                                     .usePoint(
  //                                         customerId: customer.id,
  //                                         point: int.parse(
  //                                           _customerCtr.addPointValue.value,
  //                                         ),
  //                                         signature: signatureName)
  //                                     .then((value) {
  //                                   // setState(() {});
  //                                   context.pop();
  //                                   isLoading.value = false;
  //                                   _customerCtr.loadCustomerList();
  //                                   _sigCtr.clear();
  //                                   ShowDoneDialog(
  //                                       context: context,
  //                                       point: _customerCtr.addPointValue.value,
  //                                       action: 'use');
  //                                 });
  //                               },
  //                               child: Text('확인'))
  //                         ],
  //                       ),
  //                     );
  //                   })),
  //             ));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<dynamic> ShowDoneDialog(
      {required BuildContext context,
      required String point,
      required String action}) {
    _customerCtr.addPointValue.value = '';

    openDialog.value = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            if (openDialog.value == true) {
              context.pop();
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
                                  backgroundColor: action == 'charge'
                                      ? Colors.green[100]
                                      : Colors.blue[100],
                                  radius: 30,
                                  child: Icon(
                                    action == 'charge'
                                        ? Icons.wallet_rounded
                                        : Icons.check_rounded,
                                    color: action == 'charge'
                                        ? Colors.green
                                        : sgColor,
                                  )),
                              const Gap(20),
                              Text(
                                '${f.format(int.parse(point))}P',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                action == 'charge' ? '충전 완료' : '사용 완료',
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
                                    context.pop();
                                    openDialog.value = false;
                                  },
                                  bgColor: action == 'charge'
                                      ? Colors.green
                                      : sgColor,
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
                                    context.pop();
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
                                    context.pop();
                                    print(customer.id);
                                    await _customerCtr
                                        .deleteCustomer(customerId: customer.id)
                                        .then((value) {
                                      context.pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          '[삭제 완료] ${_customerCtr.coName.value} ${_customerCtr.coTeamName.value}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                        action: SnackBarAction(
                                          label: '확인',
                                          textColor: Colors.white,
                                          onPressed: () {
                                            context.pop();
                                          }, //버튼 눌렀을때.
                                        ),
                                      ));
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
                      style: coTeamTextNotBold,
                    ),
                  ],
                ),
                Gap(10),
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
        Gap(10),
        Row(
          children: [
            Obx(
              () => Text(
                '${f.format(_customerCtr.balance.value)}P',
                style: const TextStyle(
                    fontSize: 60, fontWeight: FontWeight.bold, height: 1),
              ),
            ),
            const Gap(20),
            SizedBox(
              height: 50,
              child: Visibility(
                visible: !initCustomerMode.value,
                child: ButtonWidget(
                    h: 50,
                    onTap: () {
                      _customerCtr.addPointValue.value = '';

                      ActionDialog();
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

  Future<dynamic> ActionDialog() {
    var title = '사용하기';
    var useText = '얼마를 사용할까요?';
    Color color = sgColor;
    isLoading.value = false;

    final UserController _userCtr = Get.find<UserController>();

    final addPercent = _userCtr.beforeAddRatio;
    _customerCtr.usePotinValue.value = '';

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
            child: Dialog(
                backgroundColor: Colors.white,
                child: Obx(() {
                  var entryPoint = 0.0;
                  if (_customerCtr.usePotinValue.value != '') {
                    entryPoint = double.parse(_customerCtr.usePotinValue.value);
                  }
                  var showAddPoint = _customerCtr.usePotinValue.value == ''
                      ? useText
                      : '+ ${f.format(entryPoint)}P';

                  var afterPoint = _customerCtr.balance.value +
                      entryPoint +
                      (entryPoint * addPercent.value / 100);

                  var addPoint =
                      entryPoint + (entryPoint * addPercent.value / 100);

                  var showAfterPoint = _customerCtr.usePotinValue.value == ''
                      ? ''
                      : '${f.format(afterPoint)}P';

                  return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 700,
                        maxHeight: 550,
                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const Text(
                                        '추가 충전',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
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
                                  child: Obx(
                                    () => NumberPadWidget(
                                      aspectRatio: 1.3,
                                      value: _customerCtr.usePotinValue.value,
                                      onChanged: (newValue) {
                                        _customerCtr.usePotinValue.value =
                                            newValue;
                                        // inputValue.value = newValue;
                                      },
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
                                      context.pop();
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
                                        // context.pop();
                                        if (isLoading.value == false) {
                                          isLoading.value = true;
                                          try {
                                            _signatureController
                                                .SignatureDialog(
                                                    context, customer.id,
                                                    () async {
                                              context.pop();
                                              await _customerCtr
                                                  .chargePoint(
                                                      customerId: customer.id,
                                                      point: addPoint.toInt(),
                                                      signature:
                                                          _signatureController
                                                              .signatureName
                                                              .value)
                                                  .then((value) {
                                                context.pop();
                                                // context.pop();
                                                isLoading.value = false;
                                                _customerCtr.loadCustomerList();
                                                _signatureController
                                                    .clearSignature();
                                                ShowDoneDialog(
                                                    context: context,
                                                    point: _customerCtr
                                                        .usePotinValue.value,
                                                    action: 'charge');
                                              });
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
                                          '충전하기',
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
                      ));
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
  History({
    super.key,
    required this.groupedTransactions,
    required this.customer,
    required this.f,
  });

  final Map<String, List<Map<String, dynamic>>> groupedTransactions;
  final CustomerModel customer;
  final NumberFormat f;
  final UserController _userController = Get.find<UserController>();

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
                        context.goNamed(Routes.record,
                            pathParameters: {'id': customer.id.toString()});
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
                                  onTap: () async {
                                    // var url = await supabase.storage
                                    //     .from('signatures')
                                    //     .createSignedUrl('avatar2.png', 1);
                                    MenuDialog(context, transaction);
                                    // print(url);
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
                                        // Text(
                                        //     transaction['signature'] ?? 'null'),
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
                                        if (transaction['signature'] != '')
                                          Icon(
                                            CupertinoIcons.signature,
                                            color: Colors.grey,
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

  Future<dynamic> showPasswordDialog({
    required BuildContext context,
    required Map<String, dynamic> data,
    required bool isCanceled,
    required Function onConfirm,
  }) {
    var password = ''.obs;
    var isLoading = false.obs;
    int point = data['money'];

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 440,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCloseButton(context),
                  _buildHeader(data, point, isCanceled),
                  const SizedBox(height: 30),
                  PasswordDotsWidget(password: password),
                  const SizedBox(height: 20),
                  Text(
                    isCanceled
                        ? '취소를 되돌리려면 비밀번호를 입력해주세요'
                        : '취소하려면 비밀번호를 입력해주세요',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => NumberPadWidget(
                      value: password.value,
                      hideDoubleZero: true,
                      onChanged: (newValue) => _handlePasswordInput(
                        newValue,
                        password,
                        isLoading,
                        onConfirm,
                        context,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        color: Colors.grey,
        onPressed: () => context.pop(),
        icon: const Icon(Icons.close),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> data, int point, bool isCanceled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('yy년MM월dd일 HH시mm분ss초').format(
            DateTime.parse(data['created_at'].toString()),
          ),
          style: descriptionTitle,
        ),
        Row(
          children: [
            Text(
              '${f.format(point)}P',
              style: menuTitle,
            ),
            if (isCanceled) ...[
              const SizedBox(width: 10),
              const Text(
                '취소됨',
                style: TextStyle(color: Colors.blue, fontSize: 22),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _handlePasswordInput(
    String newValue,
    RxString password,
    RxBool isLoading,
    Function onConfirm,
    BuildContext context,
  ) async {
    print(newValue);
    password.value = newValue;
    if (password.value.length == 4) {
      if (password.value == _userController.user.value!.certificationPassword) {
        if (!isLoading.value) {
          isLoading.value = true;
          await onConfirm();
          isLoading.value = false;
          context.pop();
        }
      } else {
        password.value = '';
      }
    }
  }

  Future<dynamic> MenuDialog(BuildContext context, Map<String, dynamic> data) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BorderContainerWidget(
              w: 300,
              h: 420,
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
                              context.pop();
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                    if (data['signature'] != null)
                      SizedBox(
                        width: 260,
                        height: 200,
                        child: FutureBuilder(
                            future: supabase.storage
                                .from('signatures/${customer.id}')
                                .createSignedUrl(data['signature'], 60),
                            builder: (context, snapshot) {
                              // print(snapshot.data!);
                              // return Text('load');
                              if (snapshot.data != null) {
                                print(snapshot.data);
                                // return Container(
                                //   decoration: BoxDecoration(
                                //       color: Colors.grey[100],
                                //       image: DecorationImage(
                                //           image: NetworkImage(snapshot.data!))),
                                // );
                                return BorderContainerWidget(
                                    color: Colors.grey[100],
                                    w: 200,
                                    h: 200,
                                    child: Image.network(
                                      snapshot.data!,
                                      width: 200,
                                      height: 200,
                                    ));
                              }
                              if (data['signature'] == null ||
                                  data['signature'] == '')
                                return BorderContainerWidget(
                                    color: Colors.grey[100],
                                    w: 200,
                                    h: 200,
                                    child: Center(child: Text('서명없음')));

                              return BorderContainerWidget(
                                  color: Colors.grey[100],
                                  w: 100,
                                  h: 100,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }),
                      ),

                    Gap(20),
                    // Text('${data['canceled'].toString()}'),
                    StateChangeButtonWidget(
                      onTap: () async {
                        context.pop();
                        var transactionId = data['id'];
                        var amount = data['money'];
                        var customerId = customer.id;
                        if (data['canceled'] == false) {
                          print('cancled value = ${data['canceled']}');
                          showPasswordDialog(
                            context: context,
                            data: data,
                            isCanceled: false,
                            onConfirm: () =>
                                _customerCtr.toggleTransactionStatus(
                              id: transactionId,
                              point: amount,
                              customerId: customerId,

                              currentCanceledStatus: false, // 현재 취소되지 않은 상태
                            ),
                          );
                        } else {
                          showPasswordDialog(
                              context: context,
                              data: data,
                              isCanceled: true,
                              onConfirm: () =>
                                  _customerCtr.toggleTransactionStatus(
                                    id: transactionId,
                                    point: amount,
                                    customerId: customerId,

                                    currentCanceledStatus: true, // 현재 취소된 상태
                                  ));
                          // AskDeleteUsed(context, data['money'], data['id'],
                          //     data['type'] == 'add', data);
                        }
                      },
                      title: '이 결제 취소하기',
                      icon: Icons.block,
                      iconColor: Colors.red,
                      color: Colors.yellow[100],
                    ),
                    Divider(),
                    StateChangeButtonWidget(
                      onTap: () async {
                        context.pop();
                        var beforeMemo = data['memo'] ?? '';
                        MemoDialog(context, data['id'], beforeMemo);
                      },
                      title: '메모',
                      icon: Icons.note_add_outlined,
                      iconColor: Colors.green,
                      color: Colors.green[100],
                    ),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                maxHeight: 180,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            color: Colors.grey,
                            onPressed: () {
                              context.pop();
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
                    Row(
                      children: [
                        Expanded(
                          child: BorderContainerWidget(
                            h: 45,
                            color: Colors.grey[200],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                maxLines: 1,
                                controller: memoCtr,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) async {
                                  await _customerCtr.addMemo(
                                      id: id,
                                      customerId: customer.id,
                                      memo: memoCtr.text);
                                  context.pop();
                                },
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        ButtonWidget(
                            w: 60,
                            h: 45,
                            onTap: () async {
                              await _customerCtr.addMemo(
                                  id: id,
                                  customerId: customer.id,
                                  memo: memoCtr.text);
                              context.pop();
                            },
                            bgColor: Colors.blue,
                            child: const Text(
                              '저장',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
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
