import 'package:flutter/material.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';

import '../styles/appColors.dart';

appBSheet(BuildContext context, Widget child, {Color? barrierColor}) {
  showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: barrierColor,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(
          // AppFonts.s30
            30), topLeft: Radius.circular(
          // AppFonts.s30
            30)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
              top:
              // AppFonts.s20
              20),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.bottomSafeArea +
                MediaQuery.of(context).viewInsets.bottom
            ),
            child: child,
          ),
        );




        //   DraggableScrollableSheet(
        //   expand: false,
        //   builder: (context, scrollController) {
        //     return SingleChildScrollView(
        //       controller: scrollController,
        //       child: Padding(
        //         padding: const EdgeInsets.only(
        //             top:
        //             // AppFonts.s20
        //             20),
        //         child: Padding(
        //           padding: EdgeInsets.only(bottom: context.bottomSafeArea),
        //           child: child,
        //         ),
        //       ),
        //     );
        //   },
        // )



            ;
      });
}
