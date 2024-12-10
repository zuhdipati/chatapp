part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const introduction = _Paths.introduction;

  static const main = _Paths.main;

  static const home = main + _Paths.home;
  static const search = home + _Paths.search;
  static const chatRoom = _Paths.chatRoom;

  static const profile = main + _Paths.profile;
  static const updateStatus = profile + _Paths.updateStatus;
  static const changeProfile = profile + _Paths.changeProfile;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/splash';
  static const login = '/login';
  static const introduction = '/introduction';
  
  static const main = '/main';
  
  static const home = '/home';
  static const search = '/search';
  static const chatRoom = '/chat-room';

  static const profile = '/profile';
  static const updateStatus = '/update-status';
  static const changeProfile = '/change-profile';
}
