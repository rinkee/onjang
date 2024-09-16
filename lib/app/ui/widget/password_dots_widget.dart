import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class PasswordDotsWidget extends StatelessWidget {
  PasswordDotsWidget({super.key, required this.password});
  RxString password;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Obx(() => Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  backgroundColor: password.value.length > index
                      ? Colors.black
                      : Colors.grey[300],
                ),
              ));
        },
      ),
    );
    ;
  }
}
