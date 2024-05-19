import 'dart:developer';
import 'package:course_creator/logic/models/data_models.dart';
import 'package:course_creator/logic/provider/course_provider.dart';
import 'package:course_creator/logic/provider/resource_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final items = {
  'Create Module': {
    'icon': Icons.list_alt_rounded,
    'onTap': () {
      log('Create Module tapped');
    },
  },
  'Add Link': {
    'icon': Icons.link_rounded,
    'onTap': () {
      log('Add Link tapped');
    },
  },
  'Upload': {
    'icon': Icons.upload_rounded,
    'onTap': () {
      log('Upload tapped');
    },
  },
};

class MobileNavBar extends StatelessWidget {
  const MobileNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Course Builder",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          NavButton(
            text: '+ Add',
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final String text;
  final double fontSize;

  const NavButton({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Text(
                '+ Add',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          items: items.entries
              .map<DropdownMenuItem<String>>(
                (MapEntry<String, Map<String, dynamic>> entry) =>
                    DropdownMenuItem<String>(
                  onTap: entry.value["onTap"],
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(
                        entry.value["icon"],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          // value: selectedValue,
          onChanged: (value) async {
            
          if (value == 'Create Module') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String moduleName = "";
                  return AlertDialog(
                    title: const Text('Create Module'),
                    content: TextField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.edit), hintText: "Module Name"),
                      onChanged: (value) {
                        moduleName = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Add'),
                        onPressed: () {
                          if (moduleName.isNotEmpty) {
                            Provider.of<CourseProvider>(context, listen: false)
                                .addModule(moduleName);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Module Name cannot be empty!'),
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

            if (value == 'Add Link') {
              log('Add Link tapped');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String linkUrl = "";
                  String linkName = "";
                  return AlertDialog(
                    title: const Text('Add Link'),
                    content: SizedBox(
                      
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.link), hintText: "Url"),
                            onChanged: (value) {
                              linkUrl = value;
                            },
                          ),
                          TextField(
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
                        child: const Text('Add'),
                        onPressed: () {
                          if (linkName.isNotEmpty && linkUrl.isNotEmpty) {
                            Provider.of<ResourceProvider>(context,
                                    listen: false)
                                .addLinkResourceThroughText(linkUrl, linkName);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Both fields must be filled out!'),
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

            if (value == 'Upload') {
              log("Upload is tapped");
              // await
              final result = await FilePicker.platform.pickFiles();
              final SupabaseClient supabase = Supabase.instance.client;

              if (result == null) return;

              final file = result.files.first;
              final fileName = file.name;
              // final filePath = file.path;
              final fileBytes = file.bytes;

              log(file.toString());
              log(fileName.toString());
              // log(filePath.toString());
              log(fileBytes.toString());

              if (fileBytes != null && fileName.isNotEmpty) {
                try {
                  final avatarFile = fileBytes;
                  final String path = await supabase.storage
                      .from('resource_bucket')
                      .uploadBinary(
                        fileName,
                        avatarFile,
                        fileOptions: const FileOptions(
                            cacheControl: '3600', upsert: false),
                      );

                  String getdownloadUrl = supabase.storage
                      .from('resource_bucket')
                      .getPublicUrl(fileName)
                      .toString();

                  log(getdownloadUrl);
                  log("Upload Successful!");
                  Provider.of<ResourceProvider>(context,listen: false).addFileResource(
                    CourseFile(
                      downloadUrl: getdownloadUrl,
                      name: fileName,
                    ),
                  );
                } catch (e) {
                  log(e.toString());
                }
              }
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: 80,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.redAccent,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
            ),
            iconSize: 20,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.black,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            offset: const Offset(0, -5),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
