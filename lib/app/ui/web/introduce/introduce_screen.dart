import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/controller/demo_controller.dart';
import 'package:jangboo_flutter/app/data/routes/app_pages.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/responsive/mobile_intro_screen.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/responsive/pc_intro_screen.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/responsive/tablet_intro_screen.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/what_is_good_things.dart';
import 'package:jangboo_flutter/app/ui/widget/button_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';
import 'package:jangboo_flutter/app/ui/web/demo/demo_home.dart';
import 'package:jangboo_flutter/app/ui/web/login/login_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  TextStyle shortTitleStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: sgColor);

  TextStyle whiteShortTitleStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return TabletIntroduceScreen();
        }
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return MobileIntroduceScreen();
        }

        return PcIntroduceScreen();
      },
    );
  }
}
