import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/widgets/input/parol_input.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/chek_box.dart';
import '../../../../widgets/my_dialog_widget.dart';
import '../../cubit/access/access_cubit.dart';
import '../../cubit/branches/branches_cubit.dart';
import '../../cubit/users/users_cubit.dart';

class MobileUserAddScreen extends StatefulWidget {
  final bool forAdd;
  final String? name;
  final String? phone;
  final String? password;
  final int? selectedValuee;
  final List<int>? selectedAccess;

  const MobileUserAddScreen(
      {super.key,
      required this.forAdd,
      this.name,
      this.phone,
      this.password,
      this.selectedAccess,
      this.selectedValuee});

  @override
  State<MobileUserAddScreen> createState() => _MobileUserAddScreenState();
}

class _MobileUserAddScreenState extends State<MobileUserAddScreen> {
  List<int> selectedAccess = [];
  TextEditingController txtLogin = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  int? selectedValuee;
  int? userType;
  bool isVisible = true;
  String? title;
  bool isSelected = false;

  @override
  void initState() {
    txtPhone.text = '998';
    if (widget.forAdd) {
      title = "qo'shishi";
    } else {
      title = "o'zgartirish";
      txtLogin.text = widget.name ?? '';
      txtPhone.text = widget.phone ?? '';
      selectedValuee = widget.selectedValuee;
      selectedAccess = widget.selectedAccess ?? [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const Hg(),
          TextWidget(txt: "Foydalanuvchilar $title"),
          Hg(),
          MobileInput(
            controller: txtLogin,
            label: "Foydalanuvchi nomi",
          ),
          Hg(),
          MobileInput(
            controller: txtPhone,
            inputWidth: double.infinity,
            label: "Telefon no'mer",
          ),
          Hg(),
          ParolInput(
            controller: txtPassword,
            label: "Parol",
            miLenght: 6,
            inputWidth: double.infinity,
          ),
          Hg(),
          BlocBuilder<BranchesCubit, BranchesState>(
            builder: (BuildContext context, BranchesState state) {
              if (state is BranchesSuccessState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      txt: "Filialni  tanlang!",
                      size: 14,
                    ),
                    Hg(
                      height: 8.h,
                    ),
                    Container(
                      height: 40.spMax,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          5.r,
                        ),
                        border: Border.all(
                          color: AppColors.borderColor,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: AppColors.primaryColor,
                          focusColor: Colors.black,
                          value: selectedValuee,
                          items: state.data.map(
                            (value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: TextWidget(
                                    txt: value.name ?? "",
                                    txtColor: Colors.white,
                                    size: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValuee = value;
                            });
                          },
                          isExpanded: true,
                          hint: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            child: const Text(
                              "Branchni tanlang!",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Hg(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                txt: "Rolni tanlang!",
                size: 14,
              ),
              Hg(
                height: 8.h,
              ),
              Container(
                height: 40.spMax,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(
                    5.r,
                  ),
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: AppColors.primaryColor,
                    focusColor: Colors.black,
                    value: userType,
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TextWidget(
                            txt: "Sotuvchi",
                            txtColor: Colors.white,
                            size: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TextWidget(
                            txt: "Admin",
                            txtColor: Colors.white,
                            size: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        userType = value;
                      });
                    },
                    isExpanded: true,
                    hint: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      child: const Text(
                        "Rolni tanlang!",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Hg(),
          const TextWidget(
            txt: "Ushbu foydalanuvchiga qaysi oynalar ochilsin ?",
            size: 14,
          ),
          const Hg(),
          BlocBuilder<AccessCubit, AccessState>(
            builder: (BuildContext context, AccessState state) {
              if (state is AccessSuccessState) {
                return Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.data.length,
                    itemBuilder: (ctx, index) {
                      var data = state.data[index];

                      if (!widget.forAdd) {
                        isSelected = selectedAccess!.contains(data.id);
                      }

                      return CheckBoxWidget(
                        onTap1: () {
                          setState(() {
                            if (selectedAccess.contains(data.id)) {
                              selectedAccess.remove(
                                data.id,
                              ); // Unselect if already selected
                            } else {
                              selectedAccess.add(data.id!);
                            }
                          });
                        },
                        isVisible: isSelected,
                        txt: data.name ?? "",
                        onTap: (value) {
                          setState(() {
                            if (selectedAccess.contains(data.id)) {
                              selectedAccess.remove(
                                data.id,
                              ); // Unselect if already selected
                            } else {
                              selectedAccess.add(data.id!);
                            }
                          });
                        },
                        size: 14.sp,
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 1,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MobileButton(
                    label: "Bekor qilish",
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                Wd(),
                Expanded(
                  child: MobileButton(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: "Saqlash",
                    onTap: () {
                      if (txtLogin.text.isEmpty ||
                          txtPhone.text.isEmpty ||
                          txtPassword.text.isEmpty ||
                          selectedAccess.isEmpty ||
                          selectedValuee == null) {
                        errorDialogWidgets(context);
                      } else {
                        context
                            .read<UsersCubit>()
                            .postUser(
                                txtLogin.text,
                                txtPhone.text,
                                txtPassword.text,
                                selectedAccess,
                                selectedValuee!,
                                userType!)
                            .catchError((onError) {
                          print(onError);
                        }).then(
                          (value) {
                            Get.back();
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
