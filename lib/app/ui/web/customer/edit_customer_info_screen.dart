import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/input_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/app/ui/theme/app_text_theme.dart';
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
  final teamNameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final cardCtr = TextEditingController();
  final barcodeCtr = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtr.text = customerCtr.coName.value;
    teamNameCtr.text = customerCtr.coTeamName.value;
    phoneCtr.text = customerCtr.coPhone.value;
    cardCtr.text = customerCtr.coCard.value;
    barcodeCtr.text = customerCtr.coBarcode.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '고객 정보 수정',
        style: TextStyle(color: Colors.white),
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '고객정보',
                style: menuTitle,
              ),
              Text('고객정보를 입력하는 칸입니다 전화번호를 입력하면 잔액알림을 보낼 수 있습니다 (추후지원예정)'),
              Gap(15),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: InputWidget(
                      ctr: nameCtr,
                      title: '회사명',
                    ),
                  ),
                  Gap(15),
                  SizedBox(
                    width: 200,
                    child: InputWidget(
                      ctr: teamNameCtr,
                      title: '부서 혹은 이름명 (필수값)',
                    ),
                  ),
                  Gap(15),
                  SizedBox(
                    width: 200,
                    child: InputWidget(
                      ctr: phoneCtr,
                      title: '전화번호',
                    ),
                  ),
                ],
              ),
              Gap(30),
              Text(
                '추가 검색 정보(선택)',
                style: menuTitle,
              ),
              Text('카드의 번호나 바코드를 등록하여 검색할 수 있습니다'),
              Gap(15),
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      ctr: cardCtr,
                      title: '등록된 카드 번호',
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: InputWidget(
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
                  child: ButtonWidget(
                      bgColor: sgColor,
                      onTap: () async {
                        if (teamNameCtr.text != '' &&
                            teamNameCtr.text.isNotEmpty) {
                          await customerCtr.fucEditCutomerInfo(
                              customerId: widget.customerId,
                              co_team_name: teamNameCtr.text,
                              co_name: nameCtr.text,
                              co_phone: phoneCtr.text,
                              co_barcode: barcodeCtr.text,
                              co_card: cardCtr.text);
                          customerCtr.coName.value = nameCtr.text;
                          customerCtr.coTeamName.value = teamNameCtr.text;
                          customerCtr.coPhone.value = phoneCtr.text;
                          customerCtr.coBarcode.value = barcodeCtr.text;
                          customerCtr.coCard.value = cardCtr.text;
                          Get.back();
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: BorderContainerWidget(
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
                                              ButtonWidget(
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
