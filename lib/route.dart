import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screen/splash/splash_view.dart';
import 'screen/home/home_view.dart';
import 'screen/setting/setting_view.dart';
import 'screen/exam/exam_view.dart';
import 'screen/history/history_view.dart';
import 'screen/home_tap/home_tap_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  GetPageRoute page(RouteSettings settings, Widget Function() genPage, [Bindings? bindings]) {
    var page = GetPage(
      name: settings.name!,
      page: genPage,
      arguments: settings.arguments,
      binding: bindings,
    );
    return PageRedirect(route: page, unknownRoute: page).page();
  }

  switch (settings.name) {
    case "/splash":
      return page(settings, () => SplashView());
    case "/home":
      return page(settings, () => HomeView());
    case "/setting":
      return page(settings, () => SettingView());
    case "/exam":
      return page(settings, () => ExamView());
    case "/history":
      return page(settings, () => HistoryView());
    case "/home_tap":
      return page(settings, () => HomeTapView());
   
    default:
      return page(
        settings,
        () => Scaffold(
          appBar: AppBar(
            title: const Text('404'),
          ),
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

enum AppPage {
  splash,
  home,
  setting,
  exam,
  history,
  homeTap,
}

extension DrivingLessonPageExtension on AppPage {
  String get routeName {
    switch (this) {
      case AppPage.splash:
        return '/${AppPage.splash.name}';
      case AppPage.home:
        return '/${AppPage.home.name}';
      case AppPage.setting:
        return '/${AppPage.setting.name}';
      case AppPage.exam:
        return '/${AppPage.exam.name}';
      case AppPage.history:
        return '/${AppPage.history.name}';
      case AppPage.homeTap:
        return '/home_tap';
    }
  }
}
