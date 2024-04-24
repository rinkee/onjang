import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/navigation_controller.dart';

class KMenuChildBtn extends StatefulWidget {
  KMenuChildBtn({
    super.key,
    this.bgColor,
    required this.menuType,
  });

  final CustomerChildMenuType menuType;
  Color? bgColor;

  @override
  State<KMenuChildBtn> createState() => _KMenuChildBtnState();
}

class _KMenuChildBtnState extends State<KMenuChildBtn> {
  Color? contentColor = Colors.grey;

  Color? defaultBgColor = Colors.white;

  final navCtr = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    // if (widget.select == true) {
    //   contentColor = sgColor;
    //   defaultBgColor = Colors.green;
    // }
    return Obx(() => MouseRegion(
          onHover: (_) {
            setState(() {
              contentColor = Colors.white;
            });
          },
          onExit: (_) {
            setState(() {
              contentColor = Colors.grey[400];
            });
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                navCtr.customerChildMenu.value = widget.menuType;
              },
              hoverColor: sgColor,
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: navCtr.customerChildMenu.value == widget.menuType
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Icon(widget.menuType.icon,
                            color: navCtr.customerChildMenu.value ==
                                    widget.menuType
                                ? sgColor
                                : contentColor),
                        const Gap(10),
                        Text(
                          widget.menuType.title,
                          style: TextStyle(
                              color: navCtr.customerChildMenu.value ==
                                      widget.menuType
                                  ? sgColor
                                  : contentColor),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
