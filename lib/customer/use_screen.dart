import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/number_pad/number_pad.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';

import '../common_widget/k_container.dart';

class UseScreen extends StatelessWidget {
  UseScreen({super.key});

  final customerCtr = Get.put(CustomerContentController());
  final TextEditingController numberPadCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          BorderContainer(
            color: Colors.white,
            h: 550,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '사용하기',
                        style: menuTitle,
                      ),
                      kBtn(
                          onTap: () {
                            Get.back();
                          },
                          child: const AspectRatio(
                              aspectRatio: 1,
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.grey,
                              ))),
                    ],
                  ),
                  BorderContainer(
                      w: 40,
                      h: 5,
                      color: Colors.green,
                      child: const SizedBox()),
                  const Gap(20),
                  Text(
                    '잔액 ${f.format(customerCtr.balance.value)}원에서',
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),
                  // RichText(
                  //     text: TextSpan(
                  //         text: '잔액 ${f.format(customerCtr.balance.value)}',
                  //         style: TextStyle(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.grey[800]),
                  //         children: const [
                  //       TextSpan(
                  //         text: '원에서',
                  //         style: TextStyle(
                  //             fontSize: 18, fontWeight: FontWeight.normal),
                  //       )
                  //     ])),

                  Obx(() {
                    var showNumber = 0;
                    if (customerCtr.enterUsePrice.value != '') {
                      // textColor =
                      //     const Color.fromRGBO(
                      //         0, 0, 0, 1);
                      showNumber = int.parse(customerCtr.enterUsePrice.value);
                    }
                    var showPriceSideCard =
                        customerCtr.enterUsePrice.value == ''
                            ? '얼마'
                            : '${f.format(showNumber)}원';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        showPriceSideCard,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: NumberPad(
                        textCtr: numberPadCtr,
                      ),
                    ),
                  ),
                  const Gap(10),
                  kBtn(
                      onTap: () async {
                        // if (isLoading.value == false) {
                        //   isLoading.value = true;

                        //   await customerCtr
                        //       .fucAddOrUse(customerId: 0)
                        //       .then((value) {
                        //     Get.back();
                        //     // setState(() {
                        //     //   numberPadCtr.clear();
                        //     //   customerCtr.enterPrice.value = '';
                        //     //   isLoading.value = false;
                        //     // });
                        //   });
                        // } else {}
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: Text(
                          '사용하기',
                          style: TextStyle(),
                        )),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
