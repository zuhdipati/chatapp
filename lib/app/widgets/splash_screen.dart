import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      final mainController = Get.find<MainController>();
      final isLogin = await mainController.googleSignIn.isSignedIn();
      final isSkipIntro = await Utils.getSkipIntro();

      if (isSkipIntro ?? false) {
        Get.offNamed(isLogin ? Routes.main : Routes.login);
      } else {
        Get.offNamed(Routes.introduction);
      }
    });

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          height: 350,
          child: Lottie.asset('assets/lottie/hello.json'),
        ),
      ),
    );
  }
}
