import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  const ChangeProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final mainC = MainController.to;
    controller.emailController.text = mainC.userData.value.email ?? '';
    controller.nameController.text = mainC.userData.value.name ?? '';
    controller.statusController.text = mainC.userData.value.status ?? '';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change Profile'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(height: 30),
              AvatarGlow(
                startDelay: const Duration(milliseconds: 1000),
                glowColor: Colors.black,
                glowRadiusFactor: 0.13,
                glowShape: BoxShape.circle,
                curve: Curves.fastOutSlowIn,
                child: SizedBox(
                  height: 175,
                  child: Obx(() => Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 90,
                                  backgroundImage: controller
                                          .pickedImage.value.path.isNotEmpty
                                      ? FileImage(
                                          File(controller
                                              .pickedImage.value.path),
                                        )
                                      : mainC.userData.value.photoUrl ==
                                              "noImage"
                                          ? AssetImage(
                                              'assets/logo/noimage.png')
                                          : NetworkImage(
                                              mainC.userData.value.photoUrl ??
                                                  ''),
                                ),
                                Visibility(
                                  visible: controller
                                      .pickedImage.value.path.isNotEmpty,
                                  child: Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => controller.removeImage(),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () => controller.pickPicture(),
                  child: Center(
                      child: Text(
                    "Change profile picture",
                    style: TextStyle(color: Colors.deepPurple),
                  ))),
              SizedBox(height: 15),
              TextField(
                controller: controller.emailController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controller.nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Nama',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controller.statusController,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  controller.updateProfile(controller.nameController.text,
                      controller.statusController.text);
                },
                decoration: InputDecoration(
                  hintText: 'Status',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        
                        controller.updateProfile(controller.nameController.text,
                            controller.statusController.text);
                      },
                      child: Text("Update")))
            ],
          ),
        ));
  }
}
