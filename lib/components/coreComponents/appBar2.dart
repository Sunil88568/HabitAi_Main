
import 'package:flutter/material.dart';
import 'package:question_app/utils/extensions/text_style.dart';
import '../styles/appColors.dart';
import 'ImageView.dart';
import 'TextView.dart';

class AppBar2 extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget? leadIcon;
  final bool isLeadVisible;
  final double? leadIconSize;
  final double? leadIconBottomMargin;
  final Function()? onLeadTap;
  final Widget? tail;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final Color? appBarColor;
  final bool hasShadow;
  final bool hasTopSafe;
  final TextAlign? titleAlign;
  final String? prefixImage;
  final String? suffixImage;
  final Function()? onPrefixTap;
  final Function()? onSuffixTap;
  final Widget? suffixWidget;
  final bool? centerTitle;

  const AppBar2({
    super.key,
    this.padding,
    this.leadIcon,
    this.onLeadTap,
    this.leadIconSize,
    this.tail,
    this.isLeadVisible = true,
    this.title,
    this.titleStyle,
    this.child,
    this.leadIconBottomMargin,
    this.appBarColor,
    this.hasShadow = true,
    this.hasTopSafe = true,
    this.titleAlign = TextAlign.center,
    this.prefixImage,
    this.suffixImage,
    this.onPrefixTap,
    this.onSuffixTap,
    this.suffixWidget,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadView() {
      return Visibility(
        visible: isLeadVisible,
        child: leadIcon ??
            ImageView(
              onTap: onLeadTap,
              url: '',
              size: leadIconSize ?? 29,
              margin: leadIconBottomMargin != null
                  ? EdgeInsets.fromLTRB(0, 0, 0, leadIconBottomMargin!)
                  : const EdgeInsets.only(right: 0),
            ),
      );
    }

    Widget prefixView() {
      return Visibility(
        visible: prefixImage != null,
        child: ImageView(
          tintColor: AppColors.black,
          onTap: onPrefixTap,
          url: prefixImage ?? '',
          size: leadIconSize ?? 24,
        ),
      );
    }

    Widget suffixView() {
      return Visibility(
        visible: suffixWidget != null || suffixImage != null,
        child: suffixWidget ??
            (suffixImage != null
                ? ImageView(
              tintColor: AppColors.black,
              onTap: onSuffixTap,
              url: suffixImage!,
              size: leadIconSize ?? 17,
            )
                : Container()),
      );
    }

    return SafeArea(
      top: hasTopSafe,
      bottom: false,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                prefixView(),
                leadView(),
                Expanded(
                  child: SizedBox(),
                ),
                tail ?? const SizedBox.shrink(),
                suffixView(),
              ],
            ),
            if (title != null)
              Align(
                alignment: centerTitle == true ? Alignment.center : Alignment.centerLeft,
                child: TextView(
                  text: title!,
                  style: titleStyle ?? 16.txtMediumBlack,
                  textAlign: titleAlign,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
