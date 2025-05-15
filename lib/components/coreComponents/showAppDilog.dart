import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:question_app/components/coreComponents/AppButton.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/size.dart';

Future<bool?> showAppDialog({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  required String confirmLabel,
  required String cancelLabel,
  bool barrierDismissible = true,
}) async {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: width * 0.1),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: height * 0.02),
                  TextView(
                    text: title,
                    style: 24.txtBoldBlack,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.02),
                  Divider(color: AppColors.Grey, thickness: 1, height: 1),
                  SizedBox(height: height * 0.02),
                  TextView(
                    text: message,
                    textAlign: TextAlign.center,
                    style: 16.txtRegularBlack,
                    margin: EdgeInsets.only(top: height * 0.02),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: height * 0.07,
                        child: AppButton(
                          radius: 25.sdp,
                          label: cancelLabel,
                          labelStyle: 14.txtBoldWhite,
                          buttonColor: AppColors.btnColor,
                          onTap: () {
                            if (onCancel != null) onCancel();
                            Navigator.of(context).pop(true);
                          },
                          isFilledButton: false,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Flexible(
                      child: SizedBox(
                        height: height * 0.07,
                        child: AppButton(
                          radius: 25.sdp,
                          label: confirmLabel,
                          labelStyle: 14.txtBoldWhite,
                          buttonColor: AppColors.btnColor,
                          onTap: () {
                            if (onConfirm != null) onConfirm();
                            Navigator.of(context).pop(true);
                          },
                          isFilledButton: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
            ],
          ),
        ],
      );
    },
  );
}
