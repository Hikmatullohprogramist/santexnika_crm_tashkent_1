import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/customer/customer_main.dart';
import 'package:santexnika_crm/screens/expenses/expenses_main.dart';
import 'package:santexnika_crm/screens/firms/firms_main.dart';
import 'package:santexnika_crm/screens/returned_ones/returned_ones_main.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/screens/settings/settings_main.dart';
import 'package:santexnika_crm/screens/sold/sold_main.dart';
import 'package:santexnika_crm/screens/statistic/statistic_main.dart';
import 'package:santexnika_crm/screens/store/pages/mobile/store_mobile/store_mobile.dart';
import 'package:santexnika_crm/screens/trade/trade_main.dart';
import 'package:santexnika_crm/tools/prefs.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/text_widget/text_widget.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<UsersCubit, UsersState>(
            builder: (BuildContext context, UsersState state) {
              if (state is UserLoadingState) {
                return const CircularProgressIndicator.adaptive();
              } else if (state is UserEmptyState) {
                return UserAccountsDrawerHeader(
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/img.png'),
                  ),
                  accountName: const TextWidget(txt: 'empty'),
                  accountEmail: const TextWidget(
                    txt: 'empty',
                  ),
                  decoration: BoxDecoration(color: AppColors.primaryColor),
                );
              }
              if (state is UserSuccessState) {
                return UserAccountsDrawerHeader(
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/img.png'),
                  ),
                  accountName: TextWidget(txt: state.data.data[0].name),
                  accountEmail: TextWidget(
                    txt: state.data.data[0].phone,
                  ),
                  decoration: BoxDecoration(color: AppColors.primaryColor),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          ListTile(
            onTap: () {
              Get.off(const TradeMain());
            },
            leading: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Savdo",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const StoreMobileUI());
            },
            leading: Icon(
              Icons.store,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Ombor",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const CustomerMain());
            },
            leading: Icon(
              Icons.people,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Haridorlar",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const ExpensesMain());
            },
            leading: Icon(
              Icons.payments_outlined,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Chiqimlar",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const SoldMain());
            },
            leading: Icon(
              Icons.sell,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Sotilganlar",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const ReturnedOnesMain());
            },
            leading: Icon(
              Icons.refresh,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Qaytarilganlar",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const FirmsMain());
            },
            leading: Icon(
              Icons.home,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Firmalar",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const StatisticMain());
            },
            leading: Icon(
              Icons.stacked_bar_chart_outlined,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Statistika",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Get.off(const SettingsMain());
            },
            leading: Icon(
              Icons.settings,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Sozlamalar",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              PrefUtils().clearAll();
            },
            leading: Icon(
              Icons.exit_to_app,
              color: AppColors.primaryColor,
            ),
            title: TextWidget(
              txt: "Chiqish",
              txtColor: AppColors.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
