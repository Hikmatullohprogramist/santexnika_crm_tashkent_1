import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/tools/constantas.dart';

import '../screens/login/cubit/login_cubit.dart';

import 'text_widget/text_widget.dart';

class ProfileWidgetDesktop extends StatefulWidget {
  final bool isRow;
  const ProfileWidgetDesktop({super.key, required this.isRow});

  @override
  State<ProfileWidgetDesktop> createState() => _ProfileWidgetDesktopState();
}

class _ProfileWidgetDesktopState extends State<ProfileWidgetDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: BlocBuilder<BranchesCubit, BranchesState>(
        builder: (context, state) {
          if (state is BranchesSuccessState) {
            return BlocBuilder<LoginCubit, LoginState>(
              builder: (context, userState) {
                if (userState is LoginSuccess) {

                  AppConstants.currentBranch =state.data.where((branch) => branch.id == userState.data.branchId).firstOrNull!.name.toString();
                  AppConstants.currentBranchUser =userState.data.name.toString();
                  return widget.isRow
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //BRanch txt
                            TextWidget(
                              txt: isProduction != true
                                  ? "${state.data.where((branch) => branch.id == userState.data.branchId).firstOrNull!.name ?? ""} DEV"
                                  : state.data
                                          .where((branch) =>
                                              branch.id ==
                                              userState.data.branchId)
                                          .firstOrNull!
                                          .name ??
                                      "",
                            ),
                            const SizedBox(width: 10),

                            //User name txt
                            TextWidget(
                              txt: isProduction != true
                                  ? "${userState.data.name} DEV"
                                  : userState.data.name,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //BRanch txt
                            TextWidget(
                              txt: isProduction != true
                                  ? "${state.data.where((branch) => branch.id == userState.data.branchId).firstOrNull!.name ?? ""} DEV"
                                  : state.data
                                          .where((branch) =>
                                              branch.id ==
                                              userState.data.branchId)
                                          .firstOrNull!
                                          .name ??
                                      "",
                            ),
                            const SizedBox(height: 10),

                            //User name txt
                            TextWidget(
                              txt: isProduction != true
                                  ? "${userState.data.name} DEV"
                                  : userState.data.name,
                            ),
                          ],
                        );
                }
                return const SizedBox();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
