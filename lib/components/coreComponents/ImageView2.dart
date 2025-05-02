// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../styles/appColors.dart';
// import 'TapWidget.dart';
//
// enum ImageType { asset, file, network }
//
// class ImageView extends StatelessWidget {
//   final String url;
//   final ImageType? imageType;
//   final double? size;
//   final double? height;
//   final double? width;
//   final BoxFit? fit;
//   final double? radius;
//   final Color? tintColor;
//   final Color? borderColor;
//   final EdgeInsets? margin;
//   final EdgeInsets? padding;
//   final Function()? onTap;
//   final bool hasBorder;
//   final bool hasGradient;
//   final Color? bgColor;
//   final double? radiusWidth;
//   final String? defaultImage;
//   final EdgeInsets? imagePadding;
//
//   const ImageView(
//       {super.key,
//         required this.url,
//         this.imageType,
//         this.size,
//         this.height,
//         this.width,
//         this.imagePadding,
//         this.fit,
//         this.onTap,
//         this.radius,
//         this.tintColor,
//         this.margin,
//         this.hasBorder = false,
//         this.borderColor,
//         this.bgColor,
//         this.radiusWidth,
//         this.padding,
//         this.hasGradient = false, this.defaultImage});
//
//   ImageProvider image() {
//     switch (imageType) {
//       case ImageType.network:
//
//         return url.trim().isEmpty && defaultImage != null  ?
//         AssetImage(defaultImage!):
//         NetworkImage(url);
//       case ImageType.file:
//         return FileImage(File(url));
//       default:
//         return AssetImage(url);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: margin ?? EdgeInsets.zero,
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(radius ?? 10),
//                 gradient: hasGradient ? AppColors.gradientBtn : null),
//             // padding: const EdgeInsets.all(4),
//             child:        Container(
//               height: size ?? height,
//               width: size ?? width,
//               decoration: BoxDecoration(
//                   color: bgColor
//                   // ?? Colors.white
//                   ,
//                   borderRadius: BorderRadius.circular(radius ?? 0),
//                   border: hasBorder
//                       ? Border.all(
//                       color: borderColor ?? AppColors.grey,
//                       width: radiusWidth ?? 1.0)
//                       : null),
//               padding: imagePadding,
//               clipBehavior: Clip.hardEdge,
//               child: Container(
//                 padding: padding,
//                 color: imageType == ImageType.network
//                     ?
//                 // AppColors.greyLightBorder
//                 // AppColors.white
//                 null
//                     : null,
//                 child: Image(
//                   image: image(),
//                   height: size ?? height,
//                   width: size ?? width,
//                   fit: fit,
//                   color: tintColor,
//                   errorBuilder: (context, error, stackTrace) =>
//                   const SizedBox(),
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//               child: TapWidget(
//                 onTap: onTap,
//               ))
//         ],
//       ),
//     );
//   }
// }
