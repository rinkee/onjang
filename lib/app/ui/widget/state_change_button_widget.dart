import 'package:flutter/material.dart';

class StateChangeButtonWidget extends StatelessWidget {
  const StateChangeButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.color,
    this.iconColor,
  });

  final GestureTapCallback onTap;
  final String title;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              child: Icon(
                icon,
                color: iconColor,
              ),
              backgroundColor: color,
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
