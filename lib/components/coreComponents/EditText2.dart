import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_app/components/styles/textStyles.dart';
import '../styles/appColors.dart';
import '../styles/decoration.dart';
import 'TextView.dart';

class Edittext2 extends StatefulWidget {
  final TextEditingController? controller;
  final bool? readOnly;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;
  final Color? borderColor;
  final Color? filledColor;
  final String? hint;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextInputType? inputType;
  final int noOfLines;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final int? maxLength;
  final Function(String)? onChange;
  final FocusNode? node;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const Edittext2({
    super.key,
    this.controller,
    this.readOnly,
    this.padding,
    this.margin,
    this.radius,
    this.borderColor,
    this.filledColor,
    this.hint,
    this.hintStyle,
    this.textStyle,
    this.inputType,
    this.noOfLines = 1,
    this.prefixIcon,
    this.textAlign,
    this.maxLength,
    this.onChange,
    this.node,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  State<Edittext2> createState() => _EditText2State();
}

class _EditText2State extends State<Edittext2> {
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
  Widget build(BuildContext context) {
    final borderStyle = AppDecoration.inputBorder(
      borderColor: AppColors.border,
      radius: widget.radius,
    );

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextFormField(
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onTap: () => setState(() {}),
            focusNode: widget.node,
            style: widget.textStyle ?? 14.txtRegularBlack,
            textAlign: widget.textAlign ?? TextAlign.start,
            obscureText: widget.obscureText,
            keyboardType: widget.inputType,
            maxLength: widget.maxLength,
            minLines: widget.noOfLines,
            maxLines: widget.noOfLines,
            readOnly: widget.readOnly ?? false,
            onChanged: (value) {
              setState(() {
                _isTextEntered = value.isNotEmpty;
              });
              if (widget.onChange != null) {
                widget.onChange!(value);
              }
            },
            inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.filledColor ?? AppColors.white,
              isDense: true,
              enabledBorder: borderStyle,
              border: borderStyle,
              focusedBorder: borderStyle,
              suffixIcon: widget.suffixIcon,
              contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              counterText: "", // Hide maxLength counter
            ),
          ),
          Positioned(
            left: 12,
            top: _isTextEntered ? 4 : 4,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: _isTextEntered ? 12 : 16,
                color: _isTextEntered ? Colors.grey : Colors.black54,
              ),
              child: Text(widget.hint ?? "",style: 12.txtRegularGrey,),
            ),
          ),
        ],
      ),
    );
  }
}
