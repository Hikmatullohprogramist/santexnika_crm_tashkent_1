// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:santexnika_crm/models/user/login_model.dart';
import 'package:santexnika_crm/screens/expenses/expenses_main.dart';
import 'package:santexnika_crm/screens/firms/firms_main.dart';
import 'package:santexnika_crm/screens/returned_ones/returned_ones_main.dart';
import 'package:santexnika_crm/screens/settings/settings_main.dart';
import 'package:santexnika_crm/screens/sold/sold_main.dart';
import 'package:santexnika_crm/screens/statistic/statistic_main.dart';
import 'package:santexnika_crm/screens/store/store.dart';

import '../screens/customer/customer_main.dart';
import '../screens/trade/trade_main.dart';

bool isProduction = false;

class AppConstants {
  static String BASE_URL =
      "http://${isProduction == true ? "production." : ""}tillo2sp.beget.tech/api/";
  static const double DEFAULT_PADDING = 16;
  static const String ACCESS_TOKEN = "token";
  static List<Widget> pages = [
       TradeMain(),
        StorePage(),
        CustomerMain(),
        ReturnedOnesMain(),
        FirmsMain(),
        StatisticMain(),
        SettingsMain(),
        ExpensesMain(),
        SoldMain(),
  ];
  static bool isAccessEditAndDelete = true;


  static String currentBranch = "";
  static String currentBranchUser = "";
  // static List<Widget> getPages(List<UserAccess> userAccess) {
  //   List<Widget> pages = List.filled(userAccess.length, Text("")); // Initialize list with null values
  //
  //   for (var element in userAccess) {
  //     switch (element.access.name) {
  //       case "Savdo":
  //         pages.insert(element.id, TradeMain());
  //         break;
  //       case "Ombor":
  //         pages.insert(element.id, StorePage());
  //         break;
  //       case "Haridorlar":
  //         pages.insert(element.id, CustomerMain());
  //         break;
  //       case "Chiqimlar":
  //         pages.insert(element.id, ExpensesMain());
  //         break;
  //       case "Sotilganlar":
  //         pages.insert(element.id, SoldMain());
  //         break;
  //       case "Qaytarilganlar":
  //         pages.insert(element.id, ReturnedOnesMain());
  //         break;
  //       case "Firmalar":
  //         pages.insert(element.id, FirmsMain());
  //         break;
  //       case "Statistika":
  //         pages.insert(element.id, StatisticMain());
  //         break;
  //       case "Sozlamalar":
  //         pages.insert(element.id, SettingsMain());
  //         break;
  //       default:
  //         break;
  //     }
  //   }
  //
  //   if (kDebugMode) {
  //      print("PAGES LENGTH ${pagess.length} pages index");
  //   }
  //
  //   pagess = pages;
  //   return pagess;
  // }

}
