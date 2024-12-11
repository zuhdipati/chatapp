import 'dart:developer';

import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  final storageFirebase = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  Rx<XFile> pickedImage = XFile('').obs;

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    statusController.dispose();
    pickedImage.value = XFile('');
    super.onClose();
  }

  void pickPicture() async {
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = image;
        log(pickedImage.value.path.toString());
        Get.snackbar("Warning",
            "Firebase Storage is now paid, so changing the profile picture is currently not possible");
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  void removeImage() {
    pickedImage.value = XFile('');
  }

  void updateProfile(String name, String status) async {
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

    Get.closeAllSnackbars();

    Navigator.of(Get.context!).pop();

    Get.snackbar("Success", "Profile Updated");
  }
}
