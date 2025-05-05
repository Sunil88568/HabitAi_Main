import 'package:question_app/services/storage/preferences.dart';
import 'package:question_app/utils/extensions/loader_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/styles/ui_theme.dart';
import 'feature/presentation/controller/profile_user_controller.dart';
import 'feature/presentation/screens/splash.dart';

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.createInstance();
  Get.put(ProfileUserController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderUtils.loaderInit(
      child: GetMaterialApp(
        navigatorKey: navState,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<dynamic>>[
            lightUiTheme,
          ],
        ),
        home:  Splash(),
      ),
    );
  }
}
