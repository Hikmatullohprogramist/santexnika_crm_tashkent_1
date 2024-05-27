import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/login/page/login_main.dart';
import 'package:santexnika_crm/screens/main/main.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/locator.dart';
import 'package:santexnika_crm/tools/prefs.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    if (mounted) {
      Timer(const Duration(seconds: 2), () {
        if (kDebugMode) {
          print(getIt.get<PrefUtils>().getToken());
        }
        Get.offAll(
          getIt.get<PrefUtils>().getToken().isNotEmpty
              ? const MainScreen()
              : const LoginMain(),
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: const Center(
        child: TextWidget(
          txt: "Santexnika CRM",
          size: 30,
        ),
        // child: Image(
        //   image: AssetImage("assets/logo.jpg"),
        // ),
      ),
    );
  }
}
