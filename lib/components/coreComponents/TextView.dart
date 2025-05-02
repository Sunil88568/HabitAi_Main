import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
class TextView extends StatelessWidget { final String text;
final dynamic color;
final dynamic underlineColor;
final TextStyle? style; final bool? underline; final bool? strikeThrough; final dynamic textSize; final bool? capitalise; final int? maxlines;
final TextAlign? textAlign; final String? fontFamily;
final FontWeight? fontWeight; final double? lineHeight;
final FontStyle? fontStyle;
final double? letterSpacing;
final TextOverflow ?overflow;
final EdgeInsets? margin;
final Function()? onTap;
final bool visible;
const TextView( {super.key, required this.text,
  this.color,
  this.style,
  this.maxlines,

  this.textAlign,
  this.underline,
  this.textSize,
  this.fontFamily,
  this.fontWeight,
  this.lineHeight,
  this.fontStyle,
  this.underlineColor, this.strikeThrough,
  this.capitalise,
  this.letterSpacing,
  this.overflow, this.margin, this.onTap,this.visible = true
});
@override
Widget build(BuildContext context) {
  TextStyle baseStyle = style ?? 14.txtBoldWhite;
  baseStyle = baseStyle.copyWith(
    color: color ?? baseStyle.color,
    fontSize: textSize != null ? (textSize is double ? textSize : (textSize as num).toDouble()) : baseStyle.fontSize,
    fontFamily: fontFamily ?? baseStyle.fontFamily,
    fontWeight: fontWeight ?? baseStyle.fontWeight,
    height: lineHeight ?? baseStyle.height,
    fontStyle: fontStyle ?? baseStyle.fontStyle,
    letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
    decoration: (underline == true && strikeThrough == true)
        ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
        : (underline == true)
        ? TextDecoration.underline
        : (strikeThrough == true)
        ? TextDecoration.lineThrough
        : TextDecoration.none,
    decorationColor: underlineColor ?? baseStyle.decorationColor,
  );

  return Visibility(
    visible: visible,
    child: Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Text(
              capitalise == true ? text.toUpperCase() : text,
              maxLines: maxlines,
              overflow: overflow ?? (maxlines != null ? TextOverflow.ellipsis : null),
              textAlign: textAlign,
              style: baseStyle.copyWith(
                decoration: strikeThrough == true ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            if (underline == true)
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: underlineColor ?? baseStyle.color,
                ),
              ),
          ],
        ),
      ),
    ),
  );

}

}
