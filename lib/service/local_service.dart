import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalService extends GetxService {
  late GetStorage box;

  // Keys
  static const String keyToken = 'TOKEN';
  static const String keyFirstLaunch = 'FIRST_LAUNCH';

  Future<LocalService> init() async {
    await GetStorage.init();
    box = GetStorage();
    return this;
  }
  
  // Token Management
  Future<void> saveToken(String token) => box.write(keyToken, token);
  String? get token => box.read<String>(keyToken);
  bool get hasToken => token != null && token!.isNotEmpty;
  Future<void> removeToken() => box.remove(keyToken);

  // App Config
  Future<void> setFirstLaunch(bool isFirst) => box.write(keyFirstLaunch, isFirst);
  bool get isFirstLaunch => box.read<bool>(keyFirstLaunch) ?? true;

  Future<void> clearAll() => box.erase();
}
