import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/dialog.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/user_expenses_dialog.dart';
import 'package:santexnika_crm/screens/settings/settings_desktop/widget/user_update.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/data_table.dart';
import '../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../widgets/text_widget/data_row_text.dart';

class DesktopUsersUI extends StatefulWidget {
  const DesktopUsersUI({super.key});

  @override
  State<DesktopUsersUI> createState() => _DesktopUsersUIState();
}

class _DesktopUsersUIState extends State<DesktopUsersUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<UsersCubit>().getUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          ));
        } else if (state is UserErrorState) {
          return Text(state.error);
        } else if (state is UserSuccessState) {
          return SingleChildScrollView(
            child: Container(
              color: AppColors.primaryColor,
              width: double.infinity,
              child: DataTableWidget(
                dataColumn: const [
                  DataColumn(
                    label: DataColumnText(txt: 'Foydalanuvchi nomi'),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: "Telefon nomer"),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: 'Foydalanuvchi Ruxsatlari'),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: 'Ruxsat Nomi'),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: ''),
                  ),
                ],
                dataRow: List.generate(
                  state.data.data.length,
                  (index) {
                    var data = state.data.data[index];

                    return DataRow(
                      onSelectChanged: (value) {
                        context
                            .read<UsersCubit>()
                            .getUserPaymentHistory(data.id!);
                        showCustomDialogWidget(
                          context,
                          UserExpenses(
                              name: data.name ?? "",
                              onTap: () {
                                context.read<UsersCubit>().getUsers();
                                Navigator.of(context).pop();
                              },
                              id: data.id!),
                          1.2,
                          1.4,
                        );
                      },
                      cells: [
                        DataCell(
                          DataRowText(
                            txt: data.name ?? "",
                          ),
                        ),
                        DataCell(
                          DataRowText(
                            txt: data.phone ?? '',
                          ),
                        ),
                        DataCell(
                          DataRowText(txt: data.name ?? ''),
                        ),
                        const DataCell(
                          DataRowText(
                            txt: "not found",
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionBuilder:
                                        (context, a1, a2, widget) {
                                      final curvedValue = Curves.easeInOutBack
                                              .transform(a1.value) -
                                          1.0;
                                      //user
                                      return Transform(
                                        transform: Matrix4.translationValues(
                                          0.0,
                                          curvedValue * 200,
                                          0.0,
                                        ),
                                        child: Opacity(
                                          opacity: a1.value,
                                          child: UserUpdate(
                                            login: data.name.toString(),
                                            phone: data.phone.toString(),
                                            access: data.userAccess!
                                                .map((e) => e.accessId!)
                                                .toList(),
                                            userType: data.role == null ? null : int.parse(data.role!),
                                            branchId: data.branchId!,
                                            userId: data.id!,
                                          ),
                                        ),
                                      );
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
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showCustomDialogWidget(
                                    context,
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          txt: "O'chirish",
                                          txtColor: Colors.red,
                                          size: 24.sp,
                                        ),
                                        const TextWidget(
                                          txt: "Rostdan ham o`chirmoqchimisiz?",
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ButtonWidget(
                                                color: AppColors.primaryColor,
                                                isVisible: false,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                label: 'Bekor qilish',
                                              ),
                                            ),
                                            const Wd(),
                                            Expanded(
                                              child: ButtonWidget(
                                                color: AppColors.primaryColor,
                                                isVisible: false,
                                                onTap: () {
                                                  context
                                                      .read<UsersCubit>()
                                                      .deleteUser(
                                                        data.id!.toInt(),
                                                      )
                                                      .then((value) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (timeStamp) async {
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                },
                                                label: "O'chrish",
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    5,
                                    5,
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              const Wd(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
      listener: (context, state) {},
    );
  }
}
