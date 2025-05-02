// import 'package:bwssb/utils/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../styles/appColors.dart';
// import 'EditText.dart';
// import 'appDropDown.dart';
//
// class DropDownEditText extends StatelessWidget {
//   final String? label;
//   final Function(String)? onChange;
//   final TextEditingController controller;
//   final String? error;
//   final List<TextInputFormatter>? inputFormatter;
//   final List<MenuModel>? unitsList;
//   final MenuModel selectedUnit;
//   final Function(MenuModel) onChangeUnits;
//   final bool isHindi;
//   final bool isOptional;
//   const DropDownEditText({super.key, this.label, this.onChange, required this.controller,
//     this.isHindi = false,
//     this.error, this.inputFormatter, this.unitsList, required this.selectedUnit, required this.onChangeUnits,  this.isOptional = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         EditText(
//           // isOptional: isOptional,
//           // label: label,
//           inputType: TextInputType.number,
//           inputFormat:  inputFormatter ?? InputFormats.number,
//           controller: controller,
//             // padding: EdgeInsets.all(0),
//
//             suffixIcon:  SizedBox(
//               width: 102,
//               child:
//               Stack(
//                 children: [
//                   SizedBox(
//                     width: 100,
//                     child: AppDropDown<MenuModel>.singleSelect(
//                       // list: unitsList ?? ListClass.apartmentUnits,
//                       list: unitsList ?? [],
//                       padding: EdgeInsets.zero,
//                       borderColor: Colors.transparent,
//                       selectedValue: selectedUnit,
//                       singleValueBuilder: (value )=> isHindi ? value.nameHi ?? value.nameEn  : value.nameEn,
//                       itemBuilder: (value)=> isHindi ? value.nameHi ?? value.nameEn  : value.nameEn,
//                       onSingleChange: onChangeUnits,
//                       // textBox: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
//                       width: 100,
//                     ),
//                   ),
//                   Positioned(
//                     left: 0,
//                       top: 0,
//                       bottom: 0,
//                       child:Container(width: 2,color: error!.isNotNullEmpty ? AppColors.white :
//                       AppColors.black,))
//                 ],
//               )
//             ),
//           onChange: onChange,
//           // error: error,
//         ),
//       ],
//     );
//   }
// }
//
//
//
