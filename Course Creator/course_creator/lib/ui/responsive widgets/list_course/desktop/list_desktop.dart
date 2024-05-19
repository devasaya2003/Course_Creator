import 'package:course_creator/logic/provider/course_provider.dart';
import 'package:course_creator/ui/responsive%20widgets/list_course/desktop/widgets/resource_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/course_list_main.dart';

class DesktopList extends StatelessWidget {
  const DesktopList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, value, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 200),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                itemCount: value.modules.length,
                itemBuilder: (context, index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  key: Key("$index"),
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_indicator_rounded),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: CourseListMain(courseIndex: index),
                    )),
                  ],
                ),
                onReorder: (oldIndex, newIndex) {
                  value.changeGlobalIndex(oldIndex, newIndex);
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 200),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Resources"),
                  ResourceList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}