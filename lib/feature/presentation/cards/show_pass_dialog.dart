import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/size.dart';

import '../../../components/coreComponents/ImageView.dart';
import '../../../components/coreComponents/TextView.dart';
import '../../../components/styles/appColors.dart';
import '../../../components/styles/appImages.dart';
import '../../../components/styles/app_strings.dart';

class PasswordChangedDialog extends StatelessWidget {
  const PasswordChangedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: 20.all,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageView(
              url: AppImages.tickImg,
              width: 150,
              height: 200,
            ),
            TextView(
              text: AppStrings.passwordChanged,
              textAlign: TextAlign.center,
              style: 24.txtBoldBlack,
            ),
          ],
        ),
      ),
    );
  }
}
