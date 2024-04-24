import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/customer/create_new_customer_screen.dart';

class KNewBalanceAddBtn extends StatelessWidget {
  const KNewBalanceAddBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kBtn(
      onTap: () {
        Get.to(CreateNewCustomerScreen());
      },
      bgColor: sgColor,
      child: const SizedBox(
          width: 140,
          child: Center(
              child: Text(
            '새로운 장부 등록',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ))),
    );
  }
}
