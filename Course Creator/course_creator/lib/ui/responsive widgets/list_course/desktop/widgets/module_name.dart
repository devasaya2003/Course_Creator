import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../logic/provider/course_provider.dart';

class ModuleNameWidget extends StatelessWidget {
  const ModuleNameWidget({
    super.key,
    required this.courseIndex,
  });

  final int courseIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, value, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value.modules[courseIndex].moduleName),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    log("Change Module Name is tapped");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String moduleName =
                            value.modules[courseIndex].moduleName;
                        TextEditingController controller =
                            TextEditingController();
                        controller.text = moduleName;
                        return AlertDialog(
                          title: const Text('Edit Module Name'),
                          content: TextField(
                            controller: controller,
                            onChanged: (value) {
                              moduleName = value;
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Change'),
                              onPressed: () {
                                value.changeModuleName(moduleName, courseIndex);
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    value.deleteModule(courseIndex);
                  },
                  icon: const Icon(Icons.delete_outline_rounded)),
            ],
          )
        ],
      ),
    );
  }
}
