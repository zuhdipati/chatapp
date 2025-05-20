import 'dart:developer';

import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/modules/home/chat_room/views/chat_room_view.dart';
import 'package:chatapp/app/widgets/reactions/chat_reactions.dart';
import 'package:chatapp/app/widgets/reactions/hero_dialog_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  var firestore = FirebaseFirestore.instance;

  RxString lastMessage = "".obs;
  RxInt totalUnread = 0.obs;
  List<dynamic> chatReactions = [];
  List<String> listReactions = ['👍', '❤️', '😂', '😮', '😢', '😠'];
  TextEditingController chatC = TextEditingController();
  ScrollController scrollC = ScrollController();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('chat')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProfileFriend(
      String friendEmail) {
    return firestore.collection('users').doc(friendEmail).snapshots();
  }

  void newChat(
      Map<String, dynamic> arguments, String email, String chat) async {
    if (chat.isNotEmpty) {
      var chats = firestore.collection('chats');
      var users = firestore.collection('users');
      var date = DateTime.now().toString();

      await chats.doc(arguments["chat_id"]).collection("chat").add({
        "pengirim": email,
        "penerima": arguments["friend_email"],
        "message": chat,
        "time": date,
        "is_read": false,
        "group_time": DateFormat.yMMMd('en_US').format(DateTime.parse(date)),
        "reactions": []
      });

      chatC.clear();
      scrollC.animateTo(scrollC.position.maxScrollExtent,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);

      await users
          .doc(email)
          .collection('chats')
          .doc(arguments["chat_id"])
          .update({
        "last_time": date,
        "last_message": chat,
      });

      var checkChatsFriend = await users
          .doc(arguments["friend_email"])
          .collection('chats')
          .doc(arguments["chat_id"])
          .get();

      var lastMessageSnapshot = await chats
          .doc(arguments["chat_id"])
          .collection("chat")
          .orderBy("time", descending: true)
          .limit(1)
          .get();

      if (lastMessageSnapshot.docs.isNotEmpty) {
        lastMessage.value = lastMessageSnapshot.docs.first["message"];
      }

      // jika friend sudah pernah dichat..
      if (checkChatsFriend.exists) {
        var checkTotalUnread = await chats
            .doc(arguments["chat_id"])
            .collection('chat')
            .where("is_read", isEqualTo: false)
            .where("pengirim", isEqualTo: email)
            .get();

        totalUnread.value = checkTotalUnread.docs.length;

        await users
            .doc(arguments["friend_email"])
            .collection('chats')
            .doc(arguments["chat_id"])
            .update({
          "last_time": date,
          "total_unread": totalUnread.value,
          "last_message": lastMessage.value,
        });
        log(lastMessage.value.toString());
      } else {
        // jika friend belum pernah dichat..
        await users
            .doc(arguments["friend_email"])
            .collection('chats')
            .doc(arguments["chat_id"])
            .set({
          "connection": email,
          "last_time": date,
          "total_unread": totalUnread.value + 1,
          "last_message": lastMessage.value
        });
        log(lastMessage.value.toString());
      }
      chatC.clear();
    }
  }

  void onTapBubleChat(
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? allData,
      List<String> reactions,
      int index,
      String bubleChatId,
      String chatId) {
    var mainC = MainController.to;
    var chats = FirebaseFirestore.instance.collection('chats');

    Navigator.of(Get.context!).push(
      HeroDialogRoute(
        builder: (context) {
          return ReactionsChatWidget(
            id: allData?[index].id ?? "0",
            messageWidget: BubleChat(
              isSender: allData?[index]["pengirim"] == mainC.currentUser?.email
                  ? true
                  : false,
              message: allData?[index]["message"],
              reactions: reactions,
            ),
            menuItemsWidth: 0.6,
            reactions: listReactions,
            onReactionTap: (reaction) async {
              debugPrint('reaction: $reaction');
              var docChat = await chats
                  .doc(chatId)
                  .collection('chat')
                  .doc(bubleChatId)
                  .get();

              chatReactions = docChat.data()?['reactions'];
              chatReactions.add(reaction);
              await chats
                  .doc(chatId)
                  .collection('chat')
                  .doc(bubleChatId)
                  .update({"reactions": chatReactions});
            },
            onContextMenuTap: (menuItem) {
              debugPrint('menu item: $menuItem');
            },
          );
        },
      ),
    );
  }

  @override
  void onClose() {
    chatC.dispose();
    scrollC.dispose();
    super.onClose();
  }
}
