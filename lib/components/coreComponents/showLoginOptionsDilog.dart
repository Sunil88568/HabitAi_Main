import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:question_app/components/coreComponents/AppButton.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/size.dart';

Future<String?> showLoginOptionsDialog({
  required BuildContext context,
}) {
  final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: width * 0.1),
        contentPadding: EdgeInsets.symmetric(vertical: height * 0.02),
        title: Column(
          children: [
            Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Please choose how you want to continue:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          _buildDialogButton(context, 'Login', 'login'),
          _buildDialogButton(context, 'Sign Up', 'signup'),
          _buildDialogButton(context, 'Continue as Guest', 'guest'),
        ],
      );
    },
  );
}

Widget _buildDialogButton(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {
        Navigator.of(context).pop(value); // Return selected option
      },
      child: Text(label),
    ),
  );
}
