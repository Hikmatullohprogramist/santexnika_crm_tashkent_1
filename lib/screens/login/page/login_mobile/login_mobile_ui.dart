import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/screens/main/main.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/input/parol_input.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../settings/cubit/users/users_cubit.dart';

class LoginMobileUI extends StatefulWidget {
  const LoginMobileUI({super.key});

  @override
  State<LoginMobileUI> createState() => _LoginMobileUIState();
}

class _LoginMobileUIState extends State<LoginMobileUI> {
  bool visible = true;
  String selectedValue = '';
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     context
  //         .read<LoginCubit>()
  //         .getToken(loginController.text, passwordController.text);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    loginController.text = '+998907758032';
    passwordController.text = 'secret';
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Center(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (BuildContext context, LoginState kattaState) {
            if (kattaState is LoginSuccess) {
              Get.offAll(const MainScreen());
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (BuildContext context, LoginState state) {
              bool showRetryContainer = false;

              if (state is LoginLoading) {
                return CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                );
              } else if (state is LoginError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PostInput(
                        inputWidth: MediaQuery.sizeOf(context).width,
                        controller: loginController,
                        label: "Login",
                      ),
                      const Hg(
                        height: 30,
                      ),
                      ParolInput(
                        inputWidth: MediaQuery.sizeOf(context).width,
                        controller: passwordController,
                        label: "Parol",
                        miLenght: 10,
                        isVisible: visible,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          child: Icon(
                            visible
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (showRetryContainer)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 175),
                          padding: const EdgeInsets.all(12),
                          // Retry Container
                          decoration: BoxDecoration(
                            color: Colors.red, // Customize the color as needed
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.white),
                              SizedBox(width: 8.0),
                              Text(
                                'Login yoki parolda xatolik',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      const Hg(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: MobileButton(
                                height: 50,
                                label: "Chiqish",
                                icon: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                            ),
                            const Wd(),
                            Expanded(
                              child: MobileButton(
                                height: 50,
                                label: "Kirish",
                                icon: const Icon(
                                  Icons.assistant_direction,
                                  color: Colors.white,
                                ),
                                color: AppColors.selectedColor,
                                onTap: () {
                                  Get.off(
                                    const MainScreen(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 500,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const TextWidget(
                            txt: 'Santexnika CRM',
                            size: 30,
                          ),
                          MobileInput(
                            inputWidth: MediaQuery.sizeOf(context).width,
                            controller: loginController,
                            label: "Login",
                            inputHeight: 46,
                          ),
                          ParolInput(
                            inputWidth: MediaQuery.sizeOf(context).width,
                            controller: passwordController,
                            label: "Parol",
                            miLenght: 10,
                            isVisible: visible,
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                              child: Icon(
                                visible
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                               Expanded(
                                child: MobileButton(
                                  height: 50,
                                  label: "Chiqish",
                                  icon: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                  ), onTap: () {  },
                                ),
                              ),
                              const Wd(),
                              Expanded(
                                child: MobileButton(
                                  height: 50,
                                  label: "Kirish",
                                  icon: const Icon(
                                    Icons.assistant_direction,
                                    color: Colors.white,
                                  ),
                                  color: AppColors.selectedColor,
                                  onTap: () {
                                    context
                                        .read<LoginCubit>()
                                        .getToken(
                                          loginController.text,
                                          passwordController.text,
                                        )
                                        .then(
                                          (value) => context
                                              .read<UsersCubit>()
                                              .getUsers(),
                                        );
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
