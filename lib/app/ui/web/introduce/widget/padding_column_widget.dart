import 'package:flutter/material.dart';

class PaddingColumn extends StatelessWidget {
  PaddingColumn({super.key, required this.children});
  List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
