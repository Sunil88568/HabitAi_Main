
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'EditText.dart';

class BioSection extends StatefulWidget {
  final TextEditingController? controller;
  final bool? readOnly;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;
  final Color? borderColor;
  final Color? filledColor;
  final bool isFilled;
  final String? hint;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final String? label;
  final TextStyle? labelStyle;
  final TextInputType? inputType;
  final int noOfLines;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final int? maxLength;
  final Function(String)? onChange;
  final FocusNode? node;
  final Widget? suffixIcon;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormat;
  final String? error;
  final BoxConstraints? prefixIconConstraints;
  final Function()? onTap;
  final bool isOptional;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool showHint;

  const BioSection({
    super.key,
    this.controller,
    this.readOnly,
    this.padding,
    this.margin,
    this.radius,
    this.borderColor,
    this.filledColor,
    this.isFilled = true,
    this.hint,
    this.hintStyle,
    this.textStyle,
    this.label,
    this.labelStyle,
    this.inputType = TextInputType.multiline,
    this.noOfLines = 4,
    this.suffixText,
    this.suffixTextStyle,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.maxLength = 500,
    this.onChange,
    this.node,
    this.suffixIcon,
    this.suffix,
    this.inputFormat,
    this.error,
    this.prefixIconConstraints,
    this.onTap,
    this.isOptional = false,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode,
    this.showHint = true,
  });

  @override
  _BioSectionState createState() => _BioSectionState();
}

class _BioSectionState extends State<BioSection> {
  bool _isTextEntered = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      setState(() {
        _isTextEntered = widget.controller!.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          EditText(
            controller: widget.controller,
            readOnly: widget.readOnly,
            padding: widget.padding ?? const EdgeInsets.all(12),
            margin: widget.margin,
            radius: widget.radius,
            borderColor: widget.borderColor ?? Colors.grey,
            filledColor: widget.filledColor ?? Colors.grey.shade100,
            isFilled: widget.isFilled,
            hintStyle: widget.hintStyle ?? 14.txtRegularBlack,
            textStyle: widget.textStyle ?? 14.txtRegularBlack,
            label: widget.label,
            labelStyle: widget.labelStyle,
            inputType: widget.inputType,
            noOfLines: widget.noOfLines,
            suffixText: widget.suffixText,
            suffixTextStyle: widget.suffixTextStyle,
            prefixIcon: widget.prefixIcon,
            textAlign: widget.textAlign,
            maxLength: widget.maxLength,
            onChange: widget.onChange,
            node: widget.node,
            suffixIcon: widget.suffixIcon,
            suffix: widget.suffix,
            inputFormat: widget.inputFormat,
            error: widget.error,
            prefixIconConstraints: widget.prefixIconConstraints,
            onTap: widget.onTap,
            isOptional: widget.isOptional,
            obscureText: widget.obscureText,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
          ),
          if (widget.showHint)
            Positioned(
              left: 12,
              top: _isTextEntered ? 4 : 4,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: _isTextEntered ? 12 : 16,
                  color: _isTextEntered ? Colors.grey : Colors.black54,
                ),
                child: Text(
                  widget.hint ?? "",
                  style: widget.hintStyle ?? 12.txtRegularGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
