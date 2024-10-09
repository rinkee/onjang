import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';

class PlanWidget extends StatelessWidget {
  const PlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingColumn(
      children: [
        Text(
          '플랜',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Gap(20),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.1),
                    //     spreadRadius: 5,
                    //     blurRadius: 7,
                    //     offset: Offset(
                    //         0, 3), // changes position of shadow
                    //   ),
                    // ],
                    color: Colors.grey[100]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Table(
                        // border: TableBorder.all(
                        //     color: const Color.fromARGB(
                        //         255, 234, 234, 234)),
                        children: [
                          TableRow(
                            children: [
                              TableText(
                                text: '플랜명',
                              ),
                              TableText(
                                text: '장부1000',
                              ),
                              TableText(
                                text: '장부3000',
                              ),
                              TableText(
                                text: '장부5000',
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableText(
                                text: '고객 등록 수',
                              ),
                              TableText(
                                text: '5명',
                              ),
                              TableText(
                                text: '무제한',
                              ),
                              TableText(
                                text: '무제한',
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableText(
                                text: '광고',
                              ),
                              TableText(
                                text: 'O',
                              ),
                              TableText(
                                text: 'X',
                              ),
                              TableText(
                                text: 'X',
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableText(
                                text: '가격 (월)',
                              ),
                              TableText(
                                text: '1000원',
                              ),
                              TableText(
                                text: '3000원',
                              ),
                              TableText(
                                text: '5000원',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TableText extends StatelessWidget {
  const TableText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        text,
        style: TextStyle(fontSize: 16),
      )),
    );
  }
}
