import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/dialog_widgets.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';

import '../../../../errors/service_error.dart';
import '../../../../tools/appColors.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../cubit/branches/branches_cubit.dart';
import '../../cubit/category/category_cubit.dart';

class UpdateCategoryWidges extends StatefulWidget {
  final String name;
  final int branchId;
  final int categoryId;
  const UpdateCategoryWidges(
      {super.key,
      required this.name,
      required this.branchId,
      required this.categoryId});

  @override
  State<UpdateCategoryWidges> createState() => _UpdateCategoryWidgesState();
}

class _UpdateCategoryWidgesState extends State<UpdateCategoryWidges> {
  TextEditingController txtCategoryNameController = TextEditingController();
  int? selectedValuee;

  @override
  void initState() {
    txtCategoryNameController.text = widget.name;
    selectedValuee = widget.branchId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchesCubit, BranchesState>(
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
          return DialogWidgets(
            txtName: "Category",
            txtFiledName: 'Nomi',
            txtFiledName1: 'Branch_id',
            txtFiledController: txtCategoryNameController,
            // Ensure txtCategoryNameController is defined
            visible: true,
            txt: "Branchni tanlang",
            onTap: () {
              if (txtCategoryNameController.text.isEmpty ||
                  selectedValuee == null) {
                errorDialogWidgets(context);
              } else {
                context
                    .read<CategoryCubit>()
                    .updateCategory(
                      txtCategoryNameController.text,
                      selectedValuee.toString(),
                      widget.categoryId,
                    )
                    .then(
                      (value) => Navigator.pop(context),
                    );
              }
            },
            child: BlocBuilder<BranchesCubit, BranchesState>(
              builder: (BuildContext context, BranchesState state) {
                if (state is BranchesSuccessState) {
                  return DropdownButtonHideUnderline(
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
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
