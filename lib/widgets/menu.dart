import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/models/user/login_model.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/profile_widget.dart';

import 'sized_box.dart';
import 'tab_widgets/menu_widget.dart';

class MenuWidget extends StatefulWidget {
  final bool isSelected1;
  final bool isSelected2;
  final bool isSelected3;
  final bool isSelected4;
  final bool isSelected5;
  final bool isSelected6;
  final bool isSelected7;
  final bool isSelected8;
  final bool isSelected9;
  final bool isSelected10;
  final VoidCallback onTap1;
  final VoidCallback onTap2;
  final VoidCallback onTap3;
  final VoidCallback onTap4;
  final VoidCallback onTap5;
  final VoidCallback onTap6;
  final VoidCallback onTap7;
  final VoidCallback onTap8;
  final VoidCallback onTap9;
  final VoidCallback onTap10;

  const MenuWidget({
    super.key,
    required this.isSelected1,
    required this.isSelected2,
    required this.isSelected3,
    required this.isSelected4,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
    required this.onTap4,
    required this.isSelected5,
    required this.isSelected6,
    required this.isSelected7,
    required this.onTap5,
    required this.onTap6,
    required this.onTap7,
    required this.onTap8,
    required this.isSelected8,
    required this.isSelected9,
    required this.onTap9,
    required this.isSelected10,
    required this.onTap10,
  });

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  bool hasScreen(List<UserAccess> userAccess, String page) {
    for (var access in userAccess) {
      if (access.access.name == page) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 2),
              blurRadius: 0,
            )
          ],
        ),
        width: 250.w,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.symmetric(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) return ApiLoadingWidget();
                  if (state is LoginSuccess) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        const ProfileWidgetDesktop(
                          isRow: false,
                        ),
                        Hg(
                          height: 50.h,
                        ),
                        TabMenuWidget(
                          txt: "Savdo",
                          svgIcon: Icon(
                            Icons.shopping_cart,
                            color: widget.isSelected1
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isSelected: widget.isSelected1,
                          onTap: widget.onTap1,
                          isVisible: hasScreen(state.data.userAccess, "Savdo"),
                        ),
                        TabMenuWidget(
                          txt: "Ombor",
                          svgIcon: Icon(
                            Icons.store,
                            color: widget.isSelected2
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isSelected: widget.isSelected2,
                          onTap: widget.onTap2,
                          isVisible: hasScreen(state.data.userAccess, "Ombor"),
                        ),
                        TabMenuWidget(
                          txt: "Haridorlar",
                          isSelected: widget.isSelected3,
                          onTap: widget.onTap3,
                          svgIcon: Icon(
                            Icons.people,
                            color: widget.isSelected3
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible:
                              hasScreen(state.data.userAccess, "Haridorlar"),
                        ),
                        TabMenuWidget(
                          txt: "Chiqimlar ",
                          isSelected: widget.isSelected9,
                          onTap: widget.onTap9,
                          svgIcon: Icon(
                            Icons.payments_outlined,
                            color: widget.isSelected9
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible:
                              hasScreen(state.data.userAccess, "Chiqimlar"),
                        ),
                        TabMenuWidget(
                          txt: "Sotilganlar",
                          isSelected: widget.isSelected10,
                          onTap: widget.onTap10,
                          svgIcon: Icon(
                            Icons.sell,
                            color: widget.isSelected10
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible:
                              hasScreen(state.data.userAccess, "Sotilganlar"),
                        ),
                        TabMenuWidget(
                          txt: "Qaytarilganlar",
                          isSelected: widget.isSelected4,
                          onTap: widget.onTap4,
                          svgIcon: Icon(
                            Icons.refresh,
                            color: widget.isSelected4
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible: hasScreen(
                              state.data.userAccess, "Qaytarilganlar"),
                        ),
                        TabMenuWidget(
                          txt: "Firmalar",
                          isSelected: widget.isSelected5,
                          onTap: widget.onTap5,
                          svgIcon: Icon(
                            Icons.home,
                            color: widget.isSelected5
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible:
                              hasScreen(state.data.userAccess, "Firmalar"),
                        ),
                        TabMenuWidget(
                          txt: "Statistika",
                          isSelected: widget.isSelected6,
                          onTap: widget.onTap6,
                          svgIcon: Icon(
                            Icons.stacked_bar_chart_outlined,
                            color: widget.isSelected6
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible:
                              hasScreen(state.data.userAccess, "Statistika"),
                        ),
                        TabMenuWidget(
                          txt: "Sozlamalar",
                          isSelected: widget.isSelected7,
                          onTap: widget.onTap7,
                          svgIcon: Icon(
                            Icons.settings,
                            color: widget.isSelected7
                                ? AppColors.selectedColor
                                : Colors.grey,
                          ),
                          isVisible:
                              hasScreen(state.data.userAccess, "Sozlamalar"),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TabMenuWidget(
                  txt: "Chiqish",
                  isSelected: widget.isSelected8,
                  onTap: widget.onTap8,
                  svgIcon: Icon(
                    Icons.arrow_back,
                    color: widget.isSelected8
                        ? AppColors.selectedColor
                        : Colors.grey,
                  ),
                  isVisible: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
