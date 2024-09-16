import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/theme/app_sizes.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/customer_controller.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  final _customerCtr = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return BorderContainerWidget(
        h: 50,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Gap(5),
              Icon(
                Icons.search_rounded,
                color: Colors.grey[600],
              ),
              Gap(5),
              Expanded(
                  child: TextField(
                // textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    border: InputBorder.none,
                    hintText: '이름, 번호, 바코드로 검색'),
                controller: _customerCtr.customerSearchCtr,
                onChanged: (_) =>
                    _customerCtr.search(_customerCtr.customerSearchCtr),
              )),
              IconButton(
                  onPressed: () {
                    _customerCtr.customerSearchCtr.clear();
                  },
                  color: Colors.grey,
                  icon: const Icon(Icons.close_rounded))
            ],
          ),
        ));
  }
}
