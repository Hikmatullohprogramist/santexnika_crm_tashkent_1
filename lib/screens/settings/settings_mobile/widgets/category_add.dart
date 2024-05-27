import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/mobile/mobile_input.dart';
import '../../../../widgets/my_dialog_widget.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../cubit/branches/branches_cubit.dart';
import '../../cubit/category/category_cubit.dart';

class MobileCategoryAdd extends StatefulWidget {
  const MobileCategoryAdd({super.key});

  @override
  State<MobileCategoryAdd> createState() => _MobileCategoryAddState();
}

class _MobileCategoryAddState extends State<MobileCategoryAdd> {
  TextEditingController txtCategoryNameController = TextEditingController();
  int? selectedValuee;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TextWidget(txt: "Kategoriya qo'shish"),
            const Hg(),
            MobileInput(
              controller: txtCategoryNameController,
              label: 'Nomi',
            ),
            const Hg(),
            BlocBuilder<BranchesCubit, BranchesState>(
              builder: (BuildContext context, BranchesState state) {
                if (state is BranchesSuccessState) {
                  return Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primaryColor,
                        border: Border.all(color: AppColors.borderColor)),
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
            ),
            Hg(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: MobileButton(
                    label: "Bekor qilish",
                    icon: const Icon(
                      Icons.exit_to_app,
                      size: 20,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                const Wd(),
                Expanded(
                  child: MobileButton(
                    label: "Saqlash",
                    onTap: () {
                      if (txtCategoryNameController.text.isEmpty ||
                          selectedValuee == null) {
                        mobileErrorDialogWidgets(context);
                      } else {
                        context
                            .read<CategoryCubit>()
                            .postCategory(
                              txtCategoryNameController.text,
                              selectedValuee
                                  .toString(), // Ensure txtCategoryBranchIdController is defined
                            )
                            .then(
                              (value) => Navigator.pop(context),
                            );
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
