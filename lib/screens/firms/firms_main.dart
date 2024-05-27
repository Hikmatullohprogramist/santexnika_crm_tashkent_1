import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/firms/pages/firms_desktop/firms_desktop.dart';
import 'package:santexnika_crm/screens/firms/pages/firms_mobile/firms_mobile.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class FirmsMain extends StatelessWidget {
  const FirmsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: FirmsMobileUI(),
        desktop: FirmsDesktopUI(),
      ),
    );
  }
}
