import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final mainC = MainController.to;
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () async {
              MainController.to.logout();
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 30),
                AvatarGlow(
                  startDelay: const Duration(milliseconds: 1000),
                  glowColor: Colors.black,
                  glowRadiusFactor: 0.13,
                  glowShape: BoxShape.circle,
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox(
                      width: 175,
                      height: 175,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: mainC.userData.value.photoUrl == "noImage"
                              ? Image.asset('assets/logo/noimage.png')
                              : Obx(() => Image.network(
                                  mainC.userData.value.photoUrl ?? '')))),
                ),
                SizedBox(height: 15),
                Obx(() => Text(mainC.userData.value.name ?? '',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600))),
                Text(mainC.userData.value.email ?? '',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => Get.toNamed(Routes.updateStatus),
                    leading: Icon(Icons.note_add_outlined),
                    title: Text("Update Status"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.changeProfile),
                    leading: Icon(Icons.person),
                    title: Text("Change Profile"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.dark_mode),
                    title: Text("Change Theme"),
                    trailing: Icon(Icons.dark_mode),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Text("Chat App"),
                  Text("v.1.0"),
                ],
              ),
            )
          ],
        ));
  }
}
