import 'package:flutter/material.dart';
import 'package:jangboo_flutter/supabase.dart';

class BalanceLogScreen extends StatelessWidget {
  const BalanceLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('기록'),
        StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase.from('balance_log').stream(primaryKey: ['id']),
            builder: (context,snapshot) {
          if(!snapshot.hasData) {
            return Text('기록이 없습니다');
          }
          return Text('기록이 있습니다');
        })
      ],
    );
  }
}
