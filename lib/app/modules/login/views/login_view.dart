import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = MainController.to;
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.7,
            height: Get.width * 0.7,
            child: Lottie.asset('assets/lottie/login.json'),
          ),
          SizedBox(height: 100),
          ElevatedButton(onPressed: () {
            controller.login();
          }, child: Text("Login with Google"))
        ],
      ),
    )));
  }
}
