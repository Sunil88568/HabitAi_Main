
import 'package:flutter/material.dart';

import '../styles/appColors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                color: Colors.blueGrey.shade100,
                width: 2,
              ),
            ),
            visualDensity: VisualDensity.compact,
            activeColor: AppColors.btnColor,
            checkColor: AppColors.white,
          ),
        ),
      ],
    );
  }
}
