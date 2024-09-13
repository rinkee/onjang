import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/app/ui/theme/app_sizes.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';
import 'package:jangboo_flutter/app/ui/theme/app_colors.dart';

class IconButtonWidget extends StatelessWidget {
  IconButtonWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon,
      this.bgColor,
      this.select = false});
  final GestureTapCallback onTap;
  final String title;
  final IconData icon;
  Color? bgColor;
  bool? select;
  Color? color = Colors.grey;
  Color? defaultBgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    if (select == true) {
      color = Colors.white;
      defaultBgColor = Colors.green;
    }
    return Container(
      width: 200,
      height: defaultContainerH,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        hoverColor: sgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: Row(children: [
          const Gap(20),
          Icon(
            icon,
            color: color,
          ),
          const Gap(10),
          Expanded(
              child: Text(
            title,
            style: TextStyle(
              color: color,
            ),
          )),
        ]),
      ),
    );
  }
}
