/// Theory exam rules for licence class B (30 questions drawn from the 2025 CSGT bank, CV 2262/CSGT-P5).
class ExamRules {
  static const int questionCount = 30;
  static const int durationMinutes = 20;
  static const int passingScore = 27;

  static bool isPassed({required int correct, required bool criticalFailed}) =>
      !criticalFailed && correct >= passingScore;
}
