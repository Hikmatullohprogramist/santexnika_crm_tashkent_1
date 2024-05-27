import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/pages/category.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/pages/company.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/pages/permission.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/pages/type.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/pages/users.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/pages/valyuta.dart';

import '../../../tools/appColors.dart';
import '../../../widgets/text_widget/text_widget.dart';
import '../../main/mobile/widget/nav_bar.dart';

class SettingsMobileUI extends StatefulWidget {
  const SettingsMobileUI({super.key});

  @override
  State<SettingsMobileUI> createState() => _SettingsMobileUIState();
}

class _SettingsMobileUIState extends State<SettingsMobileUI> {
  int currentIndex = 0;

  final List _page = [
    const MobileUsersScreen(),
    const MobileCompanyScreen(),
    const MobileCategoryScreen(),
    const MobilePermissionScreen(),
    const MobileTypeScreen(),
    const MobileValyutaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      body: _page.elementAt(currentIndex),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(txt: "Sozlamalar"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (v) {
          setState(() {
            currentIndex = v;
          });
        },
        currentIndex: currentIndex,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.selectedColor,
        unselectedItemColor: AppColors.whiteColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Xodimlar"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Filial"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Kategorya"),
          BottomNavigationBarItem(
              icon: Icon(Icons.safety_check), label: "Ruxsatlar"),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Pul turi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset), label: "Valyuta"),
        ],
      ),
    );
  }
}
