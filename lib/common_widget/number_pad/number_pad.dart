import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/common_widget/Button/k_btn.dart';
import 'package:jangboo_flutter/common_widget/k_container.dart';
import 'package:jangboo_flutter/const/const.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key, required this.textCtr});
  final TextEditingController textCtr;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            NumberPadItem(
              number: 1,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 2,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 3,
              textCtr: textCtr,
            ),
          ],
        ),
        Row(
          children: [
            NumberPadItem(
              number: 4,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 5,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 6,
              textCtr: textCtr,
            ),
          ],
        ),
        Row(
          children: [
            NumberPadItem(
              number: 7,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 8,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 9,
              textCtr: textCtr,
            ),
          ],
        ),
        Row(
          children: [
            NumberFucPad(
              icon: Icons.remove,
              textCtr: textCtr,
            ),
            NumberPadItem(
              number: 0,
              textCtr: textCtr,
            ),
            NumberFucPad(
              icon: Icons.delete,
              textCtr: textCtr,
              delete: true,
            ),
          ],
        ),
      ],
    );
  }
}

class NumberPadItem extends StatelessWidget {
  const NumberPadItem({super.key, required this.number, required this.textCtr});
  final int number;
  final TextEditingController textCtr;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 2,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              hoverColor: Colors.grey[100],
              onTap: () {
                textCtr.text = textCtr.text + number.toString();
              },
              child: Center(
                  child: Text(
                number.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))),
        ),
      ),
    );
  }
}

class NumberFucPad extends StatelessWidget {
  const NumberFucPad(
      {super.key,
      required this.icon,
      required this.textCtr,
      this.delete = false});
  final IconData icon;
  final TextEditingController textCtr;
  final bool delete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
          aspectRatio: 2,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                hoverColor: Colors.grey[100],
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  if (delete) {
                    // 버튼이 지우는 키라면
                    textCtr.text = '';
                  } else {
                    // 버튼이 cancel키고
                    if (textCtr.text != '') {
                      // 텍스트가 비어있지않다면 끝자리를 지우고
                      String newString =
                          textCtr.text.substring(0, textCtr.text.length - 1);
                      textCtr.text = newString;
                    } else {
                      // 텍스트가 비어있다면 전체 삭제
                      textCtr.text = '';
                    }
                  }
                },
                child: Center(child: Icon(icon))),
          )),
    );
  }
}
