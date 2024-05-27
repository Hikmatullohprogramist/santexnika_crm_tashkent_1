import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/main/desktop/desktop_main.dart';

import '../../tools/responsive.dart';
import 'mobile/mobile_main.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: MobileMain(),
        desktop: DesktopMain(),
      ),
    );
  }
}
