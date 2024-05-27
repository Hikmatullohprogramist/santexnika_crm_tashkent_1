import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/pages/mobile_customer.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/pages/mobile_employees.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/pages/mobile_product.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/pages/mobile_return_ones.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/pages/mobile_tade.dart';
import 'package:santexnika_crm/screens/statistic/pages/statistic_mobile/pages/moile_cashbox.dart';
import 'package:santexnika_crm/tools/appColors.dart';

import '../../../../widgets/text_widget/text_widget.dart';
import '../../../main/mobile/widget/nav_bar.dart';

class StatisticMobileUI extends StatefulWidget {
  const StatisticMobileUI({super.key});

  @override
  State<StatisticMobileUI> createState() => _StatisticMobileUIState();
}

class _StatisticMobileUIState extends State<StatisticMobileUI> {
  int _currentIndex = 0; // Track the current index

  // Define constant icons
  static const List<IconData> _icons = [
    Icons.price_change_outlined,
    Icons.shopping_cart,
    Icons.production_quantity_limits,
    Icons.supervised_user_circle,
    Icons.people_alt_outlined,
    Icons.refresh_outlined,
  ];

  List<Widget> pages = [
    const MobileCashBoxStatisticUI(),
    const MobileTradeStatisticUI(),
    const MobileProductStatisticUI(),
    const MobileEmployeesStatisticUI(),
    const MobilCustomerStatisticUI(),
    const MobileReturnOneStatisticUI(),
  ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          iconTheme:  IconThemeData(color: AppColors.whiteColor),
          backgroundColor: AppColors.primaryColor,
          title: const TextWidget(txt: "Statistika"),
          bottom: TabBar(
            physics: const NeverScrollableScrollPhysics(),
            onTap: (index) {
              setState(() {
                _currentIndex = index; // Update the current index
              });
            },
            tabs: List.generate(pages.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  _icons[index],
                  color: AppColors.whiteColor,
                  size: 25,
                ),
              );
            }),
          ),
        ),
        body: pages[_currentIndex],
      ),
    );
  }
}
