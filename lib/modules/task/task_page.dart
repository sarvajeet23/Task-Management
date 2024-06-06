import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/modules/task/components/task_card.dart';
import 'package:taskapp/modules/task/controllers/task_controller.dart';
import 'package:taskapp/utils/app_style.dart';
import 'components/task_page_sliver_appbar.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<TaskController>(
        builder: (controller) {
          if (controller.loadingStatus == LoadingStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.loadingStatus == LoadingStatus.error) {
            return Center(
              child: Text(
                "Error occured!",
                style: AppStyles.style16Bold.copyWith(color: Colors.red),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                HomePageSliverAppBar(controller: controller),
                if (controller.tasks.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text("No Data Found"),
                    ),
                  ),
                SliverList.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final model = controller.tasks[index];
                    // log("isCompleted ${model.status}");

                    return TaskCard(
                      onTap: () => controller.onTaskTap(model),
                      title: model.title,
                      description: model.description,
                      priority: model.priority,
                      status: model.status,
                      isCompleted: model.status == 'Completed' ? true : false,
                      toggleCheckbox: (val) => controller.onCheckboxTap(val, index),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
