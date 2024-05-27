
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/input/phone_input.dart';
import '../../../../../widgets/mobile/button.dart';
import '../../../../../widgets/mobile/mobile_input.dart';
import '../../../../../widgets/my_dialog_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../settings/cubit/branches/branches_cubit.dart';
import '../../../cubit/company_cubit.dart';

class MobileAddFirms extends StatefulWidget {
  const MobileAddFirms({super.key});

  @override
  State<MobileAddFirms> createState() => _MobileAddFirmsState();
}

class _MobileAddFirmsState extends State<MobileAddFirms> {
  int? selectedValuee;
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const TextWidget(txt: "Firma qo'shish"),
          BlocConsumer<BranchesCubit, BranchesState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is BranchesLoadingState) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is BranchesErrorState) {
                return ApiErrorMessage(
                    errorMessage:
                    state.error); // Ensure postError is defined
              } else if (state is BranchesSuccessState) {
                return BlocBuilder<BranchesCubit, BranchesState>(
                  builder: (BuildContext context, BranchesState state) {
                    if (state is BranchesSuccessState) {
                      return Container(
                        height: 40,
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
          MobileInput(
            controller: txtName,
            label: "Firma nomi",
          ),
          PhoneInput(
            controller: txtPhone,
            label: "Telefon no'mer",
            inputWidth: double.infinity,
          ),
          Row(
            children: [
              Expanded(
                child: MobileButton(
                  label: "Bekor qilish",
                  icon: const Icon(Icons.exit_to_app,color: Colors.white,size: 20,),
                  onTap: (){
                    Get.back();
                  },
                ),
              ),
              const Wd(),
              Expanded(
                child: MobileButton(
                  label: "Saqlash",
                  icon: Icon(Icons.save,color: Colors.white,size: 20,),
                  onTap: ()async{

                    if (txtName.text.isEmpty ||
                        txtPhone.text.isEmpty ||
                        selectedValuee == null) {
                      errorDialogWidgets(context);
                    } else {
                      await context
                          .read<CompanyCubit>()
                          .postCompany(
                        selectedValuee ?? 1,
                        txtName.text,
                        txtPhone.text
                            .replaceAll("+998 ", "")
                            .replaceAll("(", "")
                            .replaceAll(")", "")
                            .replaceAll(" ", "")
                            .replaceAll("-", ""),
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
    );
  }
}
