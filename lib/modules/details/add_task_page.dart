// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/models/task_model.dart';
import 'package:taskapp/utils/app_color.dart';
import 'package:taskapp/utils/app_style.dart';
import 'package:taskapp/utils/service_utils.dart';

import '../task/controllers/task_controller.dart';

class AddTaskPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TaskController controller = Get.put(TaskController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedStatus = 'Pending'; // Initial status
  String selectedPriority = 'Low'; // Initial priority

  List<String> statusOptions = ['Pending', 'Completed'];
  List<String> priorityOptions = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    final model = Get.arguments as Task?;
    if (model != null) {
      titleController.text = model.title ?? "";
      descriptionController.text = model.description ?? "";
      selectedPriority = ServiceUtils.getPriorityLabel(model.priority ?? 0);
      selectedStatus = model.status ?? '';
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColor.taskColour,
        title: model != null ? Text("Update Task") : Text("Add Task"),
      ),
      body: Container(
        color: AppColor.taskColour,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: GetBuilder<TaskController>(
              builder: (controller) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: AppStyles.style20Normal,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Description",
                    style: AppStyles.style20Normal,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Status",
                    style: AppStyles.style20Normal,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                    items: statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedStatus = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Priority",
                    style: AppStyles.style20Normal,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                    items: priorityOptions.map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedPriority = newValue;
                      }
                    },
                  ),
                  Spacer(),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () => onSubmitTap(controller, model),
                        child: Text(
                          model != null ? "Update Task" : "Submit",
                          style: AppStyles.style16Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitTap(TaskController controller, Task? model) {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      controller.addTask(
        title,
        description,
        selectedStatus,
        ServiceUtils.getPriority(selectedPriority),
        isUpdate: model != null,
        model: model,
      );

      titleController.clear();
      descriptionController.clear();
      Get.back();
    }
  }
}
