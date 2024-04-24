import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';

class KSearchBar extends StatelessWidget {
  KSearchBar({super.key, required this.textCtr});
  final customerCtr = Get.put(CustomerContentController());
  final TextEditingController textCtr;
  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        h: defaultContainerH,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: Colors.grey,
              ),
              const Gap(5),
              Expanded(
                  child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: '이름, 번호, 바코드로 검색'),
                controller: textCtr,
                onChanged: (_) {
                  customerCtr.fucSearchCustomer(textCtr);
                },
              )),
              IconButton(
                  onPressed: () {
                    textCtr.clear();
                  },
                  color: Colors.grey,
                  icon: const Icon(Icons.close_rounded))
            ],
          ),
        ));
  }
}
