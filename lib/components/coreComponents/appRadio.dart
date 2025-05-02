import 'package:flutter/material.dart';

import '../styles/appColors.dart';

class AppRadio extends StatelessWidget {
  final double size;
  final bool status;
  final Function(bool) onChange;
  const AppRadio({super.key, required this.status, required this.onChange,  this.size = 20});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: Radio(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: status ? 'radio' : '',
        groupValue: 'radio',
        fillColor: MaterialStateColor.resolveWith((states) =>
        status ? AppColors.primaryColor :
        AppColors.black), activeColor: status ? AppColors.primaryColor : AppColors.white, onChanged: (value) => onChange(!status)),
    ); }
}
