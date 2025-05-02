import 'package:flutter/material.dart';
import '../../../../components/styles/appColors.dart';

class CustomListRow extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? splashColor;
  final bool toggle;

  const CustomListRow({
    Key? key,
    this.leading,
    required this.title,
     this.trailing,
    required this.onTap,
    this.splashColor = Colors.transparent,
    this.toggle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          leading: leading,
          title: title,
          trailing: toggle
              ? Switch(
            value: true,
            activeColor: AppColors.btnColor,
            onChanged: (value) {},
          )
              : trailing,
        ),
      ),
    );
  }
}
