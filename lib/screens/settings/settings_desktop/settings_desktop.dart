import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/models/branch/branch_model.dart';
import 'package:santexnika_crm/screens/settings/cubit/access/access_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/pages/access.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/pages/branch.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/pages/categories.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/pages/price.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/pages/types.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/pages/users.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/dialog.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/dialog_widgets.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/searchble_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../widgets/text_widget/text_widget.dart';
import 'add_widgets/category.dart';

class SettingsDesktopUI extends StatefulWidget {
  const SettingsDesktopUI({super.key});

  @override
  State<SettingsDesktopUI> createState() => _SettingsDesktopUIState();
}

class _SettingsDesktopUIState extends State<SettingsDesktopUI> {
  List<String> items = [
    "Foydalanuvchilar",
    "Filial",
    "Kategoriyalar",
    "Ruxsatlar",
    "Pul turi",
    "Valyuta",
  ];
  List pages = [
    const DesktopUsersUI(),
    const DesktopBranchUI(),
    const DesktopCategoriesUi(),
    const DesktopAccessUI(),
    const DesktopTypesUI(),
    const DesktopPriceUI(),
  ];
  List<String> add = [
    "Foydalanuvchi qo'shish",
    "Filial qo'shish",
    "Kategoriya qo'shish",
    "Ruxsat qo'shish",
    "Pul turi qo'shish",
    "Valyuta qo'shish",
  ];
  List<String> delete = [
    "Foydalanuvchi o'chirish",
    "Filial o'chirish",
    "Kategoriya o'chirish",
    "Ruxsat o'chirish",
    "Pul turi o'chirish",
    "Valyuta o'chirish",
  ];
  int currentIndex = 0;

  //branch
  TextEditingController txtBranchNameController = TextEditingController();
  TextEditingController txtBranchBarcodeController = TextEditingController();

  //category
  TextEditingController txtCategoryNameController = TextEditingController();

  //access
  TextEditingController txtAccessController = TextEditingController();

  //types
  TextEditingController txtTypesController = TextEditingController();

  //price
  TextEditingController txtPriceNamController = TextEditingController();

  List<BranchModel> branchModel = [];

