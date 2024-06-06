import 'package:flutter/material.dart';

class ServiceUtils {
  static const Map<String, Color> statusColors = {
    "Pending": Colors.red,
    "Completed": Colors.green,
  };

  static const Map<int, Color> priorityColors = {
    1: Colors.orange,
    2: Colors.blue,
    3: Colors.purple,
  };

  static Color getStatusColor(String status, {bool isOpacity = false}) {
    return statusColors[status]?.withOpacity(isOpacity ? 0.15 : 1.0) ??
        Colors.grey.withOpacity(isOpacity ? 0.15 : 1.0);
  }

  static Color getPriorityColor(int priority, {bool isOpacity = false}) {
    return priorityColors[priority]?.withOpacity(isOpacity ? 0.15 : 1.0) ??
        Colors.grey.withOpacity(isOpacity ? 0.15 : 1.0);
  }

  static String getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return "High";
      case 2:
        return "Medium";
      case 3:
        return "Low";
      default:
        return "Unknown";
    }
  }

  static int getPriority(String? priority) {
    switch (priority) {
      case "High":
        return 1;
      case "Medium":
        return 2;
      case "Low":
        return 3;
      default:
        return 0;
    }
  }
}
