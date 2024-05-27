import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/store_desktop.dart';
import 'package:santexnika_crm/screens/store/pages/mobile/store_mobile/store_mobile.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: StoreMobileUI(),
      desktop: StoreDesktopUI(),
    );
  }
}
