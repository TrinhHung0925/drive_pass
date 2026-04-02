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

  static const String keyExamHistoryAll = 'EXAM_HISTORY_ALL';

  Future<void> saveExamResult({
    required int examNo,
    required int correct,
    required int total,
    required String timeTaken,
    required String dateTaken,
  }) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final record = {
      'examNo': examNo,
      'correct': correct,
      'total': total,
      'timeTaken': timeTaken,
      'dateTaken': dateTaken,
      'timestamp': ts,
    };

    // ── 1. Per-exam latest (for exam list screen) ──
    final raw = box.read<Map>(keyExamHistory) ?? {};
    final map = Map<String, dynamic>.from(raw);
    map['$examNo'] = record;
    await box.write(keyExamHistory, map);

    // ── 2. Full history list (append, never overwrite) ──
    final rawList = box.read<List>(keyExamHistoryAll) ?? [];
    final list = List<dynamic>.from(rawList);
    list.add(record);
    await box.write(keyExamHistoryAll, list);
  }

  ExamHistory? getExamHistory(int examNo) {
    final raw = box.read<Map>(keyExamHistory) ?? {};
    final data = raw['$examNo'];
    if (data == null) return null;
    return ExamHistory.fromJson(Map<String, dynamic>.from(data));
  }

  /// Latest result per exam (used by ExamController / exam list)
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

  /// All attempts ever (used by History screen), newest first
  List<ExamHistory> getAllExamHistoryRecords() {
    final rawList = box.read<List>(keyExamHistoryAll) ?? [];
    final records = rawList
        .map((e) => ExamHistory.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  int get passedExamCount =>
      getAllExamHistory().values.where((h) => h.passed).length;

  int get failedExamCount =>
      getAllExamHistory().values.where((h) => !h.passed).length;

  int get attemptedExamCount => getAllExamHistory().length;

  Future<void> clearExamHistory() async {
    await box.remove(keyExamHistory);
    await box.remove(keyExamHistoryAll);
  }

  Future<void> clearAll() => box.erase();

  // ── Theory Progress ────────────────────────────────────────────────────────
  // Stores per-category: { "categoryKey": ["qId1", "qId2", ...] }
  static const String keyTheoryProgress = 'THEORY_PROGRESS';

  /// Mark a question as done for a specific category
  Future<void> markTheoryQuestionDone(String categoryKey, String questionId) async {
    final raw = box.read<Map>(keyTheoryProgress) ?? {};
    final map = Map<String, dynamic>.from(raw);
    final List<dynamic> ids = List<dynamic>.from(map[categoryKey] ?? []);
    if (!ids.contains(questionId)) {
      ids.add(questionId);
      map[categoryKey] = ids;
      await box.write(keyTheoryProgress, map);
    }
  }

  /// Get set of question IDs done for a category
  Set<String> getTheoryDoneIds(String categoryKey) {
    final raw = box.read<Map>(keyTheoryProgress) ?? {};
    final ids = raw[categoryKey];
    if (ids == null) return {};
    return Set<String>.from(ids);
  }

  /// Get unique question IDs across ALL categories (for overall progress)
  Set<String> getTheoryAllUniqueIds() {
    final raw = box.read<Map>(keyTheoryProgress) ?? {};
    final all = <String>{};
    for (final entry in raw.values) {
      if (entry is List) {
        all.addAll(entry.cast<String>());
      }
    }
    return all;
  }

  Future<void> clearTheoryProgress() async {
    await box.remove(keyTheoryProgress);
  }
}
