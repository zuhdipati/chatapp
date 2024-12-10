import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  TextEditingController statusController = TextEditingController();
  final mainC = MainController.to;

  @override
  void onInit() {
    statusController.text = mainC.userData.value.status ?? '';
    super.onInit();
  }

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }

  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    var mainC = MainController.to;
    var users = mainC.firestore.collection('users');

    users.doc(mainC.currentUser?.email).update({
      "status": status,
      "lastSignInTime": mainC.credentialUser?.user?.metadata.lastSignInTime
          ?.toIso8601String(),
      "updatedTime": date
    });

    mainC.userData.update(
      (val) {
        val?.status = status;
        val?.lastSignInTime = mainC
            .credentialUser?.user?.metadata.lastSignInTime
            ?.toIso8601String();
        val?.updatedTime = date;
      },
    );

    Get.back();

    Get.snackbar("Success", "Status Updated");
  }
}
