import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import '../styles/appColors.dart';
import '../styles/decoration.dart';
import 'TextView.dart';

class AppDropDown<T> extends StatelessWidget {
  final List<T> list;
  final bool isFilled;
  final Color? borderColor;
  final double? radius;
  final EdgeInsets? padding;
  final EdgeInsets? boxPadding;
  final double? menuMaxHeight;
  final double? width;
  final Function(MenuController)? onCreateController;
  final bool isEnabled;
  final Function()? onTap;

  final bool isMultiDropDown;
  final List<T>? multiSelectedValue;
  final T? selectedValue;
  final Function(T) itemBuilder;
  final String? title;
  final Function(T)? singleValueBuilder;
  final Function(T)? multiValueBuilder;
  final Function(T)? onSingleChange;
  final Function(List<T>)? onMultiChange;
  final String? hint;
  final Widget? textBox;
  final String? error;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppDropDown.multiSelect({
    super.key,
    this.isMultiDropDown = true,
    this.title,
    required this.list,
    required this.multiSelectedValue,
    required this.multiValueBuilder,
    required this.itemBuilder,
    required this.onMultiChange,
    this.onSingleChange,
    this.selectedValue,
    this.singleValueBuilder,
    this.hint,
    this.isFilled = false,
    this.borderColor,
    this.radius,
    this.padding,
    this.boxPadding,
    this.menuMaxHeight,
    this.width,
    this.textBox,
    this.onCreateController,
    this.error,
    this.isEnabled = true,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  const AppDropDown.singleSelect({
    super.key,
    this.title,
    this.isMultiDropDown = false,
    required this.list,
    required this.selectedValue,
    required this.singleValueBuilder,
    required this.itemBuilder,
    required this.onSingleChange,
    this.onMultiChange,
    this.multiValueBuilder,
    this.multiSelectedValue,
    this.hint,
    this.isFilled = false,
    this.borderColor,
    this.radius,
    this.padding,
    this.boxPadding,
    this.menuMaxHeight,
    this.width,
    this.textBox,
    this.onCreateController,
    this.error,
    this.isEnabled = true,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = AppDecoration.bDecorationGreyR(
      borderColor: AppColors.grey.withOpacity(0.3),
      radius: radius ?? 10,
      borderWidth: 1,
    );


    String hintValue =
    hint != null && hint!.trim().isNotEmpty ? hint! : 'Choose...';
    String? value = generateValue();
    MenuController controller = MenuController();

    return _dropDownWidget(
      controller: controller,
      width: width,
      hintValue: hintValue,
      value: value,
      decoration: borderStyle,
      textBox: textBox,
      error: error,
      isEnabled: isEnabled,
      onTap: onTap,
      padding: boxPadding,
      getController: (ctrl) =>
      onCreateController != null ? onCreateController!(ctrl) : null,
      menuList: [
        ...list.asMap().entries.map((e) => InkWell(
          onTap: () {
            if (isMultiDropDown) {
              List<T> list = multiSelectedValue ?? [];
              if (multiSelectedValue!.contains(e.value)) {
                list.remove(e.value);
              } else {
                list.add(e.value);
              }
              onMultiChange!(list);
            } else {
              controller.close();
              onSingleChange!(e.value);
            }
          },
          child: Container(
              width: double.maxFinite,
              color: isMultiDropDown &&
                  multiSelectedValue!.contains(e.value)
                  ? AppColors.primaryColor
                  : AppColors.white,
              padding: const EdgeInsets.all(10),
              child: TextView(text: itemBuilder(e.value) ?? '',style: 15.txtRegularBlack,)),
        ))
      ],
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  String? generateValue() {
    if (isMultiDropDown) {
      if (multiSelectedValue != null && multiSelectedValue!.isNotEmpty) {
        List<String> finalValue = [];
        for (var item in multiSelectedValue!) {
          String value = multiValueBuilder!(item);
          finalValue.add(value);
        }
        return finalValue.map((element) => element.toString()).join(', ');
      } else {
        return null;
      }
    } else {
      if (selectedValue != null) {
        String value = singleValueBuilder!(selectedValue!);
        return value;
      } else {
        return null;
      }
    }
  }
}

Widget _dropDownWidget({
  required MenuController controller,
  required double? width,
  required List<Widget> menuList,
  required String? value,
  required String hintValue,
  required BoxDecoration decoration,
  required bool isEnabled,
  Function()? onTap,
  EdgeInsets? padding,
  String? error,
  Widget? textBox,
  required Function(MenuController) getController,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  double getWidth(BoxConstraints boxConstraints) {
    if (boxConstraints.maxWidth == double.infinity ||
        boxConstraints.maxWidth == double.maxFinite) {
      return 250;
    }
    return boxConstraints.maxWidth;
  }

  return LayoutBuilder(
    builder: (context, boxConstraints) {
      double modalWidth = width ?? getWidth(boxConstraints);
      return MenuAnchor(
        controller: controller,
        crossAxisUnconstrained: false,
        clipBehavior: Clip.hardEdge,
        style: MenuStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.white),
          maximumSize: MaterialStateProperty.resolveWith((states) {
            return Size(modalWidth, 400);
          }),
          minimumSize: MaterialStateProperty.resolveWith((states) {
            return Size(modalWidth, 10);
          }),
          padding: MaterialStateProperty.resolveWith((states) {
            return EdgeInsets.zero;
          }),
        ),
        builder: (context, controller, _) {
          getController(controller);

          return SizedBox(
            width: modalWidth,
            child: textBox ??
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () {
                    if (isEnabled) {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        if (menuList.isNotEmpty) {
                          controller.open();
                        }
                      }
                    } else {
                      onTap?.call();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: padding ??
                            const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                        decoration: decoration.copyWith(
                          color: AppColors.white,
                        ),
                        width: modalWidth,
                        child: Row(
                          children: [
                            if (prefixIcon != null) prefixIcon,
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextView(
                                text: value != null && value.trim().isNotEmpty
                                    ? value
                                    : hintValue,
                                style: value != null && value.trim().isNotEmpty
                                    ? 16.txtRegularBlack
                                    : 16.txtRegularBlack,
                              ),
                            ),
                            if (suffixIcon != null) suffixIcon,
                            const SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          );
        },
        menuChildren: menuList,
      );
    },
  );
}
