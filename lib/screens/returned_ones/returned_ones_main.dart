import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/returned_ones/pages/returned_ones_mobile/mobile_returned_ones.dart';
import 'package:santexnika_crm/tools/responsive.dart';

import 'pages/returned_ones_desktop/desktop_returned_ones.dart';

class ReturnedOnesMain extends StatelessWidget {
  const ReturnedOnesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: ReturnedOnesMobileUI(),
        desktop: ReturnedOnesDesktopUI(),
      ),
    );
  }
}
