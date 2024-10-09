import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';

class ExplainMojangWidget extends StatelessWidget {
  const ExplainMojangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: PaddingColumn(
          children: [
            Text(
              '모두의장부는',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              '효율적이고 트렌디한 사장님들을 위한 혁신적인 선결제 온라인 장부 서비스로, 매장 관리를 간소화하고 고객 경험을 향상시킵니다.',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
