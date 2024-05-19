import 'package:course_creator/ui/responsive%20widgets/list_course/desktop/list_desktop.dart';
import 'package:course_creator/ui/responsive%20widgets/list_course/mobile/list_mobile.dart';
import 'package:course_creator/ui/responsive%20widgets/list_course/tablet/list_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ListCourse extends StatelessWidget {
  const ListCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (BuildContext context) => const DesktopList(),
      tablet: (BuildContext context) => const TabletList(),
      mobile: (BuildContext context) => const MobileList(),
    );
  }
}
