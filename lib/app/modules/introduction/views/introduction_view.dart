import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Simple and Fun Communication",
          body:
              "Stay connected with friends, family, and colleagues—anytime, anywhere",
          image: SizedBox(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(
                child: Lottie.asset('assets/lottie/main-laptop-duduk.json')),
          ),
        ),
        PageViewModel(
          title: "Your World, Your Conversations",
          body:
              "Chat securely, share freely, and experience seamless messaging like never before.",
          image: SizedBox(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(child: Lottie.asset('assets/lottie/hello.json')),
          ),
        ),
        PageViewModel(
          title: "Connect Beyond Limits",
          body:
              "A smarter way to communicate, collaborate, and create lasting connections.",
          image: SizedBox(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(child: Lottie.asset('assets/lottie/ojek.json')),
          ),
        ),
        PageViewModel(
          title: "Ready to Get Started?",
          body: "Sign in now and explore a world of seamless communication",
          image: SizedBox(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(child: Lottie.asset('assets/lottie/register.json')),
          ),
        ),
      ],
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Text("Next"),
      done: const Text("Login", style: TextStyle(fontWeight: FontWeight.w700)),
      onDone: () {
        Get.offAllNamed(Routes.login);
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    ));
  }
}
