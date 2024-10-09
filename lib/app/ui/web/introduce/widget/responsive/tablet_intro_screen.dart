import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/explain_mojang.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/know_service.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/image_title_widget.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/introduce_scaffold.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/plan_widget.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/table_text.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/what_is_good_things.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';

class TabletIntroduceScreen extends StatelessWidget {
  const TabletIntroduceScreen({
    super.key,
  });

  final double titleTextSize = 32.0;
  final double introTitleTextSize = 28.0;
  final double introDescriptionTextSize = 22.0;
  final double goodTingsTitleSize = 22.0;
  final double goodTingsDescriptionSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return IntroduceScaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageTitleWidget(),
                Gap(150),
                ExplainMojangWidget(),
                Gap(150),
                WhatIsGoodThings(
                  mainTitleSize: introTitleTextSize,
                  titleSize: goodTingsTitleSize,
                  descriptionSize: goodTingsDescriptionSize,
                ),
                Gap(150),
                IWannaKnowServiceWidget(),
                Gap(150),
                PlanWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
