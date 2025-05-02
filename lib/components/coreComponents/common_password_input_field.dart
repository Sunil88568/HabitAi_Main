
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:question_app/utils/extensions/text_style.dart';
import '../styles/appColors.dart';
import 'TextView.dart';

class CommonPasswordInputField extends StatefulWidget {
  final String hint;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final bool? isShowHelperText;
  final Widget? leading;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Color? fillColor;

  final double? marginLeft;
  final double? marginRight;
  final double? marginTop;
  final double? marginBottom;

  final String? label;
  final TextStyle? labelStyle;
  final bool isOptional;
  final EdgeInsets? padding;

  const CommonPasswordInputField({
    Key? key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.validator,
    this.errorText,
    this.inputType,
    this.inputFormatter,
    this.isShowHelperText,
    this.leading,
    this.focusNode,
    this.textInputAction,
    this.autoFocus,
    this.onFieldSubmitted,
    this.fillColor,
    this.marginLeft,
    this.marginBottom,
    this.marginRight,
    this.marginTop,
    this.label,
    this.labelStyle,
    this.isOptional = false,
    this.padding,
  }) : super(key: key);

  @override
  State<CommonPasswordInputField> createState() => _CommonPasswordInputFieldState();
}

class _CommonPasswordInputFieldState extends State<CommonPasswordInputField> {
  RxBool isObscure = true.obs;

  late final OutlineInputBorder inputBorder;
  late final OutlineInputBorder errorInputBorder;

  @override
  void initState() {
    super.initState();
    inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
    );

    errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.marginLeft ?? 0,
        right: widget.marginRight ?? 0,
        top: widget.marginTop ?? 8,
        bottom: widget.marginBottom ?? 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              children: [
                TextView(
                  text: widget.label!,
                  style: widget.labelStyle ?? 12.txtMediumBlack,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                if (widget.isOptional)
                  TextView(
                    text: '(Optional)',
                    style: 12.txtBoldWhite,
                    margin: const EdgeInsets.only(bottom: 4, left: 5),
                  ),
              ],
            ),
          ],
          Obx(
                () => TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: widget.autoFocus ?? false,
              textInputAction: widget.textInputAction,
              style: 14.txtMediumBlack,
              keyboardType: widget.inputType ?? TextInputType.visiblePassword,
              cursorColor: AppColors.primaryBlue,
              obscureText: isObscure.value,
              obscuringCharacter: '*',
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: widget.hint.tr,
                hintStyle: 16.txtRegularGrey,
                prefixIcon: widget.leading,
                suffixIcon: IconButton(
                  onPressed: () => isObscure.toggle(),
                  icon: Icon(
                    isObscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.greyHint,
                    size: 22,
                  ),
                ),
                filled: true,
                fillColor: widget.fillColor ?? AppColors.white,
                helperMaxLines: 2,
                helperStyle: 12.txtRegularGrey,
                errorMaxLines: 3,
                errorText: widget.errorText,
                errorStyle: 12.txtRegularError,
                contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
                border: inputBorder,
                errorBorder: errorInputBorder,
                enabledBorder: inputBorder,
                disabledBorder: inputBorder,
                focusedBorder: inputBorder,
                focusedErrorBorder: errorInputBorder,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: widget.inputFormatter,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
