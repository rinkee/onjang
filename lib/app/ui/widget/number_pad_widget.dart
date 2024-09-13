import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final keys = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
  ['00', '0', const Icon(Icons.keyboard_backspace)],
];

class NumberPadWidget extends StatefulWidget {
  NumberPadWidget({
    super.key,
    required this.label,
    required this.onTap,
    required this.value,
    required this.textCtr,
    this.ratio,
  });
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;
  final TextEditingController textCtr;
  double? ratio;

  @override
  _NumberPadWidgetState createState() => _NumberPadWidgetState();
}

class _NumberPadWidgetState extends State<NumberPadWidget> {
  renderLabel() {
    if (widget.label is String) {
      return Text(
        widget.label,
        style: const TextStyle(
          fontSize: 20.0,
        ),
      );
    } else {
      return widget.label;
    }
  }

  keyPress() {
    if (widget.label is String) {
      // if (widget.value == '0' && widget.textCtr.text == '') {
      //   print('0');
      // } else {
      //   // widget.textCtr.text = widget.textCtr.text + widget.value.toString();
      // }
      widget.textCtr.text = widget.textCtr.text + widget.value.toString();
    } else {
      if (widget.textCtr.text != '') {
        String newString =
            widget.textCtr.text.substring(0, widget.textCtr.text.length - 1);
        widget.textCtr.text = newString;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () {
          widget.onTap(widget.value);
          HapticFeedback.lightImpact();
          keyPress();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: AspectRatio(
            aspectRatio: widget.ratio ?? 2,
            child: Container(
              color: Colors.white,
              child: Center(
                child: renderLabel(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
