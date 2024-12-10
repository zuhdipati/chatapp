import 'package:get/get.dart';

import '../index.dart';
import '../modules/profile/change_profile/bindings/change_profile_binding.dart';
import '../modules/profile/change_profile/views/change_profile_view.dart';
import '../modules/home/chat_room/bindings/chat_room_binding.dart';
import '../modules/home/chat_room/views/chat_room_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/home/add_friends/bindings/add_friend_binding.dart';
import '../modules/home/add_friends/views/add_friend_view.dart';
import '../modules/profile/update_status/bindings/update_status_binding.dart';
import '../modules/profile/update_status/views/update_status_view.dart';
import '../widgets/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.introduction,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(name: _Paths.main, page: () => const MainNavigation(), children: [
      GetPage(
          name: _Paths.home,
          page: () => const HomeView(),
          children: [
            GetPage(
              name: _Paths.search,
              page: () => const SearchView(),
              binding: AddFriendBinding(),
            ),
          ]),
      GetPage(
          name: _Paths.profile,
          page: () => const ProfileView(),
          binding: ProfileBinding(),
          children: [
            GetPage(
              name: _Paths.updateStatus,
              page: () => const UpdateStatusView(),
              binding: UpdateStatusBinding(),
            ),
            GetPage(
              name: _Paths.changeProfile,
              page: () => const ChangeProfileView(),
              binding: ChangeProfileBinding(),
            ),
          ]),
    ]),
    GetPage(
      name: _Paths.chatRoom,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
  ];
}
