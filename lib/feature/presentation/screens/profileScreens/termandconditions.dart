// import 'package:flutter/material.dart';
// import 'package:sep/components/styles/textStyles.dart';
// import 'package:sep/components/coreComponents/TextView.dart';
// import 'package:sep/components/styles/appColors.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:sep/feature/data/repository/iTempRepository.dart';
// import 'package:sep/feature/domain/respository/templateRepository.dart';
// import 'package:sep/utils/extensions/extensions.dart';
//
// import '../../../../data/models/dataModels/responseDataModel.dart';
// import '../../../../data/models/dataModels/termsConditionModel.dart';
// import '../../../../data/repository/iAuthRepository.dart';
//
// class Termandconditions extends StatefulWidget {
//   const Termandconditions({super.key});
//
//   @override
//   _TermandconditionsState createState() => _TermandconditionsState();
// }
//
// class _TermandconditionsState extends State<Termandconditions> {
//   late Future<ResponseData<TermsConditionModel>> _termsFuture;
//   final TempRepository tempRepository = ITempRepository();
//   String? description;
//
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
//           text: 'Terms of Use',
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

import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/app_strings.dart';


class Termandconditions extends StatefulWidget {
  const Termandconditions({super.key});

  @override
  _TermandconditionsState createState() => _TermandconditionsState();
}

class _TermandconditionsState extends State<Termandconditions> {
  // late final WebViewController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..loadRequest(Uri.parse("https://septerms.vercel.app/"));
  // }

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
          title: Text("Terms & Conditions"),
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
        child: TextView(text: '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      ''',
        textAlign: TextAlign.start,
          style: 15.txtMediumWhite,
        ),
      )

      // WebViewWidget(controller: _controller),
    );
  }
}
