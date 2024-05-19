import 'dart:developer';
import 'package:course_creator/logic/constants/constants.dart';
import 'package:course_creator/logic/models/data_models.dart';
import 'package:course_creator/logic/provider/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceListTablet extends StatelessWidget {
  const ResourceListTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceProvider>(
      builder: (context, value, child) => DragTarget(
        onLeave: (data) {
          attributeColor = Colors.transparent;
        },
        onAcceptWithDetails: (details) {
          if ((details.data is CourseFile || details.data is CourseLink)) {
            log("Resource Me Aa Gya");
            if (details.data is CourseFile) {
              value.addFileResource(courseFile!);
            }
            if (details.data is CourseLink) {
              value.addLinkResource(courseLink!);
            }
          }
        },
        onWillAcceptWithDetails: (details) {
          attributeColor = Colors.grey.shade200;
          return true;
        },
        builder: (context, candidateData, rejectedData) => value
                .resources.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  color: attributeColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  itemCount: value.resources.length,
                  onReorder: (oldIndex, newIndex) =>
                      value.changeIndex(oldIndex, newIndex),
                  itemBuilder: (context, index) => Draggable(
                    key: Key("$index"),
                    maxSimultaneousDrags: 1,
                    onDragStarted: () {
                      // resourceDraggedIndex = index;
                      if (value.resources[index] is CourseFile) {
                        courseFile = value.resources[index];
                      }
                      if (value.resources[index] is CourseLink) {
                        courseLink = value.resources[index];
                      }
                    },
                    onDragCompleted: () {
                      // resourceDraggedIndex = -1;
                      value.removeItem(index);
                      courseFile = null;
                      courseLink = null;
                      attributeColor = Colors.transparent;
                    },
                    data: value.resources[index],
                    childWhenDragging: ListTile(
                      leading: const Icon(
                        Icons.drag_indicator_sharp,
                        color: Colors.grey,
                      ),
                      title: Text(
                        (value.resources[index] is CourseFile
                            ? (value.resources[index] as CourseFile).name
                            : (value.resources[index] as CourseLink).name),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    feedback: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          value.resources[index] is CourseFile
                              ? const Icon(Icons.file_copy_outlined)
                              : const Icon(Icons.link_rounded),
                          const SizedBox(width: 5),
                          Text(
                            (value.resources[index] is CourseFile
                                ? (value.resources[index] as CourseFile).name
                                : (value.resources[index] as CourseLink).name),
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
                        log("UWU Resource");
                        if (value.resources[index] is CourseLink) {
                          Uri url = Uri.parse(value.getLinkUrl(index));
                          try {
                            await launchUrl(url);
                          } catch (e) {
                            log('Could not launch $url: $e');
                          }
                        }
                      },
                      subtitle: const Text("Tap and hold to move around....!"),
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(
                          Icons.drag_indicator_sharp,
                        ),
                      ),
                      trailing: IconButton(
                        icon: value.resources[index] is CourseFile
                            ? const Icon(Icons.delete)
                            : const Icon(Icons.menu),
                        onPressed: () async {
                          log('Edit Resource tapped');
                          if (value.resources[index] is CourseFile) {
                            log("This is a file");
                            final SupabaseClient supabase =
                                Supabase.instance.client;
                            final List<FileObject> objects = await supabase
                                .storage
                                .from('resource_bucket')
                                .remove([value.getFileName(index)]);
                            value.removeItem(index);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String linkUrl = value.getLinkUrl(index);
                                String linkName = value.getLinkName(index);
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
                                              icon: Icon(Icons.link),
                                              hintText: "Url"),
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
                                        value.removeItem(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                    TextButton(
                                      child: const Text('Update'),
                                      onPressed: () {
                                        if (linkName.isNotEmpty &&
                                            linkUrl.isNotEmpty) {
                                          value.editResource(
                                              index, linkName, linkUrl);
                                          Navigator.of(context).pop();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                      ),
                      title: Text(
                        (value.resources[index] is CourseFile
                            ? (value.resources[index] as CourseFile).name
                            : (value.resources[index] as CourseLink).name),
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 4),
                    Image.network(
                      "https://i.ibb.co/dk3YK61/box.png",
                      scale: 2,
                    ),
                    const Text("No resources added yet!"),
                    const Text("Tap the (+) Add button to add"),
                  ],
                ),
              ),
      ),
    );
  }
}
