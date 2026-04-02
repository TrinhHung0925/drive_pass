import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/exam_history.dart';

class LocalService extends GetxService {
  late GetStorage box;

  // Keys
  static const String keyToken = 'TOKEN';
  static const String keyFirstLaunch = 'FIRST_LAUNCH';
  static const String keyExamHistory = 'EXAM_HISTORY';

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

  // Dark Mode
  static const String keyDarkMode = 'DARK_MODE';
  Future<void> setDarkMode(bool isDark) => box.write(keyDarkMode, isDark);
  bool get isDarkMode => box.read<bool>(keyDarkMode) ?? false;

  // User Profile
  static const String keyUserName = 'USER_NAME';
  static const String keyUserPhone = 'USER_PHONE';
  static const String keyUserAvatar = 'USER_AVATAR';
  
  Future<void> setUserName(String name) => box.write(keyUserName, name);
  String get userName => box.read<String>(keyUserName) ?? "Người dùng";
  
  Future<void> setUserPhone(String phone) => box.write(keyUserPhone, phone);
  String get userPhone => box.read<String>(keyUserPhone) ?? "Chưa cập nhật SĐT";

  Future<void> setUserAvatar(String path) => box.write(keyUserAvatar, path);
  String get userAvatar => box.read<String>(keyUserAvatar) ?? "";

  // ── Exam History ───────────────────────────────────────────────────────────

  Future<void> saveExamResult({
    required int examNo,
    required int correct,
    required int total,
    required String timeTaken,
    required String dateTaken,
  }) async {
    final raw = box.read<Map>(keyExamHistory) ?? {};
    final map = Map<String, dynamic>.from(raw);
    map['$examNo'] = {
      'examNo': examNo,
      'correct': correct,
      'total': total,
      'timeTaken': timeTaken,
      'dateTaken': dateTaken,
    };
    await box.write(keyExamHistory, map);
  }

  ExamHistory? getExamHistory(int examNo) {
    final raw = box.read<Map>(keyExamHistory) ?? {};
    final data = raw['$examNo'];
    if (data == null) return null;
    return ExamHistory.fromJson(Map<String, dynamic>.from(data));
  }

  Map<int, ExamHistory> getAllExamHistory() {
    final raw = box.read<Map>(keyExamHistory) ?? {};
    final result = <int, ExamHistory>{};
    for (final entry in raw.entries) {
      final key = int.tryParse(entry.key.toString());
      if (key != null && entry.value != null) {
        result[key] =
            ExamHistory.fromJson(Map<String, dynamic>.from(entry.value));
      }
    }
    return result;
  }

  int get passedExamCount =>
      getAllExamHistory().values.where((h) => h.passed).length;

  int get failedExamCount =>
      getAllExamHistory().values.where((h) => !h.passed).length;

  int get attemptedExamCount => getAllExamHistory().length;

  Future<void> clearExamHistory() => box.remove(keyExamHistory);

  Future<void> clearAll() => box.erase();
}
