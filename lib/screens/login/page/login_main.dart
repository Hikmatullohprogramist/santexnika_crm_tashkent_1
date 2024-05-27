import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/login/page/login_desktop/login_desktop_ui.dart';
import 'package:santexnika_crm/screens/login/page/login_mobile/login_mobile_ui.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: LoginMobileUI(),
        desktop: LoginDesktopUI(),
      ),
    );
  }
}