  @override
  void dispose() {
    txtCategoryNameController.dispose();
    txtBranchBarcodeController.dispose();
    txtBranchNameController.dispose();
    txtAccessController.dispose();
    txtTypesController.dispose();
    txtPriceNamController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<UsersCubit>().getUsers();
    });
    super.initState();
  }

  int? selectedValuee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(txt: "Sozlamalar bo'limi")
                ],
              ),
            ),
          ),
          Hg(
            height: 1,
          ),
          Container(
            color: AppColors.primaryColor,
            height: MediaQuery.sizeOf(context).width / 18,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            margin: const EdgeInsets.all(5),
                            height: 45.h,
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? AppColors.toqPrimaryColor
                                    : AppColors.primaryColor,
                                borderRadius: currentIndex == index
                                    ? BorderRadius.circular(15)
                                    : BorderRadius.circular(10),
                                border: currentIndex == index
                                    ? Border.all(
                                        color: AppColors.borderColor,
                                        width: 1,
                                      )
                                    : null),
                            duration: const Duration(microseconds: 300),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Center(
                                child: Text(
                                  items[index],
                                  style: TextStyle(color: currentIndex == index
                                      ? Colors.white
                                      : Colors.grey,)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          Container(
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SearchInput(),
                  currentIndex == 1
                      ? const SizedBox()
                      : Row(
                          children: [
                            ButtonWidget(
                              width: MediaQuery.sizeOf(context).width / 7,
                              icon: Icons.add,
                              label: add[currentIndex],
                              fontSize: 14.sp,
                              onTap: () {
                                currentIndex == 1
                                    ? null
                                    : showGeneralDialog(
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        transitionBuilder:
                                            (context, a1, a2, widget) {
                                          final curvedValue = Curves
                                                  .easeInOutBack
                                                  .transform(a1.value) -
                                              1.0;
                                          if (currentIndex == 0) {
                                            //user
                                            return Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                0.0,
                                                curvedValue * 200,
                                                0.0,
                                              ),
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: const DialogSettings(),
                                              ),
                                            );
                                          } else if (currentIndex == 1) {
                                            //Branch
                                            return Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                0.0,
                                                curvedValue * 200,
                                                0.0,
                                              ),
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: DialogWidgets(
                                                  txtName: "Branches",
                                                  txtFiledName: 'Nomi',
                                                  txtFiledName1: 'Barcode',
                                                  txtFiledController:
                                                      txtBranchNameController,
                                                  txtFiledController1:
                                                      txtBranchBarcodeController,
                                                  onTap: () {
                                                    if (txtBranchNameController
                                                            .text.isEmpty ||
                                                        txtBranchBarcodeController
                                                            .text.isEmpty) {
                                                      errorDialogWidgets(
                                                          context);
                                                    } else {
                                                      context
                                                          .read<BranchesCubit>()
                                                          .postBranches(
                                                            txtBranchNameController
                                                                .text,
                                                            txtBranchBarcodeController
                                                                .text,
                                                          )
                                                          .then(
                                                            (value) =>
                                                                Navigator.pop(
                                                                    context),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          } else if (currentIndex == 2) {
                                            //Category
                                            return const AddCategoryWidgets();
                                          } else if (currentIndex == 3) {
                                            //access
                                            return Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                0.0,
                                                curvedValue * 200,
                                                // Ensure curvedValue is defined
                                                0.0,
                                              ),
                                              child: Opacity(
                                                opacity: a1.value,
                                                // Ensure a1 is defined
                                                child: DialogWidgets(
                                                  allVisible: false,
                                                  txtName: "Ruxsat",
                                                  txtFiledName: 'Nomi',
                                                  txtFiledController:
                                                      txtAccessController,
                                                  // Ensure txtCategoryNameController is defined
                                                  txt: "Branchni tanlang",
                                                  items: const [],
                                                  onTap: () {
                                                    if (txtAccessController
                                                        .text.isEmpty) {
                                                      errorDialogWidgets(
                                                          context);
                                                    } else {
                                                      context
                                                          .read<AccessCubit>()
                                                          .postAccess(
                                                            txtAccessController
                                                                .text,
                                                          )
                                                          .then(
                                                            (value) =>
                                                                Navigator.pop(
                                                                    context),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          } else if (currentIndex == 4) {
                                            //types
                                            return Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                0.0,
                                                curvedValue * 200,
                                                // Ensure curvedValue is defined
                                                0.0,
                                              ),
                                              child: Opacity(
                                                opacity: a1.value,
                                                // Ensure a1 is defined
                                                child: DialogWidgets(
                                                  allVisible: false,
                                                  txtName: "Turini",
                                                  txtFiledName: 'Nomi',
                                                  txtFiledController:
                                                      txtTypesController,
                                                  onTap: () {
                                                    if (txtTypesController
                                                        .text.isEmpty) {
                                                      errorDialogWidgets(
                                                          context);
                                                    } else {
                                                      context
                                                          .read<TypesCubit>()
                                                          .postTypes(
                                                            txtTypesController
                                                                .text,
                                                          )
                                                          .then(
                                                            (value) =>
                                                                Navigator.pop(
                                                                    context),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                0.0,
                                                curvedValue * 200,
                                                // Ensure curvedValue is defined
                                                0.0,
                                              ),
                                              child: Opacity(
                                                opacity: a1.value,
                                                // Ensure a1 is defined
                                                child: DialogWidgets(
                                                  allVisible: false,
                                                  txtName: "Kurs",
                                                  txtFiledName: 'Nomi',
                                                  txtFiledController:
                                                      txtPriceNamController,
                                                  onTap: () {
                                                    if (txtPriceNamController
                                                        .text.isEmpty) {
                                                      errorDialogWidgets(
                                                          context);
                                                    } else {
                                                      context
                                                          .read<PriceCubit>()
                                                          .postPrice(
                                                            txtPriceNamController
                                                                .text,
                                                          )
                                                          .then(
                                                            (value) =>
                                                                Navigator.pop(
                                                                    context),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 300),
                                        barrierDismissible: true,
                                        barrierLabel: '',
                                        context: context,
                                        pageBuilder:
                                            (context, animation1, animation2) {
                                          return Container();
                                        },
                                      );
                              },
                            ),
                            const Wd(),
                            // ButtonWidget(
                            //   width: MediaQuery.sizeOf(context).width / 7,
                            //   label: delete[currentIndex],
                            //   icon: Icons.delete,
                            // ),
                          ],
                        )
                ],
              ),
            ),
          ),
          Expanded(
            child: pages[currentIndex],
          )
        ],
      ),
    );
  }
}
