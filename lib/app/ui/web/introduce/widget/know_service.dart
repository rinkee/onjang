import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';

class IWannaKnowServiceWidget extends StatelessWidget {
  const IWannaKnowServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingColumn(
      children: [
        Text(
          '👀',
          style: TextStyle(fontSize: 30),
        ),
        const Text(
          '어떤 서비스인지 궁금해요',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Gap(5),
        Text(
          '체험하기를 클릭해 직접 확인해보세요',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        // Text(
        //   '(서비스는 태블릿,PC에 최적화 되어있습니다)',
        //   style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        // ),
        Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonWidget(
                w: context.mediaQuerySize.width / 2,
                h: 55,
                bgColor: Colors.blue,
                hoverColor: Colors.blue[600],
                onTap: () {
                  // Get.toNamed(Routes.demoHome);
                  final _demoCtr = Get.put(DemoController());
                  _demoCtr.updateCompanyList();
                  context.goNamed(Routes.demohome);
                },
                child: const Text(
                  '체험 해보기',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          ],
        ),
        Gap(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '(서비스는 태블릿,PC에 최적화 되어있습니다)',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }
}
