
import 'package:flutter/material.dart';
import 'package:santexnika_crm/widgets/statistic_bar.dart';

import '../../../../../tools/appColors.dart';

class MobileTradeStatisticUI extends StatefulWidget {
  const MobileTradeStatisticUI({super.key});

  @override
  State<MobileTradeStatisticUI> createState() => _MobileTradeStatisticUIState();
}

class _MobileTradeStatisticUIState extends State<MobileTradeStatisticUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          StatisticBarWidget(name: 'Savdo',)
        ],
      ),
    );
  }
}
