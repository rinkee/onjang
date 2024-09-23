import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class CustomerAddInputWidget extends StatelessWidget {
  CustomerAddInputWidget(
      {super.key,
      required this.title,
      required this.value,
      this.inputType,
      required this.onChanged});

  String title;
  String value;
  TextInputType? inputType;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Gap(3),
        Container(
          width: 200,
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'[\s-]')), // 공백과 하이픈을 모두 거부합니다
                ],
                decoration: InputDecoration(border: InputBorder.none),
                keyboardType: inputType ?? TextInputType.text,
                onChanged: onChanged),
          ),
        ),
      ],
    );
  }
}
