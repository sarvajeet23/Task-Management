import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/modules/task/controllers/task_controller.dart';
import 'package:taskapp/modules/theme/theme_controller.dart';
import 'package:taskapp/modules/theme/themes.dart';
import 'package:taskapp/routes/app_pages.dart';
import 'package:taskapp/routes/app_routes.dart';
import 'package:taskapp/services/network_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initalizePreAppServices();
  runApp(const MyApp());
}

Future<void> _initalizePreAppServices() async {
  final networkService = NetworkService.instance;
  await networkService.init();
  Get.put(TaskController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task App',
      themeMode: ThemeController.currentTheme,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      getPages: Routes.pages,
      initialRoute: AppRoutes.homePage,
      debugShowCheckedModeBanner: false,
    );
  }
}
