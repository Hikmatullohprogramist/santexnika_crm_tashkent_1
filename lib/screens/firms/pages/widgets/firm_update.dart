import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/phone_input.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:get/get.dart';

import '../../../../errors/service_error.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../settings/cubit/branches/branches_cubit.dart';

class CompanyUpdateDialogWidgets extends StatefulWidget {
  final String txtName;
  final String txtPhone;
  // final String txtDebt;
  final int id;
  final int branchId;

  const CompanyUpdateDialogWidgets(
      {super.key,
      required this.txtName,
      required this.txtPhone,
      // required this.txtDebt,
      required this.id, required this.branchId});

  @override
  State<CompanyUpdateDialogWidgets> createState() =>
      _CompanyUpdateDialogWidgetsState();
}

class _CompanyUpdateDialogWidgetsState
    extends State<CompanyUpdateDialogWidgets> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtDebt = TextEditingController();
  int? selectedValuee;

  @override
  void initState() {
    txtName.text = widget.txtName;
    txtPhone.text = widget.txtPhone;
    // txtDebt.text = widget.txtDebt;
    selectedValuee = widget.branchId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 550.w,
        height: 550.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.bottombarColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const TextWidget(txt: "Yangi firma qo'shish"),
              Column(
                children: [
                  BlocConsumer<BranchesCubit, BranchesState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is BranchesLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is BranchesErrorState) {
                        return const TextWidget(
                          txt: postError,
                        ); // Ensure postError is defined
                      } else if (state is BranchesSuccessState) {
                        return BlocBuilder<BranchesCubit, BranchesState>(
                          builder: (BuildContext context, BranchesState state) {
                            if (state is BranchesSuccessState) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primaryColor,
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: AppColors.primaryColor,
                                    focusColor: Colors.black,
                                    value: selectedValuee,
                                    items: state.data.map((value) {
                                      return DropdownMenuItem(
                                        value: value.id,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: TextWidget(
                                            txt: value.name ?? "",
                                            txtColor: Colors.white,
                                            size: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValuee = value;
                                        print(selectedValuee);
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
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  Hg(
                    height: 20.h,
                  ),
                  PostInput(
                    controller: txtName,
                    label: 'Firma Nomi',
                    inputWidth: double.infinity,
                  ),
                  Hg(
                    height: 20.h,
                  ),
                  PhoneInput(
                    controller: txtPhone,
                    label: "Telefon nomeri",
                    inputWidth: double.infinity,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ButtonWidget(
                      label: "Bekor qilish",
                      icon: Icons.exit_to_app,
                      color: AppColors.primaryColor,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  Wd(
                    width: 40.w,
                  ),
                  Expanded(
                    child: ButtonWidget(
                      icon: Icons.save,
                      label: "Saqlash",
                      color: AppColors.primaryColor,
                      onTap: () async {
                        if (txtName.text.isEmpty ||
                            txtPhone.text.isEmpty ||
                            selectedValuee == null) {
                          errorDialogWidgets(context);
                        } else {
                          await context
                              .read<CompanyCubit>()
                              .updateCompany(
                                selectedValuee ?? 1,
                                txtName.text,
                                txtPhone.text
                                    .replaceAll("+998 ", "")
                                    .replaceAll("(", "")
                                    .replaceAll(")", "")
                                    .replaceAll(" ", "")
                                    .replaceAll("-", ""),
                                widget.id,
                              )
                              .then((_) {
                            Navigator.of(context).pop(); // Close the dialog
                          }).catchError((error) {
                            print(error);
                          });
                        }
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
}
