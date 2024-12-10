import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/widgets/reactions/chat_reactions.dart';
import 'package:chatapp/app/widgets/reactions/hero_dialog_route.dart';
import 'package:chatapp/app/widgets/reactions/stacked_reactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    var mainC = MainController.to;
    var chatId = Get.arguments["chat_id"];
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
          title: Row(
            children: [
              CircleAvatar(),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nama Orang', style: TextStyle(fontSize: 17)),
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamChats(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var allData = snapshot.data?.docs;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: allData?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onLongPress: () {
                              Navigator.of(context).push(
                                HeroDialogRoute(
                                  builder: (context) {
                                    return ReactionsChatWidget(
                                      id: allData?[index].id ?? "0",
                                      messageWidget: BubleChat(
                                        isSender: allData?[index]["pengirim"] ==
                                                mainC.currentUser?.email
                                            ? true
                                            : false,
                                        message: allData?[index]["message"],
                                      ),
                                      menuItemsWidth: 0.6,
                                      reactions: controller.reactions,
                                      onReactionTap: (reaction) {
                                        debugPrint('reaction: $reaction');
                                        controller.chatReactions.add(reaction);
                                      },
                                      onContextMenuTap: (menuItem) {
                                        debugPrint('menu item: $menuItem');
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            child: Hero(
                                tag: allData?[index].id ?? "0",
                                child: BubleChat(
                                  isSender: allData?[index]["pengirim"] ==
                                          mainC.currentUser?.email
                                      ? true
                                      : false,
                                  message: allData?[index]["message"],
                                )));
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
                    controller: controller.chatController,
                    decoration: InputDecoration(
                        hintText: 'New Chat',
                        hintStyle: TextStyle(color: Colors.grey),
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
                      controller.newChat(
                          Get.arguments,
                          mainC.currentUser!.email,
                          controller.chatController.text);
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
  });

  final bool isSender;
  final String message;

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
                    SizedBox(height: 10)
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: StackedReactions(
                    size: 15,
                    reactions: controller.chatReactions,
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
