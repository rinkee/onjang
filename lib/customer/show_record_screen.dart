import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:jangboo_flutter/const/const.dart';
import 'package:jangboo_flutter/supabase.dart';

class ShowRecordScreen extends StatelessWidget {
  const ShowRecordScreen({super.key, required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '기록',
                style: menuTitle,
              ),
              const Gap(20),
              Expanded(
                child: FutureBuilder(
                  future: supabase
                      .from('balance_log')
                      .select()
                      .eq('customer_id', customerId)
                      .order('created_at', ascending: false),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('데이터가 없습니다'));
                    }
                    var groupedTransactions =
                        groupTransactionsByDate(snapshot.data!);

                    return ListView.builder(
                      itemCount: groupedTransactions.keys.length,
                      itemBuilder: (context, index) {
                        String date = groupedTransactions.keys.elementAt(index);
                        List<Map<String, dynamic>> dailyTransactions =
                            groupedTransactions[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(date,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            ListView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // 중첩된 ListView 스크롤 문제 방지
                              shrinkWrap: true, // 내부 ListView 크기 자동 조절
                              itemCount: dailyTransactions.length,
                              itemBuilder: (context, idx) {
                                var transaction = dailyTransactions[idx];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            DateFormat('HH:mm').format(
                                                DateTime.parse(
                                                    transaction['created_at'])),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          const Gap(20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                transaction['type'] == 'add'
                                                    ? '충전'
                                                    : '사용',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        transaction['type'] ==
                                                                'add'
                                                            ? sgColor
                                                            : Colors.grey[700]),
                                              ),
                                              Text(
                                                '${f.format(transaction['money'])}원',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              transaction['canceled'] == true
                                                  ? '취소 됨'
                                                  : '',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                );
                                return ListTile(
                                  leading: Text(DateFormat('HH:mm').format(
                                      DateTime.parse(transaction[
                                          'created_at']))), // 예시 아이콘
                                  title: Text(transaction['type'] == 'add'
                                      ? '충전'
                                      : '사용'), // 거래 설명
                                  subtitle: Text(
                                      '${f.format(transaction['money'])}원'), // 거래 금액
                                  // 기타 필요한 UI 구성 요소 추가
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

  Map<String, List<Map<String, dynamic>>> groupTransactionsByDate(
      List<Map<String, dynamic>> transactions) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var transaction in transactions) {
      String date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(transaction['created_at']));
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }
    return grouped;
  }
}
