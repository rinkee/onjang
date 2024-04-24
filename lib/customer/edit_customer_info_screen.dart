import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/common_widget/k_edit_textfield.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditCustomerInfoScreen extends StatefulWidget {
  const EditCustomerInfoScreen({super.key, required this.customerId});

  @override
  State<EditCustomerInfoScreen> createState() => _EditCustomerInfoScreenState();
  final int customerId;
}

class _EditCustomerInfoScreenState extends State<EditCustomerInfoScreen> {
  final customerCtr = Get.put(CustomerContentController());

  final nameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final cardCtr = TextEditingController();
  final barcodeCtr = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtr.text = customerCtr.coName.value;
    phoneCtr.text = customerCtr.coPhone.value;
    cardCtr.text = customerCtr.coCard.value;
    barcodeCtr.text = customerCtr.coBarcode.value;
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: maxWidth,
      child: Scaffold(
        appBar: AppBar(title: const Text('고객 정보 수정')),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width / 2 - 20,
                child: EditTextField(
                  ctr: nameCtr,
                  title: '이름',
                ),
              ),
              SizedBox(
                width: Get.width / 2 - 20,
                child: EditTextField(
                  ctr: phoneCtr,
                  title: '전화번호',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: EditTextField(
                      ctr: cardCtr,
                      title: '등록된 카드 번호',
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: EditTextField(
                      ctr: barcodeCtr,
                      title: '등록된 바코드 번호',
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Center(
                child: SizedBox(
                  width: 300,
                  child: kBtn(
                      bgColor: sgColor,
                      onTap: () async {
                        if (nameCtr.text != '' && nameCtr.text.isNotEmpty) {
                          await customerCtr.fucEditCutomerInfo(
                              customerId: widget.customerId,
                              co_name: nameCtr.text,
                              co_phone: phoneCtr.text,
                              co_barcode: barcodeCtr.text,
                              co_card: cardCtr.text);
                          customerCtr.coName.value = nameCtr.text;
                          customerCtr.coPhone.value = phoneCtr.text;
                          customerCtr.coBarcode.value = barcodeCtr.text;
                          customerCtr.coCard.value = cardCtr.text;
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: BorderContainer(
                                        w: 250,
                                        h: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              const Text(
                                                '이름은 필수 작성입니다',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const Gap(15),
                                              kBtn(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: const Center(
                                                    child: Text('확인'),
                                                  ))
                                            ],
                                          ),
                                        )));
                              });
                        }

                        // Get.to(() => const EditCustomerInfoScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: Text(
                          '수정하기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
