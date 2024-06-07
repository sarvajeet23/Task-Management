import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskapp/modules/task/components/filter_tag.dart';
import 'package:taskapp/utils/app_style.dart';
import 'package:taskapp/utils/service_utils.dart';

class TaskCard extends StatelessWidget {
  final String? title;
  final String? description;
  final bool isCompleted;
  final int? priority;
  final String? status;
  final VoidCallback? onTap;

  final void Function(bool?) toggleCheckbox;

  const TaskCard({
    this.title,
    this.description,
    this.isCompleted = false,
    required this.toggleCheckbox,
    super.key,
    this.priority,
    this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecoration,
      margin: const EdgeInsets.all(10).copyWith(bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              priorityAndStatus(context),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "",
                      maxLines: 2,
                      style: AppStyles.style16Bold.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description ?? '',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.style15Normal.copyWith(
                        color: Colors.black.withOpacity(0.8),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget priorityAndStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FilterTag(
          title: ServiceUtils.getPriorityLabel(priority ?? 0),
          textColour: ServiceUtils.getPriorityColor(priority ?? 0),
          bgColor: ServiceUtils.getPriorityColor(priority ?? 0, isOpacity: true),
        ),
        const SizedBox(width: 10),
        FilterTag(
          title: status,
          textColour: ServiceUtils.getStatusColor(status ?? ''),
          bgColor: ServiceUtils.getStatusColor(status ?? '', isOpacity: true),
        ),
        const Spacer(),
        Checkbox(
          value: isCompleted,
          onChanged: toggleCheckbox,
        ),
      ],
    );
  }

  ShapeDecoration get getDecoration {
    return ShapeDecoration(
      color: isCompleted ? Colors.green.withOpacity(0.2) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 1,
          color: Colors.grey.withOpacity(0.6),
        ),
      ),
    );
  }
}
