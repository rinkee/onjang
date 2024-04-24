import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/common_widget/k_edit_textfield.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/model/customer_model.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateNewCustomerScreen extends StatelessWidget {
  CreateNewCustomerScreen({super.key});

  final supabase = Supabase.instance.client;
  final nameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final cardCtr = TextEditingController();
  final barcodeCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: maxWidth,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('새로운 고객 등록'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width / 2 - 20,
                child: EditTextField(
                  ctr: nameCtr,
                  title: '이름(필수)',
                  hintText: '업체명 혹은 이름을 입력해주세요',
                ),
              ),
              SizedBox(
                width: Get.width / 2 - 20,
                child: EditTextField(
                  ctr: phoneCtr,
                  title: '전화번호(선택)',
                  hintText: '전화번호를 입력해주세요',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: EditTextField(
                      ctr: cardCtr,
                      title: '카드번호(선택)',
                      hintText: '카드번호를 입력해주세요',
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: EditTextField(
                      ctr: barcodeCtr,
                      title: '바코드 번호(선택)',
                      hintText: '바코드를 입력해주세요',
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
                        if (nameCtr.text != '') {
                          final customerCtr =
                              Get.put(CustomerContentController());
                          customerCtr
                              .fucAddCustomer(
                            co_name: nameCtr.text,
                            co_phone: phoneCtr.text,
                          )
                              .then((value) async {
                            // await customerCtr.fucSetCustomerList();
                            Get.back();
                            // await supabase.from('customer').insert({
                            //   'name': name,
                            //   'phone': phone,
                            //   'barcode': barcode,
                            //   'user_id': 'testUserId'
                            // }).select('*');
                          });
                        }
                        if (nameCtr.text == '') {
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
                                              const Spacer(),
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
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: Text(
                          '등록하기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  InputBox({
    super.key,
    this.hintText,
    required this.ctr,
  });

  String? hintText;
  TextEditingController ctr;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[100],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: ctr,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
          onChanged: (_) {
            print(ctr.text);
          },
        ),
      ),
    );
  }
}
