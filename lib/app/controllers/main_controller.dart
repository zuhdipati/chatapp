import 'dart:developer';

import 'package:chatapp/app/data/models/user_model.dart';
import 'package:chatapp/app/modules/home/views/home_view.dart';
import 'package:chatapp/app/modules/profile/views/profile_view.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/services/utils.dart';
import 'package:chatapp/app/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? currentUser;
  UserCredential? credentialUser;

  var userData = UserModel().obs;

  RxInt tabIndex = 0.obs;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  final List<Widget> navigationPages = [const HomeView(), const ProfileView()];

  @override
  void onInit() async {
    await GetStorage.init();
    await checkAndFetchUser();
    super.onInit();
  }

  Future<void> checkAndFetchUser() async {
    try {
      bool isSignedIn = await googleSignIn.isSignedIn();

      if (isSignedIn) {
        currentUser = await googleSignIn.signInSilently();

        if (currentUser != null) {
          var user = firestore.collection('users');
          final currUser = await user.doc(currentUser?.email).get();
          final currUserData = currUser.data() as Map<String, dynamic>;
          final listChat =
              await user.doc(currentUser?.email).collection('chats').get();

          userData.value = UserModel(
            name: currUserData['name'],
            keyName: currUserData['keyName'],
            email: currUserData['email'],
            photoUrl: currUserData['photoUrl'],
            status: currUserData['status'],
            lastSignInTime: currUserData['lastSignInTime'],
            creationTime: currUserData['creationTime'],
            uid: currUserData['uid'],
            updatedTime: currUserData['updatedTime'],
          );

          if (listChat.docs.isNotEmpty) {
            List<ChatUser> dataListChat = [];
            for (var element in listChat.docs) {
              var dataDocChat = element.data();
              var dataDocChatId = element.id;
              dataListChat.add(ChatUser(
                  connection: dataDocChat["connection"],
                  chatId: dataDocChatId,
                  lastTime: dataDocChat["last_time"],
                  totalUnread: dataDocChat["total_unread"]));
            }
            userData.update(
              (val) {
                val!.chats = dataListChat;
              },
            );
          } else {
            userData.update(
              (val) {
                val!.chats = [];
              },
            );
          }

        }
      } else {
        log("Pengguna belum login.");
      }
    } catch (error) {
      log("Terjadi kesalahan: $error");
    }
  }

  void login() async {
    showLoading();
    try {
      await googleSignIn.signOut();

      currentUser = await googleSignIn.signIn();
      

      final isSignIn = await googleSignIn.isSignedIn();
      if (isSignIn) {
        final googleAuth = await currentUser?.authentication;
        final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        credentialUser =
            await FirebaseAuth.instance.signInWithCredential(credentials);

        // input user ke firestore..
        var user = firestore.collection('users');
        final checkUser = await user.doc(currentUser?.email).get();

        if (checkUser.data() == null) {
          await user.doc(currentUser?.email).set({
            'uid': credentialUser?.user?.uid,
            'name': currentUser?.displayName,
            'keyName': currentUser?.displayName?.substring(0, 1).toUpperCase(),
            'email': currentUser?.email,
            'photoUrl': currentUser?.photoUrl,
            'status': "",
            'creationTime':
                credentialUser?.user?.metadata.creationTime?.toString(),
            'lastSignInTime':
                credentialUser?.user?.metadata.lastSignInTime?.toString(),
            'updatedTime': DateTime.now().toString(),
          });
          user.doc(currentUser?.email).collection("chats");
        } else {
          await user.doc(currentUser?.email).update({
            'lastSignInTime':
                credentialUser?.user?.metadata.lastSignInTime?.toString(),
          });
        }

        checkAndFetchUser();
        hideLoading();

        Utils.setSkipIntro(skip: true);
        Get.offAllNamed(Routes.main);
      } else {
        hideLoading();
        log("GAGAL LOGIN");
      }
    } catch (error) {
      log(error.toString());
    }
  }

  void logout() async {
    await googleSignIn.signOut();
    Get.offAllNamed(Routes.splash);
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
    pageController.jumpToPage(index);
  }
}
