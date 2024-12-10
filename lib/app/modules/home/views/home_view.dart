import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/widgets/user_list_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    var mainC = MainController.to;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mengobrol',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.search);
                  },
                  icon: Icon(CupertinoIcons.search, size: 25),
                )),
          ],
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 70,
                                width: 70,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                )),
                            SizedBox(height: 5),
                            Text("Your Story")
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      ...List.generate(
                        7,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.all(3),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade100,
                                    )),
                                SizedBox(height: 5),
                                Text("Nama")
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chats",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Icon(Icons.more_horiz)
                  ],
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatsStream(mainC.currentUser!.email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var allChats = snapshot.data?.docs;
                    return Visibility(
                      visible: allChats != null,
                      replacement: Container(),
                      child: Column(
                        children: List.generate(
                          allChats?.length ?? 0,
                          (index) {
                            return StreamBuilder(
                              stream: controller.friendsStream(
                                  allChats?[index]["connection"]),
                              builder: (context, snapshot2) {
                                if (snapshot2.connectionState ==
                                    ConnectionState.active) {
                                  var data = snapshot2.data?.data();
                                  return InkWell(
                                    onTap: () {
                                      controller.updateReadChat(
                                        "${allChats?[index].id}",
                                        allChats?[index]["connection"],
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: UserListWidget(
                                        name: data!['name'],
                                        imageUrl: data["photoUrl"],
                                        subText: data['status'],
                                        incomingChat:
                                            "${allChats?[index]["total_unread"]}",
                                        time:
                                            "${allChats?[index]["last_time"]}",
                                      ),
                                    ),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
              SizedBox(height: 20)
            ],
          ),
        ));
  }
}
