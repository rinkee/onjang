import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final keys = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
  ['00', '0', Icon(Icons.backspace)],
];

class NumberPadWidget extends StatelessWidget {
  const NumberPadWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.maxLength,
    this.aspectRatio = 2.0,
    this.backgroundColor = Colors.white,
    this.numberStyle = const TextStyle(fontSize: 20.0),
    this.hideDoubleZero = false,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;
  final int? maxLength;
  final double aspectRatio;
  final Color backgroundColor;
  final TextStyle numberStyle;
  final bool hideDoubleZero;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
      ),
      child: Column(
        children: keys.map((row) {
          return Row(
            children: row.map((key) {
              return Expanded(
                child: _buildKey(key),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKey(dynamic key) {
    if (hideDoubleZero && key == '00') {
      return Expanded(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(), // 빈 컨테이너로 '00' 키를 대체
        ),
      );
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _onKeyTap(key),
          child: Center(
            child:
                key is Widget ? key : Text(key.toString(), style: numberStyle),
          ),
        ),
      ),
    );
  }

  void _onKeyTap(dynamic key) {
    HapticFeedback.lightImpact();
    print(key);
    if (key is String) {
      if (key == '00' && !hideDoubleZero) {
        onChanged(value + '00'); // '00' 추가
      } else {
        onChanged(value + key); // 일반 숫자 추가
      }
    } else if (key is Icon && key.icon == Icons.backspace) {
      print('press back');
      if (value.isNotEmpty) {
        print('마지막 제거');
        onChanged(value.substring(0, value.length - 1)); // 마지막 문자 제거
      }
    }
  }
}
