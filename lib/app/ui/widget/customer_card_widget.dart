import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/introduce_screen.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';

import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/ui/widget/state_change_button_widget.dart';

class CustomerCardWidget extends StatelessWidget {
  CustomerCardWidget({
    super.key,
    required this.customer,
    this.inDeletedScreen,
  });
  final CustomerModel customer;
  final isLoading = false.obs;
  bool? inDeletedScreen;
  final _customerCtr = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      hoverColor: Colors.grey[300],
      bgColor: Colors.white,
      onTap: () {
        if (inDeletedScreen == true) {
          askDialog(context, customer);
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          context.goNamed('customer');
          _customerCtr.customerSearchCtr.clear();
          _customerCtr.customerSearchCtr.text = '';
          _customerCtr.filteredItems.clear();
          _customerCtr.showSearchScreen.value = false;
          print(customer.name);
          _customerCtr.setSelectedCustomer(customer);
          print('선택 ${_customerCtr.selectedCustomer.value!.name}');
        }
      },
      child: Stack(
        children: [
          if (customer.state == 'delete' || customer.state == 'inactive')
            _buildStateIcon(customer.state),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      customer.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: coNameText,
                      textAlign: TextAlign.center,
                    ),
                    // Spacer(),
                    // Icon(
                    //   Icons.star_rounded,
                    //   color: Colors.amber,
                    // )
                  ],
                ),
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: coTeamText,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                // Text('aa'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // customer.balance > 0
                    //     ? Icon(
                    //         Icons.add,
                    //         color: Colors.grey,
                    //       )
                    //     : Icon(
                    //         Icons.remove,
                    //         color: Colors.grey,
                    //       ),
                    // Icon(Icons.add)
                    Text(
                      f.format(customer.balance),
                      style: cardBalance,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> askDialog(BuildContext context, CustomerModel customer) {
    var id = customer.id;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BorderContainerWidget(
                  w: 350,
                  h: 320,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        StateChangeButtonWidget(
                          onTap: () async {
                            await _customerCtr.setActive(customerId: id);
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                '장부 활성화 완료',
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
                          },
                          title: '다시 사용하기',
                          icon: Icons.replay,
                          iconColor: Colors.green,
                          color: Colors.green[100],
                        ),
                        Divider(),
                        StateChangeButtonWidget(
                          onTap: () async {
                            if (customer.state != 'inactive') {
                              await _customerCtr.setInactive(customerId: id);
                              context.pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '장부 비활성화 완료',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.amber,
                                action: SnackBarAction(
                                  label: '확인',
                                  textColor: Colors.black,
                                  onPressed: () {
                                    context.pop();
                                  }, //버튼 눌렀을때.
                                ),
                              ));
                            }
                          },
                          title: '비활성화',
                          icon: Icons.block,
                          iconColor: Colors.red[300],
                          color: Colors.yellow[100],
                        ),
                        Divider(),
                        StateChangeButtonWidget(
                          onTap: () async {
                            if (customer.state != 'delete') {
                              await _customerCtr.deleteCustomer(customerId: id);
                              context.pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '장부 삭제 완료 (30일 뒤 삭제됩니다)',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                                action: SnackBarAction(
                                  label: '확인',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    context.pop();
                                  }, //버튼 눌렀을때.
                                ),
                              ));
                            }
                          },
                          title: '삭제하기',
                          icon: Icons.delete,
                          iconColor: Colors.red[300],
                          color: Colors.red[100],
                        ),
                        Divider(),
                        StateChangeButtonWidget(
                          onTap: () {
                            context.pop();
                          },
                          title: '취소',
                          icon: Icons.close,
                          iconColor: Colors.grey,
                          color: Colors.grey[100],
                        ),
                      ],
                    ),
                  )));
        });
  }

  Future<dynamic> AskDeleteLedger(
      BuildContext context, CustomerModel customer) {
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

                                    await _customerCtr
                                        .deleteCustomer(customerId: customer.id)
                                        .then((value) {
                                      context.pop();
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

  Widget _buildStateIcon(String state) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (state) {
      case 'delete':
        icon = Icons.delete;
        backgroundColor = Colors.red[100]!;
        iconColor = Colors.red[300]!;
        break;
      case 'inactive':
        icon = Icons.block;
        backgroundColor = Colors.yellow[100]!;
        iconColor = Colors.red[300]!;
        break;
      default:
        return SizedBox.shrink(); // 해당 상태가 아닐 경우 빈 위젯 반환
    }

    return Positioned(
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
