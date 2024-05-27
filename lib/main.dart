import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/customer/cubit/customer_cubit.dart';
import 'package:santexnika_crm/screens/expenses/cubit/expenses_cubit.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/screens/returned_ones/cubit/returned_store_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/access/access_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/category/category_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/screens/splash/splash.dart';
import 'package:santexnika_crm/screens/statistic/cubits/statistic_cubit.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waitingWithId/waitin_with_id_cubit.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/tools/locator.dart';
import 'package:santexnika_crm/tools/prefs.dart';
import 'package:santexnika_crm/tools/responsive.dart';
import 'package:dio_request_inspector/presentation/main/page/main_page.dart';

DioRequestInspector dioRequestInspector = DioRequestInspector(
  isDebugMode: kDebugMode,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerSingelton();
  await PrefUtils().initInstane();

  isProduction = true;

  runApp(
    DioRequestInspectorMain(
      inspector: dioRequestInspector,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginCubit()),
          BlocProvider(create: (_) => UsersCubit()),
          BlocProvider(create: (_) => BranchesCubit()),
          BlocProvider(create: (_) => CategoryCubit()),
          BlocProvider(create: (_) => AccessCubit()),
          BlocProvider(create: (_) => TypesCubit()),
          BlocProvider(create: (_) => PriceCubit()),
          BlocProvider(create: (_) => CompanyCubit()),
          BlocProvider(create: (_) => StoreCubit()),
          BlocProvider(create: (_) => CustomerCubit()),
          BlocProvider(create: (_) => BasketCubit()),
          BlocProvider(create: (_) => ExpensesCubit()),
          BlocProvider(create: (_) => SoldCubit()),
          BlocProvider(create: (_) => ReturnedStoreCubit()),
          BlocProvider(create: (_) => CustomerWithIdCubit()),
          BlocProvider(create: (_) => ShowCompanyCubit()),
          BlocProvider(create: (_) => WaitingCubit()),
          BlocProvider(create: (_) => WaitingWithIdCubit()),
          BlocProvider(create: (_) => StatisticCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Size designSize = ResponsiveLayout.isMobile(context)
        ? const Size(430, 600)
        : ResponsiveLayout.isTablet(context)
            ? const Size(820, 1110)
            : const Size(1680, 1050);

    return ScreenUtilInit(
      designSize: designSize,
      child: GetMaterialApp(
        navigatorKey: dioRequestInspector.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
