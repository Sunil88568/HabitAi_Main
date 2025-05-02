import 'package:flutter/material.dart';

import 'appColors.dart';

class RangeSliderCircleThumbShape extends RangeSliderThumbShape {
  const RangeSliderCircleThumbShape({this.thumbRadius = 10.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required SliderThemeData sliderTheme,
        bool? isDiscrete,
        bool? isEnabled,
        bool? isOnTop,
        TextDirection? textDirection,
        Thumb? thumb,
        bool? isPressed,
      }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(center, thumbRadius, fillPaint)
      ..drawCircle(center, thumbRadius, borderPaint);
  }
}


class SliderCustomThumbShape extends RoundSliderThumbShape {
  const SliderCustomThumbShape({this.thumbRadius = 10.0});

  final double thumbRadius;
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(

      PaintingContext context, Offset center,
      {Animation<double>? activationAnimation,
        Animation<double>? enableAnimation,
        bool? isDiscrete,
        TextPainter? labelPainter,
        RenderBox? parentBox,
        required SliderThemeData sliderTheme,
        TextDirection? textDirection,
        double? value,
        double? textScaleFactor,
        Size? sizeWithOverflow}
      ) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(center, thumbRadius, fillPaint)
      ..drawCircle(center, thumbRadius, borderPaint);
  }
}