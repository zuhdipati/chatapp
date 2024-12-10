import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    statusController.dispose();
    super.onClose();
  }

  void updateProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();
    var mainC = MainController.to;
    var users = mainC.firestore.collection('users');

    users.doc(mainC.currentUser?.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignInTime": mainC.credentialUser?.user?.metadata.lastSignInTime
          ?.toIso8601String(),
      "updatedTime": date
    });

    mainC.userData.update(
      (val) {
        val?.name = name;
        val?.keyName = name.substring(0, 1).toUpperCase();
        val?.status = status;
        val?.lastSignInTime = mainC
            .credentialUser?.user?.metadata.lastSignInTime
            ?.toIso8601String();
        val?.updatedTime = date;
      },
    );

    Get.back();

    Get.snackbar("Success", "Profile Updated");
  }
}
