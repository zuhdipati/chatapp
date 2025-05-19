import 'dart:async';

import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/widgets/reactions/stacked_reactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    var mainC = MainController.to;
    var chatId = Get.arguments["chat_id"];
    var friendEmail = Get.arguments["friend_email"];
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 40,
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: Get.back,
                  icon: Icon(Icons.arrow_back_ios_new)),
            ),
            title: StreamBuilder(
              stream: controller.streamProfileFriend(friendEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var data = snapshot.data!;
                  return Row(
                    children: [
                      CircleAvatar(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Visibility(
                              visible: data["photoUrl"] != null,
                              replacement:
                                  Image.asset('assets/logo/noimage.png'),
                              child: Image.network(
                                data["photoUrl"],
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data["name"], style: TextStyle(fontSize: 17)),
                          Visibility(
                            visible: data["status"] != "",
                            child: Text(
                              data["status"],
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              },
            )),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamChats(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var allData = snapshot.data?.docs;
                  Timer(
                    Duration(seconds: 0),
                    () {
                      controller.scrollC.animateTo(
                          controller.scrollC.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      controller: controller.scrollC,
                      itemCount: allData?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: allData?[index]["pengirim"] ==
                                  mainC.currentUser?.email
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: index == 0 ||
                                    allData?[index]['group_time'] !=
                                        allData?[index - 1]['group_time'],
                                child: Center(
                                    child:
                                        Text(allData?[index]['group_time']))),
                            GestureDetector(
                                onLongPress: () {
                                  controller.onTapBubleChat(
                                      allData,
                                      allData?[index]['reactions'].cast<String>(),
                                      index,
                                      allData![index].id,
                                      Get.arguments["chat_id"]);
                                },
                                child: Hero(
                                    tag: allData?[index].id ?? "0",
                                    child: BubleChat(
                                      isSender: allData?[index]["pengirim"] ==
                                              mainC.currentUser?.email
                                          ? true
                                          : false,
                                      message: allData?[index]["message"],
                                      time: DateFormat('hh.mm a').format(
                                          DateTime.parse(
                                              allData?[index]["time"])),
                                      reactions: allData?[index]['reactions'].cast<String>(),
                                    )))
                          ],
                        );
                      },
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
            )),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(15),
              height: 100,
              width: Get.width,
              child: Row(
                children: [
                  Icon(Icons.add, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                    controller: controller.chatC,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        hintText: 'New Chat',
                        // hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15))),
                  )),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      controller.newChat(Get.arguments,
                          mainC.currentUser!.email, controller.chatC.text);
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class BubleChat extends GetView<ChatRoomController> {
  const BubleChat({
    super.key,
    required this.isSender,
    required this.message,
    required this.reactions,
    this.time,
  });

  final bool isSender;
  final String message;
  final List<String> reactions;
  final String? time;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: isSender
                            ? BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15))
                            : BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Text(
                        message,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      time ?? '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none),
                    ),
                    SizedBox(height: 5)
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: StackedReactions(
                    size: 15,
                    reactions: reactions,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
