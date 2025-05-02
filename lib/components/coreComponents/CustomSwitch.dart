import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/appColors.dart';

class CustomSwitch extends StatelessWidget {
  final RxBool isOn;
  final Function(bool) onChanged;

  CustomSwitch({required this.isOn, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isOn.value);
      },
      child: Obx(
            () => AnimatedContainer(
          duration: Duration(milliseconds: 250),
          width: 50.0,
          height: 25.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: isOn.value ? AppColors.forgetText : Colors.grey,
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          alignment: isOn.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Toggle color
            ),
          ),
        ),
      ),
    );
  }
}
