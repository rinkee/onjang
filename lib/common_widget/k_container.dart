import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/const/const.dart';

class BorderContainer extends StatelessWidget {
  BorderContainer(
      {super.key,
      required this.child,
      this.color,
      this.h,
      this.w,
      this.radius});

  final Widget child;
  Color? color;
  double? w;
  double? h;
  double? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: w ?? Get.width,
        height: h ?? defaultContainerH,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 20)),
            color: color ?? Colors.white),
        child: child);
  }
}
