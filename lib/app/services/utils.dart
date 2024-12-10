import 'package:get_storage/get_storage.dart';

class Utils {
  static final _storage = GetStorage();

  static Future<bool?> getSkipIntro() async {
    return _storage.read('skip_intro');
  }

  static Future<void> setSkipIntro({skip = false}) async {
    await _storage.write('skip_intro', skip);
  }

  static Future<String?> getToken() async {
    return _storage.read<String>('token');
  }

  static Future<void> setToken(String? accessToken) async {
    if (accessToken != null) {
      await _storage.write('token', accessToken);
    }
  }

  static Future<void> removeToken() async {
    await _storage.remove('token');
  }
}
