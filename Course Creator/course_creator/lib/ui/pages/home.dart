import 'dart:developer';

import 'package:course_creator/logic/constants/constants.dart';
import 'package:course_creator/logic/models/data_models.dart';
import 'package:course_creator/logic/provider/resource_provider.dart';
import 'package:course_creator/ui/responsive%20widgets/Navbar/nav_bar.dart';
import 'package:course_creator/ui/responsive%20widgets/list_course/list_course.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> _items =
    List<String>.generate(10, (index) => "Course Title $index");

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final SupabaseClient supabase = Supabase.instance.client;

  void getFilesInSupabase() async {
    final List<FileObject> objects =
        await supabase.storage.from('resource_bucket').list();
    await Future.wait(objects.map((fileObject) async {
      final downloadUrl = await supabase.storage
          .from('resource_bucket')
          .createSignedUrl(fileObject.name, 3600);
      CourseFile supabaseCourseFile =
          CourseFile(downloadUrl: downloadUrl, name: fileObject.name);
      Provider.of<ResourceProvider>(context, listen: false)
          .addFileResource(supabaseCourseFile);
    }));
  }

  @override
  void initState() {
    super.initState();
    getFilesInSupabase();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Window size changed
    log('Window size changed');
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return const SafeArea(
      child: Scaffold(
        appBar: NavBar(),
        body: ListCourse(),
      ),
    );
  }
}
