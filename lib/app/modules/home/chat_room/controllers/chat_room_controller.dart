import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var firestore = FirebaseFirestore.instance;

  RxInt totalUnread = 0.obs;
  List<String> chatReactions = [];
  List<String> reactions = ['👍', '❤️', '😂', '😮', '😢', '😠'];
  TextEditingController chatController = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('chat')
        .orderBy('time')
        .snapshots();
  }

  void newChat(
      Map<String, dynamic> arguments, String email, String chat) async {
    var chats = firestore.collection('chats');
    var users = firestore.collection('users');
    var date = DateTime.now().toString();

     await chats.doc(arguments["chat_id"]).collection("chat").add({
      "pengirim": email,
      "penerima": arguments["friend_email"],
      "message": chat,
      "time": date,
      "is_read": false,
    });

    await users
        .doc(email)
        .collection('chats')
        .doc(arguments["chat_id"])
        .update({
      "last_time": date,
    });

    var checkChatsFriend = await users
        .doc(arguments["friend_email"])
        .collection('chats')
        .doc(arguments["chat_id"])
        .get();

    if (checkChatsFriend.exists) {
      // cek total unread friend..
      var checkTotalUnread = await chats
          .doc(arguments["chat_id"])
          .collection('chat')
          .where("is_read", isEqualTo: false)
          .where("pengirim", isEqualTo: email)
          .get();

      totalUnread.value = checkTotalUnread.docs.length;

      // await users
      //     .doc(arguments["friend_email"])
      //     .collection('chats')
      //     .doc(arguments["chat_id"])
      //     .get()
      //     .then(
      //       (value) =>
      //           totalUnread.value = (value.data()?["total_unread"] as int) + 1,
      //     );

      await users
          .doc(arguments["friend_email"])
          .collection('chats')
          .doc(arguments["chat_id"])
          .update({
        "last_time": date,
        "total_unread": totalUnread.value,
      });
    } else {
      await users
          .doc(arguments["friend_email"])
          .collection('chats')
          .doc(arguments["chat_id"])
          .set({
        "connection": email,
        "last_time": date,
        "total_unread": totalUnread.value + 1
      });
    }
  }
}
