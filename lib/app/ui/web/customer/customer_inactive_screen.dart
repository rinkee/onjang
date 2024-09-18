import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';
import 'package:jangboo_flutter/app/data/model/customer_model.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/customer_card_widget.dart';

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
                        );
                      },
                    ),
                  ))
            ],
          ),
        ));
  }
}
