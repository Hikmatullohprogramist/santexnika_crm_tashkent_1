import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/widgets/mobile_add.dart';
import 'package:santexnika_crm/tools/phone_formatter.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/text_widget/column_text_widget.dart';

class MobileUsersScreen extends StatefulWidget {
  const MobileUsersScreen({super.key});

  @override
  State<MobileUsersScreen> createState() => _MobileUsersScreenState();
}

class _MobileUsersScreenState extends State<MobileUsersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<UsersCubit>().getUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await context.read<UsersCubit>().getUsers();
          });
        },
        child: Column(
          children: [
            const Hg(
              height: 5,
            ),
            BlocBuilder<UsersCubit, UsersState>(
              builder: (BuildContext context, state) {
                if (state is UserLoadingState) {
                  return const Expanded(child: ApiLoadingWidget());
                } else if (state is UserErrorState) {
                  return Expanded(
                    child: MobileAPiError(
                      message: state.error,
                      onTap: () {
                         context.read<UsersCubit>().getUsers();
                      },
                    ),
                  );
                } else if (state is UserSuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.data.length,
                      itemBuilder: (context, index) {
                        var data = state.data.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (v) {
                                    context
                                        .read<UsersCubit>()
                                        .deleteUser(data.id!);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: AppColors.errorColor,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SlidableAction(
                                  onPressed: (v) {
                                    showMobileDialogWidget(
                                      context,
                                      MobileUserAddScreen(
                                        forAdd: false,
                                        name: data.name ?? '',
                                        phone: data.phone,
                                        selectedAccess: data.userAccess?.map((e) => e.accessId!.toInt()).toList(),
                                        selectedValuee: data.branchId,
                                        // selectedAccess: data.userAccess[index].id,
                                        // selectedValuee: data.id,
                                      ),
                                      1.2,
                                      1.2,
                                    );
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: AppColors.selectedColor,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                            ),
                            child: MobileBackgroundWidget(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ColumnTextWidget(
                                    title: 'Foydalanuchi nomi: ',
                                    name: data.name,
                                  ),
                                  const Hg(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ColumnTextWidget(
                                          title: 'Telefon no\'mer: ',
                                          name: formatPhoneNumber(
                                            data.phone.toString(),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: ColumnTextWidget(
                                          title: 'Ruxsat nomi: ',
                                          name: 'no found',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Hg(),
                                  ColumnTextWidget(
                                    title: 'Foydalanuvchilar ruxsatlari: ',
                                    name: data.name,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMobileDialogWidget(
            context,
            MobileUserAddScreen(
              forAdd: true,
            ),
            1.2,
            1.2,
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
