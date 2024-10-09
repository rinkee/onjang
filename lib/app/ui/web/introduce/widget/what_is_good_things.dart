import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';

class WhatIsGoodThings extends StatelessWidget {
  const WhatIsGoodThings({
    super.key,
    required this.mainTitleSize,
    required this.titleSize,
    required this.descriptionSize,
  });
  final double mainTitleSize;
  final double titleSize;
  final double descriptionSize;

  @override
  Widget build(BuildContext context) {
    return PaddingColumn(
      children: [
        Text(
          '이런 장점이 있어요',
          style: TextStyle(
            fontSize: mainTitleSize,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Gap(50),
        TellGoodThings(
          title: '검색 기능',
          description: '일일이 찾아야 했던 장부를 쉽게 찾아보세요',
          titleSize: titleSize,
          descriptionSize: descriptionSize,
        ),
        TellGoodThings(
          title: '자동 계산',
          description: '잔액이 자동으로 계산되어 편리합니다',
          titleSize: titleSize,
          descriptionSize: descriptionSize,
        ),
        TellGoodThings(
          title: '추가 충전',
          description: '고객님께 할인 혜택 효과를 제공합니다',
          titleSize: titleSize,
          descriptionSize: descriptionSize,
        ),
        TellGoodThings(
          title: '장부 관리',
          description: '마지막 방문 날짜, 평균사용 금액, 한눈에 보이는 잔액으로 관리가 편해집니다',
          titleSize: titleSize,
          descriptionSize: descriptionSize,
        ),
        TellGoodThings(
          title: '합리적인 가격',
          description: '월 1,000원부터 시작하는 플랜으로 부담 없이 적용할 수 있습니다',
          titleSize: titleSize,
          descriptionSize: descriptionSize,
        ),
      ],
    );
  }
}

class TellGoodThings extends StatelessWidget {
  TellGoodThings(
      {super.key,
      required this.title,
      required this.description,
      required this.titleSize,
      required this.descriptionSize});

  final String title;
  final String description;
  final double titleSize;
  final double descriptionSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w700),
        ),
        Gap(3),
        Text(
          description,
          style: TextStyle(fontSize: descriptionSize, color: Colors.grey[600]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: Colors.grey[200],
          ),
        )
      ],
    );
  }
}
