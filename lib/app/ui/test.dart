import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/go_routes.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('테스트 페이지'),
          TextButton(
              onPressed: () {
                context.goNamed('/2');
              },
              child: Text('테스트2로'))
        ],
      ),
    );
  }
}

class TestScreen2 extends StatelessWidget {
  const TestScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('테스트 페이지2'),
          TextButton(
              onPressed: () {
                context.goNamed('/3');
              },
              child: Text('테스트3로'))
        ],
      ),
    );
  }
}

class TestScreen3 extends StatelessWidget {
  const TestScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('테스트 페이지3'),
    );
  }
}
