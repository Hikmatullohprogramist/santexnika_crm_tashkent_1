import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/settings/cubit/access/access_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/parol_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:get/get.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/chek_box.dart';
import '../../../../widgets/input/post_input.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';

class UserUpdate extends StatefulWidget {
  final String login;
  final String phone;
  final List<int> access;
  final int? userType;
  final int branchId;
  final int userId;

  const UserUpdate(
      {super.key,
      required this.login,
      required this.phone,
      required this.access,
      required this.userType,
      required this.branchId,
      required this.userId});

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  List<int> selectedAccess = [];
  TextEditingController txtLogin = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  int? selectedValuee;
  int? userType;
  bool isVisible = true;

  @override
  void initState() {
    txtPhone.text = widget.phone;
    txtLogin.text = widget.login;

    selectedAccess = widget.access;
    userType = widget.userType;
    selectedValuee = widget.branchId;
    txtPassword.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500.w,
        decoration: BoxDecoration(
          color: AppColors.bottombarColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18.0.w,
            vertical: 10.h,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(txt: "Foydalanuvchilar qo'shish"),
                    ],
                  ),
                  const Hg(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ParolInput(
                        inputWidth: double.infinity,
                        label: "Foydalanuvchi nomi",
                        controller: txtLogin,
                        color: AppColors.primaryColor,
                        miLenght: 5,
                        isVisible: false,
                      ),
                      Hg(
                        height: 20.h,
                      ),
                      PostInput(
                        inputWidth: double.infinity,
                        label: 'Telefon nomer',
                        controller: txtPhone,
                      ),
                      Hg(
                        height: 20.h,
                      ),
                      ParolInput(
                        inputWidth: double.infinity,
                        label: 'Parol',
                        controller: txtPassword,
                        miLenght: 6,
                      ),
                      Hg(
                        height: 20.h,
                      ),
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
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
                      Hg(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            txt: "Roleni tanlang!",
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: TextWidget(
                                        txt: "Admin",
                                        txtColor: Colors.white,
                                        size: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: TextWidget(
                                        txt: "Sotuvchi",
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
                    ],
                  ),
                  const Hg(),
                  const TextWidget(
                    txt: "Ushbu foydalanuvchiga qaysi oynalar ochilsin ?",
                  ),
                  Hg(
                    height: 30.h,
                  ),
                  BlocBuilder<AccessCubit, AccessState>(
                    builder: (BuildContext context, AccessState state) {
                      if (state is AccessSuccessState) {
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: state.data.length,
                          itemBuilder: (ctx, index) {
                            var data = state.data[index];
                            bool isSelected = selectedAccess.contains(data.id);

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
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 1,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  Hg(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(
                        width: 200.w,
                        label: "Bekor qilish",
                        icon: Icons.exit_to_app,
                        color: AppColors.primaryColor,
                        onTap: () {
                          Get.back();
                        },
                      ),
                      ButtonWidget(
                        width: 200.w,
                        icon: Icons.save,
                        label: "Saqlash",
                        color: AppColors.primaryColor,
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
                                .updateUser(
                                  txtLogin.text,
                                  txtPhone.text,
                                  txtPassword.text.trim(),
                                  selectedAccess,
                                  selectedValuee!,
                                  userType!,
                                  widget.userId,
                                )
                                .catchError((onError) {
                              if (kDebugMode) {
                                print(onError);
                              }
                            }).then(
                              (value) {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
