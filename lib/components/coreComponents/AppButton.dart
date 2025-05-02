import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'TapWidget.dart';
import 'TextView.dart';

class AppButton extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final Function()? onTap;
  final double? radius;
  final Color? buttonColor;
  final Gradient? gradient;
  final Gradient? buttonBorderGradient;
  final Color? buttonBorderColor;
  final double? buttonBorderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isFilledButton;
  final Widget? child;
  final Widget? prefix;
  final Widget? suffix;
  final Alignment alignment;
  final double? width;
  final double? height;
  final bool isLoading;

  const AppButton({
    super.key,
    this.label,
    this.onTap,
    this.radius,
    this.labelStyle,
    this.buttonColor,
    this.gradient,
    this.buttonBorderGradient,
    this.buttonBorderColor,
    this.buttonBorderWidth,
    this.padding,
    this.margin,
    this.isFilledButton = true,
    this.child,
    this.prefix,
    this.suffix,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color effectiveBorderColor = buttonBorderColor ??
        (buttonBorderGradient != null && buttonBorderGradient!.colors.isNotEmpty
            ? buttonBorderGradient!.colors.first
            : Colors.transparent);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Align(
        alignment: alignment,
        child: Stack(
          children: [
            // Border Layer
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 40),
                gradient: buttonBorderGradient, // Gradient border
                border: buttonBorderGradient == null
                    ? Border.all(
                  color: effectiveBorderColor,
                  width: buttonBorderWidth ?? 1,
                )
                    : null,
              ),
              padding: EdgeInsets.all(buttonBorderWidth ?? 1.5),
              child: Container(
                padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: width ?? (isFilledButton ? double.maxFinite : null),
                height: height,
                decoration: BoxDecoration(
                  color: buttonColor,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular((radius ?? 40) - (buttonBorderWidth ?? 2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefix != null && !isLoading) prefix!,
                    isLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : TextView(
                      text: label ?? '',
                      style: labelStyle ?? 14.txtMediumWhite,
                      textAlign: TextAlign.center,
                    ),
                    if (suffix != null && !isLoading) suffix!,
                  ],
                ),
              ),
            ),
            // Tap Layer
            Positioned.fill(
              child: TapWidget(
                onTap: isLoading ? null : onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
