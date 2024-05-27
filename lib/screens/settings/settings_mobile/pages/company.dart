import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../cubit/branches/branches_cubit.dart';

class MobileCompanyScreen extends StatefulWidget {
  const MobileCompanyScreen({super.key});

  @override
  State<MobileCompanyScreen> createState() => _MobileCompanyScreenState();
}

class _MobileCompanyScreenState extends State<MobileCompanyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<BranchesCubit>().getBranches();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              await context.read<BranchesCubit>().getBranches();
            },
          );
        },
        child: BlocBuilder<BranchesCubit, BranchesState>(
          builder: (BuildContext context, state) {
            if (state is BranchesLoadingState) {
              return const ApiLoadingWidget();
            } else if (state is BranchesErrorState) {
              return MobileAPiError(
                message: state.error,
                onTap: () {
                  context.read<BranchesCubit>().getBranches();
                },
              );
            } else if (state is BranchesSuccessState) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    var data = state.data[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MobileBackgroundWidget(
                        child: Column(
                          children: [
                            RowsTextWidget(
                              title: "Nomi: ",
                              name: data.name ?? '',
                            ),
                            const Hg(
                              height: 5,
                            ),
                            RowsTextWidget(
                              title: "Shtrih kod: ",
                              name: data.barcode ?? '',
                            ),
                            const Hg(
                              height: 5,
                            ),
                            RowsTextWidget(
                              title: "Chek no'mer: ",
                              name: data.checkNumber.toString() ?? '',
                            ),
                            const Hg(
                              height: 5,
                            ),
                            RowsTextWidget(
                              title: "Sana: ",
                              name: formatDate(DateTime.parse(
                                      data.createdAt.toString())) ??
                                  '',
                            ),
                          ],
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
        ),
      ),
    );
  }
}
