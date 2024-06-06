import 'package:flutter/material.dart';
import 'package:taskapp/modules/task/controllers/task_controller.dart';
import 'package:taskapp/routes/route_management.dart';

class HomePageSliverAppBar extends StatelessWidget {
  const HomePageSliverAppBar({
    super.key,
    required this.controller,
  });

  final TaskController controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text("Task Management"),
      actions: [
        IconButton(
          onPressed: () => RouteManagement.addTaskPage(),
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () => controller.addDemoTask(),
          icon: const Icon(Icons.more),
        ),
      ],
      floating: true,
      snap: true,
      forceMaterialTransparency: false,
    );
  }
}
