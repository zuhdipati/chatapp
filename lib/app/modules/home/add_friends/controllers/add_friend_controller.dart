import 'dart:developer';

import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/data/models/user_model.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendController extends GetxController {
  var mainC = MainController.to;
  var firestore = FirebaseFirestore.instance;
  var date = DateTime.now().toString();
  var firstQuery = [].obs;
  var tempQuery = [].obs;

  TextEditingController searchController = TextEditingController();

  void searchUser(String query, String email) async {
    if (query.isEmpty) {
      firstQuery.value = [];
      tempQuery.value = [];
    } else {
      var capitalized =
          query.substring(0, 1).toUpperCase() + query.substring(1);

      if (firstQuery.isEmpty && query.length == 1) {
        CollectionReference users = firestore.collection('users');
        final keyNameResult = await users
            .where('keyName', isEqualTo: query.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();

        if (keyNameResult.docs.isNotEmpty) {
          for (var i = 0; i < keyNameResult.docs.length; i++) {
            final data = keyNameResult.docs[i].data() as Map<String, dynamic>;
            firstQuery.add(data);
          }
          debugPrint(firstQuery.toString());
        } else {
          debugPrint("NO DATA");
        }
      }
      if (firstQuery.isNotEmpty) {
        tempQuery.value = [];
        for (var element in firstQuery) {
          if (element['name'].startsWith(capitalized)) {
            tempQuery.add(element);
            log(firstQuery.toString());
          }
        }
      }
    }
    firstQuery.refresh();
    tempQuery.refresh();
  }

  void addNewConnection(String friendEmail) async {
    var chats = firestore.collection('chats');
    var users = firestore.collection('users');
    String chatId = '';
    bool newConnection = false;

    var docUserChat =
        await users.doc(mainC.currentUser?.email).collection('chats').get();

    if (docUserChat.docs.isNotEmpty) {
      final checkConnection = await users
          .doc(mainC.currentUser?.email)
          .collection('chats')
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        chatId = checkConnection.docs[0].id;
        newConnection = false;
      } else {
        newConnection = true;
      }
    } else {
      newConnection = true;
    }

    if (newConnection) {
      final chatDocs = await chats.where('connections', whereIn: [
        [mainC.currentUser?.email, friendEmail],
        [friendEmail, mainC.currentUser?.email]
      ]).get();

      if (chatDocs.docs.isNotEmpty) {
        final chatData = chatDocs.docs[0].data();
        final chatDataId = chatDocs.docs[0].id;

        final listChat =
            await users.doc(mainC.currentUser?.email).collection('chats').get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> dataListChat = [];
          for (var element in listChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChat.add(ChatUser(
              connection: dataDocChat["connection"],
              chatId: dataDocChatId,
              lastTime: chatData["last_time"],
              totalUnread: dataDocChat["total_unread"],
              lastMessage: dataDocChat["last_message"],
            ));
          }
          mainC.userData.update(
            (val) {
              val!.chats = dataListChat;
            },
          );
        } else {
          mainC.userData.update(
            (val) {
              val!.chats = [];
            },
          );
        }

        chatId = chatDataId;

        mainC.userData.refresh();
      } else {
        // add field "connections" ke collection chats
        final newChatDoc = await chats.add({
          "connections": [mainC.currentUser!.email, friendEmail],
        });

        chats.doc(newChatDoc.id).collection('chat');

        // Ambil chat terakhir dari subcollection 'chat'
        String lastMessage = "";
        final lastChatSnapshot = await chats
            .doc(newChatDoc.id)
            .collection("chat")
            .orderBy("time", descending: true)
            .limit(1)
            .get();

        if (lastChatSnapshot.docs.isNotEmpty) {
          lastMessage = lastChatSnapshot.docs.first["message"];
        } else {
          lastMessage = ""; 
        }

        // add collection chats ke collection users
        await users
            .doc(mainC.currentUser!.email)
            .collection('chats')
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "last_time": date,
          "total_unread": 0,
          "last_message": lastMessage
        });

        // masukkan chat dari collection user ke model UserChat
        final listChat =
            await users.doc(mainC.currentUser?.email).collection('chats').get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> dataListChat = [];
          for (var element in listChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            debugPrint(dataDocChat.toString());
            dataListChat.add(ChatUser(
              connection: dataDocChat["connection"],
              chatId: dataDocChatId,
              lastTime: dataDocChat["last_time"],
              totalUnread: dataDocChat["total_unread"],
              lastMessage: dataDocChat["last_message"],
            ));
          }
          mainC.userData.update(
            (val) {
              val!.chats = dataListChat;
            },
          );
        } else {
          mainC.userData.update(
            (val) {
              val!.chats = [];
            },
          );
        }

        chatId = newChatDoc.id;

        mainC.userData.refresh();
      }
    }

    await updateReadChat(chatId, friendEmail);

    Get.toNamed(Routes.chatRoom,
        arguments: {"chat_id": chatId, "friend_email": friendEmail});
  }

  Future<void> updateReadChat(String chatId, String friendEmail) async {
    var mainC = MainController.to;
    var chats = firestore.collection('chats');
    var users = firestore.collection('users');

    var setReadChat = await chats
        .doc(chatId)
        .collection('chat')
        .where('is_read', isEqualTo: false)
        .where('pengirim', isEqualTo: friendEmail)
        .get();

    for (var element in setReadChat.docs) {
      await chats
          .doc(chatId)
          .collection('chat')
          .doc(element.id)
          .update({"is_read": true});
    }

    await users
        .doc(mainC.currentUser?.email)
        .collection('chats')
        .doc(chatId)
        .update({"total_unread": 0});
  }
}
