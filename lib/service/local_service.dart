import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/exam_history.dart';
import '../model/chat_message.dart';

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

  // ── Wrong Questions ─────────────────────────────────────────────────────────
  // Stores: { "questionId": true, ... }
  static const String keyWrongQuestions = 'WRONG_QUESTIONS';
  // Stores: { "questionId": true, ... } — đã ôn lại
  static const String keyReviewedWrongQuestions = 'REVIEWED_WRONG_QUESTIONS';

  /// Add a wrong question ID
  Future<void> addWrongQuestion(String questionId) async {
    final raw = box.read<Map>(keyWrongQuestions) ?? {};
    final map = Map<String, dynamic>.from(raw);
    if (!map.containsKey(questionId)) {
      map[questionId] = true;
      await box.write(keyWrongQuestions, map);
    }
  }

  /// Remove a wrong question (e.g. user answered correctly in review mode)
  Future<void> removeWrongQuestion(String questionId) async {
    final raw = box.read<Map>(keyWrongQuestions) ?? {};
    final map = Map<String, dynamic>.from(raw);
    map.remove(questionId);
    await box.write(keyWrongQuestions, map);
    // Also remove from reviewed
    final rawR = box.read<Map>(keyReviewedWrongQuestions) ?? {};
    final mapR = Map<String, dynamic>.from(rawR);
    mapR.remove(questionId);
    await box.write(keyReviewedWrongQuestions, mapR);
  }

  /// Mark a wrong question as reviewed
  Future<void> markWrongQuestionReviewed(String questionId) async {
    final raw = box.read<Map>(keyReviewedWrongQuestions) ?? {};
    final map = Map<String, dynamic>.from(raw);
    map[questionId] = true;
    await box.write(keyReviewedWrongQuestions, map);
  }

  /// Get all wrong question IDs
  Set<String> getWrongQuestionIds() {
    final raw = box.read<Map>(keyWrongQuestions) ?? {};
    return Set<String>.from(raw.keys);
  }

  /// Get reviewed wrong question IDs
  Set<String> getReviewedWrongQuestionIds() {
    final raw = box.read<Map>(keyReviewedWrongQuestions) ?? {};
    return Set<String>.from(raw.keys);
  }

  /// Number of wrong questions not yet reviewed
  int get unreviewedWrongCount {
    final all = getWrongQuestionIds();
    final reviewed = getReviewedWrongQuestionIds();
    return all.difference(reviewed).length;
  }

  /// Total wrong questions count
  int get wrongQuestionCount => getWrongQuestionIds().length;

  Future<void> clearWrongQuestions() async {
    await box.remove(keyWrongQuestions);
    await box.remove(keyReviewedWrongQuestions);
  }

  // ── Bookmarked Questions ────────────────────────────────────────────────────
  static const String keyBookmarkedQuestions = 'BOOKMARKED_QUESTIONS';

  Future<void> toggleBookmark(String questionId) async {
    final raw = box.read<Map>(keyBookmarkedQuestions) ?? {};
    final map = Map<String, dynamic>.from(raw);
    if (map.containsKey(questionId)) {
      map.remove(questionId);
    } else {
      map[questionId] = true;
    }
    await box.write(keyBookmarkedQuestions, map);
  }

  bool isBookmarked(String questionId) {
    final raw = box.read<Map>(keyBookmarkedQuestions) ?? {};
    return raw.containsKey(questionId);
  }

  Set<String> getBookmarkedIds() {
    final raw = box.read<Map>(keyBookmarkedQuestions) ?? {};
    return Set<String>.from(raw.keys);
  }

  int get bookmarkedCount => getBookmarkedIds().length;

  // ── AI Chat History ─────────────────────────────────────────────────────────
  static const String keyChatHistory = 'CHAT_HISTORY';

  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final list = messages.map((m) => m.toJson()).toList();
    await box.write(keyChatHistory, list);
  }

  List<ChatMessage> getChatHistory() {
    final raw = box.read<List>(keyChatHistory) ?? [];
    return raw
        .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clearChatHistory() async {
    await box.remove(keyChatHistory);
  }
}
