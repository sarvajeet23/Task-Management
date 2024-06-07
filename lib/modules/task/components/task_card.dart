// ignore_for_file: prefer_const_constructors, use_super_parameters

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
    Key? key,
    this.priority,
    this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecoration,
      margin: EdgeInsets.all(10).copyWith(bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              priorityAndStatus(context),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5),
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
                    SizedBox(height: 10),
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
        SizedBox(width: 10),
        FilterTag(
          title: status,
          textColour: ServiceUtils.getStatusColor(status ?? ''),
          bgColor: ServiceUtils.getStatusColor(status ?? '', isOpacity: true),
        ),
        Spacer(),
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
