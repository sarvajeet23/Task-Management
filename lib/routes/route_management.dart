import 'dart:core';

import 'package:get/get.dart';
import 'package:taskapp/models/task_model.dart';
import 'package:taskapp/routes/app_routes.dart';

abstract class RouteManagement {
  static void goToHomePage() {
    Get.offNamedUntil(AppRoutes.homePage, (_) => false);
  }

  static void addTaskPage({Task? model}) {
    Get.toNamed(AppRoutes.addTaskPage, arguments: model);
  }

  static Future<T?>? goTo<T>(String page, {dynamic arguments}) async {
    final result = await Get.toNamed(page, arguments: arguments);
    return result;
  }
}
