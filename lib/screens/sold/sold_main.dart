import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/sold/pages/sold_desktop/sold_desktop.dart';
import 'package:santexnika_crm/screens/sold/pages/sold_mobile/sold_mobile.dart';

import '../../tools/responsive.dart';

class SoldMain extends StatefulWidget {
  const SoldMain({super.key});

  @override
  State<SoldMain> createState() => _SoldMainState();
}

class _SoldMainState extends State<SoldMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: SoldMobile(),
        desktop: SoldDesktop(),
      ),
    );
  }
}
