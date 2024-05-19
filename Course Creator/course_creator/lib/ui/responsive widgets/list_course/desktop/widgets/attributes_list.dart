import 'dart:developer';

import 'package:course_creator/logic/constants/constants.dart';
import 'package:course_creator/logic/models/data_models.dart';
import 'package:course_creator/logic/provider/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AllAttributes extends StatelessWidget {
  final int courseIndex;

  const AllAttributes({super.key, required this.courseIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, value, child) => SizedBox(
        child: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          itemCount: value.getCourseItemLength(courseIndex),
          onReorder: (oldIndex, newIndex) {
            // Update your data source here
            value.changeLocalIndex(courseIndex, oldIndex, newIndex);
          },
          itemBuilder: (context, index) => Draggable(
            maxSimultaneousDrags: 1,
            data: value.modules[courseIndex].courseItems[index],
            key: Key('$index'),
            onDragStarted: () {
              if (value.modules[courseIndex].courseItems[index] is CourseFile) {
                courseFile = value.modules[courseIndex].courseItems[index];
              }
              if (value.modules[courseIndex].courseItems[index] is CourseLink) {
                courseLink = value.modules[courseIndex].courseItems[index];
              }
            },
            onDragCompleted: () {
              value.deleteACourseAttribute(courseIndex, index);
              courseFile = null;
              courseLink = null;
              attributeColor = Colors.transparent;
            },
            childWhenDragging: ListTile(
              leading: const Icon(
                Icons.drag_indicator_rounded,
                size: 20,
              ),
              title: Text(
                (value.modules[courseIndex].courseItems[index] is CourseFile
                    ? (value.modules[courseIndex].courseItems[index]
                            as CourseFile)
                        .name
                    : (value.modules[courseIndex].courseItems[index]
                            as CourseLink)
                        .name),
              ),
            ),
            feedback: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  value.modules[courseIndex].courseItems[index] is CourseFile
                      ? const Icon(Icons.file_copy_outlined)
                      : const Icon(Icons.link_rounded),
                  const SizedBox(width: 5),
                  Text(
                    (value.modules[courseIndex].courseItems[index] is CourseFile
                        ? (value.modules[courseIndex].courseItems[index]
                                as CourseFile)
                            .name
                        : (value.modules[courseIndex].courseItems[index]
                                as CourseLink)
                            .name),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            child: ListTile(
              onTap: () async {
                if (value.modules[courseIndex].courseItems[index]
                    is CourseFile) {
                  Uri url = Uri.parse(value.getFileUrl(courseIndex, index));
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    log('Could not launch $url: $e');
                  }
                  log("UWU Attributes");
                }

                if (value.modules[courseIndex].courseItems[index]
                    is CourseLink) {
                  Uri url = Uri.parse(value.getLinkUrl(courseIndex, index));
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    log('Could not launch $url: $e');
                  }
                }
                log("UWU Attributes");
              },
              leading: ReorderableDragStartListener(
                index: index,
                child: const Icon(
                  Icons.drag_indicator_rounded,
                  size: 20,
                ),
              ),
              title: Text(
                (value.modules[courseIndex].courseItems[index] is CourseFile
                    ? (value.modules[courseIndex].courseItems[index]
                            as CourseFile)
                        .name
                    : (value.modules[courseIndex].courseItems[index]
                            as CourseLink)
                        .name),
              ),
              trailing: IconButton(
                onPressed: () async {
                  log('Edit Resource tapped');
                  if (value.modules[courseIndex].courseItems[index]
                      is CourseFile) {
                    log("This is a file");
                    final SupabaseClient supabase = Supabase.instance.client;
                    final List<FileObject> objects = await supabase.storage
                        .from('resource_bucket')
                        .remove([value.getFileName(courseIndex, index)]);
                    value.deleteACourseAttribute(courseIndex, index);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String linkUrl = value.getLinkUrl(courseIndex, index);
                        String linkName = value.getLinkName(courseIndex, index);
                        TextEditingController urlController =
                            TextEditingController();
                        TextEditingController nameController =
                            TextEditingController();
                        urlController.text = linkUrl;
                        nameController.text = linkName;
                        return AlertDialog(
                          title: const Text('Edit Link'),
                          content: SizedBox(
                            width: w! / 4,
                            height: h! / 5.5,
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.link), hintText: "Url"),
                                  onChanged: (value) {
                                    linkUrl = value;
                                  },
                                  controller: urlController,
                                ),
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.edit),
                                    hintText: "Name",
                                  ),
                                  onChanged: (value) {
                                    linkName = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                value.deleteACourseAttribute(
                                    courseIndex, index);
                                Navigator.pop(context);
                              },
                              child: const Text("Delete"),
                            ),
                            TextButton(
                              child: const Text('Update'),
                              onPressed: () {
                                if (linkName.isNotEmpty && linkUrl.isNotEmpty) {
                                  value.setLinkNameAndUrl(
                                      courseIndex, index, linkName, linkUrl);
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Both fields must be filled out!'),
                                    ),
                                  );
                                }
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
                  }
                },
                icon: Icon(
                  value.modules[courseIndex].courseItems[index] is CourseFile
                      ? Icons.delete
                      : Icons.menu,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
