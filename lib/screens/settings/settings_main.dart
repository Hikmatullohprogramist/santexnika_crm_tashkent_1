import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/settings_desktop.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/settings_mobile.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: SettingsMobileUI(),
        desktop: SettingsDesktopUI(),
      ),
    );
  }
}
