import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/dont_write.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/explain_mojang.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/know_service.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/image_title_widget.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/introduce_scaffold.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/plan_widget.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/table_text.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/what_is_good_things.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';

class MobileIntroduceScreen extends StatelessWidget {
  const MobileIntroduceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntroduceScaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageTitleWidget(),
                Gap(150),
                ExplainMojangWidget(),
                DontWrite(),
                Gap(150),
                WhatIsGoodThings(
                  mainTitleSize: 24,
                  titleSize: 20,
                  descriptionSize: 16,
                ),
                Gap(150),
                IWannaKnowServiceWidget(),
                Gap(150),
                PlanWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
