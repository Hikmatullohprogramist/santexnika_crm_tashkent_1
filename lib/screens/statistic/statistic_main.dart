import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_desktop/statistic_desktop.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/statistic_mobile.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class StatisticMain extends StatelessWidget {
  const StatisticMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: StatisticMobileUI(),
        desktop: StatisticDesktopUI(),
      ),
    );
  }
}
