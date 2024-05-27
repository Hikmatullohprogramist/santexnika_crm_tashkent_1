import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/customer/pages/customer_desktop/customer_desktop_ui.dart';
import 'package:santexnika_crm/screens/customer/pages/customer_mobile/customer_mobile_ui.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class CustomerMain extends StatelessWidget {
  const CustomerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: ResponsiveLayout(
        mobile: CustomerMobileUI(),
        desktop: CustomerDesktopUI(),
      ),
    );
  }
}
