import 'package:course_creator/ui/responsive%20widgets/Navbar/desktop/navbar_desktop.dart';
import 'package:course_creator/ui/responsive%20widgets/Navbar/mobile/navbar_mobile.dart';
import 'package:course_creator/ui/responsive%20widgets/Navbar/tablet/navbar_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.black,
      flexibleSpace: ScreenTypeLayout.builder(
        desktop: (BuildContext context) => const DesktopNavBar(),
        tablet: (BuildContext context) => const TabletNavBar(),
        mobile: (BuildContext context) => const MobileNavBar(),
      ),
    );
  }
}
