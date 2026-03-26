# DrivePass - Flutter Base Architecture

Đây là file tổng hợp toàn bộ cấu trúc chuẩn (Base) của project DrivePass. Mọi component mới phải tuân thủ nghiêm ngặt các quy tắc dưới đây.

## 1. Công Nghệ Cốt Lõi
- **State Management, Dependency & Route:** GetX (`get`)
- **Local Storage:** `get_storage`
- **Responsive Screen:** `flutter_screenutil`

---

## 2. Cấu Trúc Thư Mục
Cấu trúc chuẩn bao gồm:
- `assets/`
  - `fonts/`
  - `icons/`
  - `images/`
- `lib/`
  - `common/`: Các widget dùng chung nhiều nơi.
  - `dialog/`: Các Base Dialog hoặc Custom Dialog.
  - `model/`: Các class Model data.
  - `resource/`: Chứa `app_colors.dart`, `app_resource.dart`, `app_text.dart`.
  - `screen/`: Các màn hình của app (mỗi màn hình là 1 folder).
  - `service/`: Global Services (`api_service.dart`, `local_service.dart`).
  - `utils/`: Các hàm và tiện ích hỗ trợ.

---

## 3. Quy Chuẩn Tạo Màn Hình (Screen)
Khi tạo màn hình mới (ví dụ `Splash`), luôn tạo 1 thư mục `lib/screen/splash` với 2 file như sau:

### Controller (`splash_controller.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  onBack() {
    Get.back();
  }
}
```

### View (`splash_view.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatefulWidget {
  SplashView({super.key}) {
    if (!Get.isRegistered<SplashController>()) {
      Get.put(SplashController());
    }
  }

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  var controller = Get.find<SplashController>();

  @override
  void dispose() {
    Get.delete<SplashController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
```

---

## 4. Cấu Hình Routing (`lib/route.dart`)
- Mọi màn hình mới **phải được khai báo** vào file `lib/route.dart`.
- Các phần cần update: (1) Khai báo `enum AppPage`, (2) Thêm link vào `routeName`, (3) Khai báo case cho Switch Widget.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screen/splash/splash_view.dart';

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
}

extension DrivingLessonPageExtension on AppPage {
  String get routeName {
    switch (this) {
      case AppPage.splash:
        return '/${AppPage.splash.name}';
    }
  }
}
```

---

## 5. Main App Setup (`lib/main.dart`)
`MyApp` sử dụng `StatefulWidget` được bọc bởi `ScreenUtilInit` cấu hình responsive kích thước thiết kế gốc là **390 x 884**, và dùng `GetMaterialApp` có `onGenerateRoute`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 884),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 200),
          initialRoute: AppPage.splash.routeName,
          textDirection: TextDirection.ltr,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
          },
          onGenerateRoute: generateRoute,
        );
      },
    );
  }
}
```

---

## 6. Config Hệ Thống & Thiết Bị
- **Giao diện:** Luôn cố định xoay dọc (Portrait Chỉ), được config Native qua file `Info.plist` (iOS) và `AndroidManifest.xml` (Android).
- **iOS:** Minimum Deployment Target quy định bắt buộc từ bản **15.0** trở lên.

---

## 7. Quy chuẩn Quản lý Assets
Toàn bộ resource hình ảnh và icon phải được định nghĩa tập trung trong file `lib/resource/app_resource.dart`.

- **Mục tiêu:** Quản lý đường dẫn tĩnh cho ứng dụng, tránh gõ sai chính tả (`Typo`).
- **Phân loại thư mục:**
  - `assets/images`: Chứa các ảnh (Image/Banner).
  - `assets/icons`: Chứa các tiểu biểu tượng, Icon (vd: icon menu, icon button).
- **Cấu trúc Class Template:**
```dart
const assetsImgPath = 'assets/images';
const assetsIconPath = 'assets/icons';

abstract class Img {
  /// icons
  static const String icMenuDiscoverSelect = '\$assetsIconPath/ic_menu_discover_select.png';
  
  /// images
  static const String imgBannerUnlimited = '\$assetsImgPath/img_banner_unlimited.png';
}
```
- **Sử dụng:** Thay vì dùng `Image.asset('assets/images/...')`, bắt buộc dùng `Image.asset(Img.imgBannerUnlimited)`.
