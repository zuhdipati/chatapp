import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/add_friend_controller.dart';

class SearchView extends GetView<AddFriendController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    final mainC = MainController.to;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search New Chat'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller.searchController,
                onChanged: (value) =>
                    controller.searchUser(value, mainC.currentUser!.email),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => controller.tempQuery.isEmpty
                ? SizedBox(
                    height: Get.height * 0.7,
                    width: Get.width * 0.7,
                    child: Lottie.asset('assets/lottie/empty.json'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        controller.tempQuery.length,
                        (index) {
                          return ListTile(
                            onTap: () => controller.addNewConnection(
                                controller.tempQuery[index]["email"]),
                            leading: SizedBox(
                                height: 60,
                                width: 60,
                                child: CachedNetworkImage(
                                    imageUrl: controller.tempQuery[index]
                                        ["photoUrl"],
                                    placeholder: (context, url) {
                                      return CircularProgressIndicator
                                          .adaptive();
                                    },
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(200)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(200)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/logo/noimage.png')),
                                          ),
                                        ))),
                            title: Text(
                              controller.tempQuery[index]["name"],
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              controller.tempQuery[index]["email"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            trailing: Chip(label: Text("Message")),
                          );
                        },
                      ),
                    ),
                  ))
          ],
        ));
  }
}
