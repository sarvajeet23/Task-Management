import 'package:get/get.dart';
import 'package:taskapp/widgets/api_error_dilaog.dart';

class AppException implements Exception {
  final String message;
  final String prefix;

  AppException([this.message = "", this.prefix = ""]);

  @override
  String toString() {
    showErrorDialog(message, prefix);
    return "$prefix$message";
  }

  void showErrorDialog(String message, String title) async => await Get.dialog(
        ApiErrorDialog(title: title, message: message),
      );
}
