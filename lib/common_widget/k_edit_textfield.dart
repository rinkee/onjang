import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';

class EditTextField extends StatefulWidget {
  const EditTextField({
    super.key,
    required this.ctr,
    required this.title,
    this.hintText,
    this.bgColor,
    this.onTap,
    this.onChanged,
    this.isPassword = false,
    this.textInputType,
    // required this.value,
  });

  final TextEditingController ctr;
  final String title;
  final String? hintText;
  final Color? bgColor;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final TextInputType? textInputType;

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  // final String value;
  var showPassword = true.obs;

  @override
  void initState() {
    super.initState();
    if (widget.isPassword == false) {
      showPassword.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Gap(5),
        BorderContainer(
          color: widget.bgColor ?? Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: widget.textInputType,
                        controller: widget.ctr,
                        onTap: widget.onTap,
                        obscureText: showPassword.value,
                        onChanged: widget.onChanged,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.hintText),
                      ),
                    ),
                    widget.isPassword == true
                        ? IconButton(
                            onPressed: () {
                              if (showPassword.value == true) {
                                showPassword.value = false;
                              } else {
                                showPassword.value = true;
                              }
                            },
                            icon: Icon(showPassword.value
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded))
                        : const SizedBox()
                  ],
                )),
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
