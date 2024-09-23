import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/state_change_button_widget.dart';

class CustomerInactiveScreen extends StatelessWidget {
  CustomerInactiveScreen({super.key});
  final _customerCtr = Get.find<CustomerController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '비활성화 장부',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '비활성화 장부',
                style: menuTitle,
              ),
              Text(
                '장부를 클릭하여 장부의 상태를 변경 할 수 있습니다',
                style: descriptionTitle,
              ),
              Gap(20),
              Obx(() => Expanded(
                    child: GridView.builder(
                      itemCount: _customerCtr.deletedCustomers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 140),
                      itemBuilder: (context, index) {
                        CustomerModel customer =
                            _customerCtr.deletedCustomers[index];
                        return CustomerCardWidget(
                            customer: customer,
                            inDeletedScreen: true,
                            onTap: () {
                              askDialog(context, customer);
                            });
                      },
                    ),
                  ))
            ],
          ),
        ));
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
}
