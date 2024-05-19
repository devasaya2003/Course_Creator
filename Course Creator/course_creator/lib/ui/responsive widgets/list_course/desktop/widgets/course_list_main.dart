import 'dart:developer';
import 'package:course_creator/logic/constants/constants.dart';
import 'package:course_creator/logic/models/data_models.dart';
import 'package:course_creator/logic/provider/course_provider.dart';
import 'package:course_creator/ui/responsive%20widgets/list_course/desktop/widgets/attributes_list.dart';
import 'package:course_creator/ui/responsive%20widgets/list_course/desktop/widgets/module_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseListMain extends StatelessWidget {
  final int courseIndex;

  const CourseListMain({super.key, required this.courseIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, value, child) => DragTarget(
        onAcceptWithDetails: (details) {
          if ((details.data is CourseFile || details.data is CourseLink)) {
            log("Attribute Me Aa Gya");
            if (details.data is CourseFile) {
              value.addACourseAttribute(courseIndex, courseFile);
            }
            if (details.data is CourseLink) {
              value.addACourseAttribute(courseIndex, courseLink);
            }
          }
        },
        onLeave: (data) {
          attributeColor = Colors.transparent;
        },
        onWillAcceptWithDetails: (details) {
          attributeColor = Colors.grey.shade200;
          return true;
        },
        builder: (context, candidateData, rejectedData) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: attributeColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: value.modules[courseIndex].courseItems.isEmpty == false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ModuleNameWidget(courseIndex: courseIndex),
                    AllAttributes(courseIndex: courseIndex),
                  ],
                )
              : ModuleNameWidget(courseIndex: courseIndex),
        ),
      ),
    );
  }
}
