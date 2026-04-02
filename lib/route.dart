import 'package:flutter/material.dart';
import 'screen/exam_result/exam_result_view.dart';
import 'package:get/get.dart';
import 'screen/splash/splash_view.dart';
import 'screen/home/home_view.dart';
import 'screen/setting/setting_view.dart';
import 'screen/exam/exam_view.dart';
import 'screen/history/history_view.dart';
import 'screen/home_tap/home_tap_view.dart';
import 'screen/traffic_sign/traffic_sign_view.dart';
import 'screen/edit_profile/edit_profile_view.dart';
import 'screen/exam_detail/exam_detail_view.dart';
import 'screen/exam_tips/exam_tips_view.dart';
import 'screen/theory/theory_view.dart';
import 'screen/critical_questions/critical_questions_view.dart';
import 'screen/traffic_sign_detail/traffic_sign_detail_view.dart';
import 'screen/intro/intro_view.dart';
import 'screen/exam_explanation/exam_explanation_view.dart';
import 'screen/theory_detail/theory_detail_view.dart';
import 'screen/wrong_questions/wrong_questions_view.dart';
import 'screen/bookmarked_questions/bookmarked_questions_view.dart';
import 'screen/statistics/statistics_view.dart';
import 'screen/violations/violations_view.dart';
import 'screen/random_practice/random_practice_view.dart';
import 'screen/search_questions/search_questions_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  GetPageRoute page(
    RouteSettings settings,
    Widget Function() genPage, [
    Bindings? bindings,
  ]) {
    var page = GetPage(
      name: settings.name!,
      page: genPage,
      arguments: settings.arguments,
      binding: bindings,
      transition: Transition.rightToLeft,
    );
    return PageRedirect(route: page, unknownRoute: page).page();
  }

  switch (settings.name) {
    case "/splash":
      return page(settings, () => SplashView());
    case "/intro":
      return page(settings, () => IntroView());
    case "/home":
      return page(settings, () => HomeView());
    case "/setting":
      return page(settings, () => SettingView());
    case "/exam":
      return page(settings, () => ExamView());
    case "/history":
      return page(settings, () => HistoryView());
    case "/homeTap":
      return page(settings, () => HomeTapView());
    case "/trafficSign":
      return page(settings, () => TrafficSignView());
    case "/editProfile":
      return page(settings, () => EditProfileView());
    case "/examDetail":
      return page(settings, () => ExamDetailView());
    case "/examResult":
      return page(settings, () => ExamResultView());
    case "/examTips":
      return page(settings, () => ExamTipsView());
    case "/theory":
      return page(settings, () => TheoryView());
    case "/criticalQuestions":
      return page(settings, () => CriticalQuestionsView());
    case "/trafficSignDetail":
      return page(settings, () => TrafficSignDetailView());
    case "/examExplanation":
      return page(settings, () => ExamExplanationView());
    case "/theoryDetail":
      return page(settings, () => TheoryDetailView());
    case "/wrongQuestions":
      return page(settings, () => WrongQuestionsView());
    case "/bookmarkedQuestions":
      return page(settings, () => BookmarkedQuestionsView());
    case "/statistics":
      return page(settings, () => StatisticsView());
    case "/violations":
      return page(settings, () => ViolationsView());
    case "/randomPractice":
      return page(settings, () => RandomPracticeView());
    case "/searchQuestions":
      return page(settings, () => SearchQuestionsView());

    default:
      return page(
        settings,
        () => Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

enum AppPage {
  splash,
  intro,
  home,
  setting,
  exam,
  history,
  homeTap,
  trafficSign,
  editProfile,
  examDetail,
  examResult,
  examTips,
  theory,
  criticalQuestions,
  trafficSignDetail,
  examExplanation,
  theoryDetail,
  wrongQuestions,
  bookmarkedQuestions,
  statistics,
  violations,
  randomPractice,
  searchQuestions,
}

extension DrivingLessonPageExtension on AppPage {
  String get routeName {
    switch (this) {
      case AppPage.splash:
        return '/${AppPage.splash.name}';
      case AppPage.intro:
        return '/${AppPage.intro.name}';
      case AppPage.home:
        return '/${AppPage.home.name}';
      case AppPage.setting:
        return '/${AppPage.setting.name}';
      case AppPage.exam:
        return '/${AppPage.exam.name}';
      case AppPage.history:
        return '/${AppPage.history.name}';
      case AppPage.homeTap:
        return '/${AppPage.homeTap.name}';
      case AppPage.trafficSign:
        return '/${AppPage.trafficSign.name}';
      case AppPage.editProfile:
        return '/${AppPage.editProfile.name}';
      case AppPage.examDetail:
        return '/${AppPage.examDetail.name}';
      case AppPage.examResult:
        return '/${AppPage.examResult.name}';
      case AppPage.examTips:
        return '/${AppPage.examTips.name}';
      case AppPage.theory:
        return '/${AppPage.theory.name}';
      case AppPage.criticalQuestions:
        return '/${AppPage.criticalQuestions.name}';
      case AppPage.trafficSignDetail:
        return '/${AppPage.trafficSignDetail.name}';
      case AppPage.examExplanation:
        return '/${AppPage.examExplanation.name}';
      case AppPage.theoryDetail:
        return '/${AppPage.theoryDetail.name}';
      case AppPage.wrongQuestions:
        return '/${AppPage.wrongQuestions.name}';
      case AppPage.bookmarkedQuestions:
        return '/${AppPage.bookmarkedQuestions.name}';
      case AppPage.statistics:
        return '/${AppPage.statistics.name}';
      case AppPage.violations:
        return '/${AppPage.violations.name}';
      case AppPage.randomPractice:
        return '/${AppPage.randomPractice.name}';
      case AppPage.searchQuestions:
        return '/${AppPage.searchQuestions.name}';
    }
  }
}
