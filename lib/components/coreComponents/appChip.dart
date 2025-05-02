
import 'package:flutter/material.dart';
import 'package:question_app/utils/extensions/text_style.dart';
import '../styles/appColors.dart';
import 'TapWidget.dart';
import 'TextView.dart';

class AppChip extends StatelessWidget { final String? value;
final bool state;
final Function()? onTap;
const AppChip({super.key, required this.value, this.state = false, this.onTap});
@override
Widget build(BuildContext context) {
  return Stack( children: [
    Container(
      padding: EdgeInsets.all(
              10
      ), decoration: BoxDecoration(
      color: state ? AppColors.primaryColor : Colors.transparent,
        border: Border.all(
            // color: state ? AppColors.primaryGreen : AppColors.greyLightBorder
            color: state ? AppColors.primaryColor : AppColors.primaryColor
        ),
        borderRadius: BorderRadius.circular(
            // AppFonts.s20
            25
        ) ),
      child: TextView(text: value ?? '',
        style: 14.txtMediumBlack
        // TextStyles.regular14GreySemiDarkGreyText,
      ), ),
    Positioned.fill(child: TapWidget(onTap: onTap,)) ],
  ); }
}
