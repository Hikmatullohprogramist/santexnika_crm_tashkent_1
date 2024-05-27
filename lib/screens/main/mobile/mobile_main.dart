import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_mobile/trade_mobile.dart';

import '../../../tools/appColors.dart';

class MobileMain extends StatelessWidget {
  const MobileMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: const TradeMobileUI(),
    );
  }
}
