import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/controller/customer_content_controller.dart';
import 'package:jangboo_flutter/controller/navigation_controller.dart';

class KMenuIconBtn extends StatefulWidget {
  KMenuIconBtn(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon,
      required this.menuType,
      this.bgColor,
      this.select = false});
  final GestureTapCallback onTap;
  final String title;
  final IconData icon;
  final MenuType menuType;
  Color? bgColor;
  bool? select;

  @override
  State<KMenuIconBtn> createState() => _KMenuIconBtnState();
}

class _KMenuIconBtnState extends State<KMenuIconBtn> {
  Color? contentColor = Colors.grey;

  final navCtr = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    if (widget.select == true) {
      contentColor = sgColor;
    }
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
              onTap: widget.onTap,
              hoverColor: sgColor,
              child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: navCtr.currentMenu.value == widget.menuType
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(widget.menuType.icon,
                            color: navCtr.currentMenu.value == widget.menuType
                                ? sgColor
                                : contentColor),
                        const Gap(10),
                        Text(
                          widget.menuType.title,
                          style: TextStyle(
                              color: navCtr.currentMenu.value == widget.menuType
                                  ? sgColor
                                  : contentColor),
                        ),
                        const Spacer(),
                        widget.select == true
                            ? const Icon(Icons.arrow_drop_down_rounded)
                            : const SizedBox()
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
