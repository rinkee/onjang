import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';

class DontWrite extends StatelessWidget {
  const DontWrite({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: PaddingColumn(
          children: [
            Text(
              '✍️',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              '이제 더이상 적지마세요',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              '정산하려고 보면 모두 다른 글씨체 때문에 이게 얼마였더라 헷갈린적 있으시죠? 적지 않고 누르면 헷갈릴 일도 없고 잔액도 자동으로 계산되요',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
