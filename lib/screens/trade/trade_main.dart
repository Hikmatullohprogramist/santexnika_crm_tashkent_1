import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/tarde_desktop.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_mobile/trade_mobile.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class TradeMain extends StatelessWidget {
  const TradeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: TradeMobileUI(),
        desktop: TradeDesktopUI(),
      ),
    );
  }
}
