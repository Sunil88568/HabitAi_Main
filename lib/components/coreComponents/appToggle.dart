import 'package:flutter/cupertino.dart';

import '../styles/appColors.dart';

class AppToggle extends StatelessWidget {
  final bool state;
  final Function(bool) onChanged;
  const AppToggle({super.key, required this.state, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Transform.scale( scale: 0.7,
      child: CupertinoSwitch(
        activeColor: AppColors.white, thumbColor: AppColors.white,
        value: state,
        onChanged: onChanged,
      ), );
  } }