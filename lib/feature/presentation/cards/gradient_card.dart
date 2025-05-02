import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/styles/appColors.dart';

class GradientCard extends StatelessWidget {
  GradientCard({
    super.key,
    this.child,
    this.onClick,
    this.width,
    this.height,
    this.margin,
    this.gradient,
    this.padding,
    this.radius,
    this.color,
  });

  final VoidCallback? onClick;
  final Widget? child;
  final double? height;
  final double? radius;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClick,
      child: Container(
        padding: padding,
        margin: margin,
        height: height,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10),
          gradient: gradient ?? (color == null ? AppColors.gradientBtn : null),
          color: color,
        ),
        child: child,
      ),
    );
  }
}
