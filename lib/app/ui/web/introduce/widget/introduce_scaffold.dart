import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jangboo_flutter/app/data/routes/app_routes.dart';

class IntroduceScaffold extends StatelessWidget {
  IntroduceScaffold({super.key, required this.body});

  Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                '모두의장부',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    // context.pushNamed(Routes.login);
                    context.pushNamed(Routes.login);
                    // context.goNamed(name)
                  },
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
