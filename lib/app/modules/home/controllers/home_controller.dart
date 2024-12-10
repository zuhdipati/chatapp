import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection('chats')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendsStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<void> updateReadChat(String chatId, String friendEmail) async {
    var mainC = MainController.to;
    var chats = firestore.collection('chats');
    var users = firestore.collection('users');

    Get.toNamed(Routes.chatRoom, arguments: {
      "chat_id": chatId,
      "friend_email": friendEmail,
    });

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
