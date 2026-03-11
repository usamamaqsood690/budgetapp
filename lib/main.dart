import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_constants.dart';
import 'package:wealthnxai/core/localization/app_translation.dart';
import 'package:wealthnxai/core/services/app_config_service.dart';
import 'package:wealthnxai/core/services/internet_connection_service.dart';
import 'package:wealthnxai/core/themes/app_theme.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppConfigService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    InternetConnectionService.instance.startListening();
    return GetMaterialApp(
      title: AppConstant.appName,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      useInheritedMediaQuery: true,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      fallbackLocale: const Locale('en'),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
