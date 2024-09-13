import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';

class DeletedCustomerScreen extends StatelessWidget {
  DeletedCustomerScreen({super.key});
  final _customerCtr = Get.find<CustomerContentController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '삭제된 장부',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Obx(() => Expanded(
                    child: GridView.builder(
                      itemCount: _customerCtr.deletedCustomers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 140),
                      itemBuilder: (context, index) {
                        CustomerModel customer =
                            _customerCtr.deletedCustomers[index];
                        return CustomerCardWidget(
                          customer: customer,
                          inDeletedScreen: true,
                        );
                      },
                    ),
                  ))
            ],
          ),
        ));
  }
}
