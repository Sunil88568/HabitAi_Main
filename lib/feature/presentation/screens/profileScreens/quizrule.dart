// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sep/components/styles/textStyles.dart';
// import 'package:sep/utils/extensions/contextExtensions.dart';
// import 'package:sep/utils/extensions/extensions.dart';
//
// import '../../../../../components/coreComponents/TextView.dart';
//
// import '../../../../../components/styles/appColors.dart';
//
// import '../../../../data/models/dataModels/responseDataModel.dart';
// import '../../../../data/models/dataModels/termsConditionModel.dart';
// import '../../../../data/repository/iTempRepository.dart';
// import '../../../../domain/respository/templateRepository.dart';
// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({super.key});
//
//   @override
//   _PrivacyPolicyState createState() => _PrivacyPolicyState();
// }
//
// class _PrivacyPolicyState extends State<PrivacyPolicy> {
//   late Future<ResponseData<TermsConditionModel>> _termsFuture;
//   final TempRepository tempRepository = ITempRepository();
//
//   var selectedImagePath = "".obs;
//
//   String? description;
//   Future<ResponseData<TermsConditionModel>> _fetchTerms() async {
//     return await tempRepository.getTermsAndCondations();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _termsFuture = _fetchTerms();
//     _termsFuture.applyLoader.then((value) {
//       setState(() {
//         description = value.data!.data!.description;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         centerTitle: true,
//         title: TextView(
//           text: 'Privacy Policy',
//           style: 20.txtBoldWhite,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new,
//               color: AppColors.white, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 22.0),
//         child: TextView(
//           text: description.toString() != "null" ? description.toString() : " ",
//           style: 14.txtRegularWhite,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../components/coreComponents/TextView.dart';
import '../../../../components/styles/appColors.dart';


class QuizRule extends StatefulWidget {
  const QuizRule({super.key});

  @override
  _QuizRuleState createState() => _QuizRuleState();
}

class _QuizRuleState extends State<QuizRule> {
   late final WebViewController controller;

   @override
   void initState() {
     openWebView();
     super.initState();
   }

   void openWebView() {
     controller = WebViewController()
       ..setNavigationDelegate(
         NavigationDelegate(
           onPageStarted: (String url) {
             print("Page started loading: $url");
           },
           onPageFinished: (String url) {
             print("Page finished loading: $url");
           },

         ),
       )

       ..setJavaScriptMode(JavaScriptMode.unrestricted)
       ..loadRequest(Uri.parse("https://dhan-iq-rule.vercel.app/")); // Load dynamic URL
   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text("Quiz Rules"),
          titleTextStyle: 24.txtBoldWhite,
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
            ),
          ),
        ),
        body: Padding(
          padding: 15.vertical + 15.horizontal,
          child: WebViewWidget(controller: controller)
        )

      // WebViewWidget(controller: _controller),
    );
  }
}
