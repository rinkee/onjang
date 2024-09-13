import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/user_controller.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/controller/navigation_controller.dart';
import 'package:jangboo_flutter/app/controller/home_menu_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/web/customer/customer_desktop.dart';

import 'package:jangboo_flutter/app/ui/web/home/home_screen_desktop.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/supabase.dart';

class CustomerCardWidget extends StatelessWidget {
  CustomerCardWidget({
    super.key,
    required this.customer,
    this.inDeletedScreen,
  });
  final CustomerModel customer;
  final isLoading = false.obs;
  bool? inDeletedScreen;

  final menuCtr = Get.put(HomeMenuController());
  final _customerCtr = Get.find<CustomerContentController>();

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      hoverColor: Colors.grey[300],
      bgColor: Colors.white,
      onTap: () {
        if (inDeletedScreen == true) {
          askDialog(context, customer);
        } else {
          _customerCtr.customerSearchCtr.clear();
          _customerCtr.customerSearchCtr.text = '';
          FocusManager.instance.primaryFocus?.unfocus();

          // customerCtr.currentCustomerIndex = index;
          _customerCtr.fucSetUpActionButton(balance: customer.balance);
          _customerCtr.filteredItems.clear();
          _customerCtr.showSearchScreen.value = false;
          _customerCtr.resetPage();
          Get.to(CustomerDesktop(
            customer: customer,
          ));
        }
      },
      child: Stack(
        children: [
          if (customer.state == 'delete')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.red[100],
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red[300],
                  ),
                ),
              ),
            ),
          if (customer.state == 'inactive')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.yellow[100],
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.red[300],
                  ),
                ),
              ),
            ),
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
                            await _customerCtr.setActiveCustomer(
                                customerId: id);
                            Get.back();
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
                              await _customerCtr.setInactiveCustomer(
                                  customerId: id);
                              Get.back();
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
                              await _customerCtr.setDeleteCustomer(
                                  customerId: id);
                              Get.back();
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
                            Get.back();
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
}

class StateChangeButtonWidget extends StatelessWidget {
  const StateChangeButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.color,
    this.iconColor,
  });

  final GestureTapCallback onTap;
  final String title;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              child: Icon(
                icon,
                color: iconColor,
              ),
              backgroundColor: color,
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
