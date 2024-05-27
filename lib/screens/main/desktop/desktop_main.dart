import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/expenses/expenses_main.dart';
import 'package:santexnika_crm/screens/firms/firms_main.dart';
import 'package:santexnika_crm/screens/returned_ones/returned_ones_main.dart';
import 'package:santexnika_crm/screens/settings/settings_main.dart';
import 'package:santexnika_crm/screens/sold/sold_main.dart';
import 'package:santexnika_crm/screens/statistic/statistic_main.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/store_desktop.dart';
import 'package:santexnika_crm/screens/store/store.dart';
import 'package:santexnika_crm/screens/trade/trade_main.dart';
import 'package:santexnika_crm/tools/locator.dart';
import 'package:santexnika_crm/tools/prefs.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import '../../../models/user/login_model.dart';
import '../../../tools/appColors.dart';
import '../../../tools/constantas.dart';
import '../../../tools/responsive.dart';
import '../../../widgets/menu.dart';
import '../../customer/customer_main.dart';
import '../../login/cubit/login_cubit.dart';
import '../../settings/cubit/branches/branches_cubit.dart';

class DesktopMain extends StatefulWidget {
  const DesktopMain({super.key});

  @override
  State<DesktopMain> createState() => _DesktopMainState();
}

class _DesktopMainState extends State<DesktopMain> {
  bool isSelected1 = true;

  bool isSelected2 = false;

  bool isSelected3 = false;

  bool isSelected4 = false;

  bool isSelected5 = false;

  bool isSelected6 = false;

  bool isSelected7 = false;

  bool isSelected8 = false;
  bool isSelected9 = false;
  bool isSelected10 = false;

  onTap1() {
    setState(() {
      isSelected1 = true;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 0;
    });
  }

  onTap2() {
    setState(() {
      isSelected1 = false;
      isSelected2 = true;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 1;
    });
  }

  onTap3() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = true;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 2;
    });
  }

  onTap4() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = true;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 3;
    });
  }

  onTap5() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = true;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 4;
    });
  }

  onTap6() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = true;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 5;
    });
  }

  onTap7() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = true;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = false;

      currentIndex = 6;
    });
  }

  onTap8() {
    // setState(() {
    //   isSelected1 = false;
    //   isSelected2 = false;
    //   isSelected3 = false;
    //   isSelected4 = false;
    //   isSelected5 = false;
    //   isSelected6 = false;
    //   isSelected7 = false;
    //   isSelected8 = true;
    //
    //   currentIndex = 6;
    // });
    getIt.get<PrefUtils>().clearAll();
  }

  onTap9() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = true;
      isSelected10 = false;

      currentIndex = 7;
    });
  }

  onTap10() {
    setState(() {
      isSelected1 = false;
      isSelected2 = false;
      isSelected3 = false;
      isSelected4 = false;
      isSelected5 = false;
      isSelected6 = false;
      isSelected7 = false;
      isSelected8 = false;
      isSelected9 = false;
      isSelected10 = true;

      currentIndex = 8;
    });
  }

  int currentIndex = 0;
  List<Widget> pages = [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BranchesCubit>().getBranches();
      await context.read<LoginCubit>().getAuthUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveLayout.isDesktop(context)
                ? MenuWidget(
                    isSelected1: isSelected1,
                    isSelected2: isSelected2,
                    isSelected3: isSelected3,
                    isSelected4: isSelected4,
                    isSelected5: isSelected5,
                    isSelected6: isSelected6,
                    isSelected7: isSelected7,
                    isSelected8: isSelected8,
                    isSelected9: isSelected9,
                    isSelected10: isSelected10,
                    onTap1: onTap1,
                    onTap2: onTap2,
                    onTap3: onTap3,
                    onTap4: onTap4,
                    onTap5: onTap5,
                    onTap6: onTap6,
                    onTap7: onTap7,
                    onTap8: onTap8,
                    onTap9: onTap9,
                    onTap10: onTap10,
                  )
                : const SizedBox(),
            Expanded(
              child: Container(
                child: AppConstants.pages[currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
