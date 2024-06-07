import 'package:get/get.dart';
import 'package:taskapp/modules/add_task/add_task_page.dart';
import 'package:taskapp/modules/task/task_page.dart';
import 'package:taskapp/routes/app_routes.dart';

class Routes {
  static List<GetPage> pages = [
    GetPage(name: AppRoutes.homePage, page: TaskPage.new),
    GetPage(name: AppRoutes.addTaskPage, page: AddTaskPage.new),
  ];
}
