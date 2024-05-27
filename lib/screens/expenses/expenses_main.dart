import 'package:flutter/material.dart';
import 'package:santexnika_crm/screens/expenses/pages/expenses_desktop/expenses_desktop_ui.dart';
import 'package:santexnika_crm/screens/expenses/pages/expenses_mobile/expenses_mobile_ui.dart';
import 'package:santexnika_crm/tools/responsive.dart';

class ExpensesMain extends StatelessWidget {
  const ExpensesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: ExpensesMobile(),
        desktop: ExpensesDesktop(),
      ),
    );
  }
}
