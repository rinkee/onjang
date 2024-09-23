import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/number_pad_widget.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DemoCustomerScreen extends StatefulWidget {
  DemoCustomerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DemoCustomerScreenState createState() => _DemoCustomerScreenState();
}

class _DemoCustomerScreenState extends State<DemoCustomerScreen> {
  final DemoController _demoCtr = Get.find<DemoController>();
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객 상세'),
        leading: BackButton(
          onPressed: () {
            context.pop();
            // _demoController.updateCustomer(widget.customer);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 기능 구현
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  NameAndActionButton(),
                  Divider(),
                  History(
                    logs: _demoCtr.selectedCustomer.value!.log!,
                    f: NumberFormat('#,###'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(36),
                    Text(
                      '사용할 포인트를 입력하세요',
                      style: TextStyle(fontSize: 20),
                    ),
                    Obx(() => Text(
                          _demoCtr.addPointValue.value == ''
                              ? '0P'
                              : '${NumberFormat('#,###').format(int.parse(_demoCtr.addPointValue.value))}P',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                    Gap(10),
                    Divider(),
                    const Gap(20),
                    Obx(
                      () => Center(
                        child: MaxWidthBox(
                          maxWidth: 450,
                          child: NumberPadWidget(
                            value: _demoCtr.addPointValue.value,
                            aspectRatio: 1.6,
                            numberStyle: TextStyle(fontSize: 26),
                            onChanged: (newValue) {
                              _demoCtr.addPointValue.value = newValue;
                            },
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                      onTap: () async {
                        var point = int.parse(_demoCtr.addPointValue.value);
                        if (!isLoading.value &&
                            _demoCtr.addPointValue.value != '' &&
                            point != 0) {
                          isLoading.value = true;
                          await Future.delayed(Duration(seconds: 1)); // 데모용 딜레이
                          _demoCtr.usePoint(point);
                          isLoading.value = false;
                          _demoCtr.addPointValue.value = '';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$point 포인트가 사용되었습니다.')),
                          );
                        }
                      },
                      bgColor: sgColor,
                      child: Center(
                        child: Obx(() => isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('사용하기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget NameAndActionButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_demoCtr.selectedCustomer.value!.companyName, style: coNameText),
        Text(_demoCtr.selectedCustomer.value!.name, style: coTeamText),
        Gap(10),
        Row(
          children: [
            Obx(() => Text(
                  '${NumberFormat('#,###').format(_demoCtr.balance.value ?? 0)}P',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                )),
            const Gap(20),
            SizedBox(
              height: 50,
              child: ButtonWidget(
                onTap: () => _showChargeDialog(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.wallet_rounded, color: Colors.green),
                      SizedBox(width: 6),
                      Text('충전하기'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(10),
      ],
    );
  }

  void _showChargeDialog() {
    final addPercent = 5.obs;
    var useText = '충전 금액을 입력해주세요.';
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Dialog(
            backgroundColor: Colors.white,
            child: Obx(() {
              var entryPoint = 0.0;
              if (_demoCtr.usePotinValue.value != '') {
                entryPoint = double.parse(_demoCtr.usePotinValue.value);
              }
              var showAddPoint = _demoCtr.usePotinValue.value == ''
                  ? useText
                  : '+ ${f.format(entryPoint)}P';

              var afterPoint = _demoCtr.balance.value +
                  entryPoint +
                  (entryPoint * addPercent.value / 100);

              var addPoint = entryPoint + (entryPoint * addPercent.value / 100);

              var showAfterPoint = _demoCtr.usePotinValue.value == ''
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(20),
                                Text(
                                  '잔액 ${f.format(_demoCtr.balance.value)}P',
                                  style: TextStyle(
                                      fontSize: 18,
                                      height: 1.2,
                                      color: Colors.grey[700]),
                                ),
                                Text(
                                  showAddPoint,
                                  style: TextStyle(
                                      fontSize:
                                          _demoCtr.usePotinValue.value == ''
                                              ? 22
                                              : 30,
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
                                          style:
                                              const TextStyle(color: sgColor),
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
                                value: _demoCtr.usePotinValue.value,
                                onChanged: (newValue) {
                                  _demoCtr.usePotinValue.value = newValue;
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
                                  var point =
                                      int.parse(_demoCtr.usePotinValue.value);
                                  if (isLoading.value == false &&
                                      _demoCtr.usePotinValue.value != '' &&
                                      point != 0) {
                                    try {
                                      isLoading.value = true;
                                      await Future.delayed(
                                          Duration(seconds: 1)); // 데모용 딜레이
                                      _demoCtr.chargePoint(point);
                                      _demoCtr.usePointValue.value = '';
                                      isLoading.value = false;
                                      context.pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('$point 충전되었습니다')),
                                      );

                                      // await _customerCtr
                                      //     .chargePoint(
                                      //         customerId: customer.id,
                                      //         point: addPoint.toInt())
                                      //     .then((value) {
                                      //   context.pop();

                                      //   isLoading.value = false;
                                      //   _customerCtr.loadCustomerList();
                                      //   ShowDoneDialog(
                                      //       context: context,
                                      //       point: _customerCtr
                                      //           .usePotinValue.value,
                                      //       action: 'charge');
                                      // });
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
                ),
              );
            })),
      ),
    );
  }
}

class History extends StatelessWidget {
  final List logs;
  final NumberFormat f;

  History({
    required this.logs,
    required this.f,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('사용 기록', style: TextStyle(fontSize: 14, color: Colors.grey)),
          Obx(() {
            if (logs.length == 0) {
              return const Expanded(
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
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: logs.length ?? 0,
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: logs![index], f: f);
                },
              ),
            );
          })
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final NumberFormat f;

  TransactionItem({required this.transaction, required this.f});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: transaction['type'] == 'charge'
                    ? Colors.green[100]
                    : Colors.grey[100],
                child: Icon(
                  transaction['type'] == 'charge'
                      ? Icons.add_rounded
                      : Icons.remove,
                  size: 18,
                  color: transaction['type'] == 'charge'
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              SizedBox(width: 14),
              Text(
                '${f.format(transaction['amount'])}P',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Spacer(),
              if (transaction['memo'] != null) ...[
                Icon(Icons.sticky_note_2_outlined, color: Colors.grey),
                SizedBox(width: 5),
                Text(transaction['memo']),
                SizedBox(width: 10),
              ],
              Text(
                DateFormat('HH:mm').format(DateTime.parse(transaction['date'])),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey[100]),
      ],
    );
  }
}
