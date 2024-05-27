// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/screens/main/main.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../widgets/input/parol_input.dart';

class LoginDesktopUI extends StatefulWidget {
  const LoginDesktopUI({super.key});

  @override
  State<LoginDesktopUI> createState() => _LoginDesktopUIState();
}

class _LoginDesktopUIState extends State<LoginDesktopUI> {
  String selectedValue = '';
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loginController.text = kDebugMode ?  '+998907758032' : '';
    passwordController.text =kDebugMode ? 'secret' : '';
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Center(
        child: Container(
          width: 600.w,
          height: 500.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.bottombarColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.toqPrimaryColor,
                offset: const Offset(0.1, 0.1),
                blurRadius: 30,
              )
            ],
          ),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (BuildContext context, LoginState kattaState) {
              if (kattaState is LoginSuccess) {
                Get.offAll(MainScreen());
              }
            },
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                bool showRetryContainer = false;
                if (state is LoginLoading) {
                  return const ApiLoadingWidget();
                } else if (state is LoginError) {
                  showRetryContainer = true;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                      vertical: 40.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget(txt: "For logo"),
                        const Hg(),
                        PostInput(
                          controller: loginController,
                          label: "Login",
                        ),
                        const Hg(),
                        ParolInput(
                          controller: passwordController,
                          label: "Parol",
                          miLenght: 4,
                          color: AppColors.primaryColor,
                        ),
                        if (showRetryContainer) Container(
                            margin: const EdgeInsets.symmetric(horizontal: 175),
                            padding: const EdgeInsets.all(12),
                            // Retry Container
                            decoration: BoxDecoration(
                              color:
                                  Colors.red, // Customize the color as needed
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.error, color: Colors.white),
                                SizedBox(width: 8.0),
                                Text(
                                  'Login yoki parolda xatolik',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        Hg(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonWidget(
                              width: 150.w,
                              color: AppColors.primaryColor,
                              label: "Chiqish",
                              icon: Icons.arrow_back,
                            ),
                            const Wd(),
                            ButtonWidget(
                              width: 150.w,
                              color: AppColors.primaryColor,
                              label: "Kirish",
                              icon: Icons.exit_to_app,
                              onTap: () {
                                context.read<LoginCubit>().getToken(
                                      loginController.text,
                                      passwordController.text,
                                    );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                      vertical: 40.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget(txt: "For logo"),
                        const Hg(),
                        PostInput(
                          controller: loginController,
                          label: "Login",
                        ),
                        const Hg(),
                        ParolInput(
                          controller: passwordController,
                          label: "Parol",
                          miLenght: 4,
                          color: AppColors.primaryColor,
                        ),
                        Hg(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonWidget(
                              width: 150.w,
                              color: AppColors.primaryColor,
                              label: "Chiqish",
                              icon: Icons.arrow_back,
                            ),
                            const Wd(),
                            ButtonWidget(
                              width: 150.w,
                              color: AppColors.primaryColor,
                              label: "Kirish",
                              icon: Icons.exit_to_app,
                              onTap: () {
                                context.read<LoginCubit>().getToken(
                                      loginController.text,
                                      passwordController.text,
                                    );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
