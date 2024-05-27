import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';

import '../../../../tools/appColors.dart';
import '../../../../tools/format_date_time.dart';
import '../../../../widgets/data_table.dart';
import '../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../widgets/text_widget/data_row_text.dart';

class DesktopBranchUI extends StatefulWidget {
  const DesktopBranchUI({super.key});

  @override
  State<DesktopBranchUI> createState() => _DesktopBranchUIState();
}

class _DesktopBranchUIState extends State<DesktopBranchUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BranchesCubit>().getBranches();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchesCubit, BranchesState>(
      builder: (context, state) {
        if (state is BranchesLoadingState) {
          return const Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          ));
        } else if (state is BranchesErrorState) {
          return Text(state.error);
        } else if (state is BranchesSuccessState) {
          return SingleChildScrollView(
            child: Container(
              color: AppColors.primaryColor,
              width: double.infinity,
              child: DataTableWidget(
                dataColumn: const [
                  DataColumn(
                    label: DataColumnText(txt: 'Nomi'),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: 'Shtrix kod'),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: "Check nomer"),
                  ),
                  DataColumn(
                    label: DataColumnText(txt: 'Sana'),
                  ),
                ],
                dataRow: List.generate(
                  state.data.length,
                  (index) {
                    var data = state.data[index];

                    return DataRow(
                      onSelectChanged: (value) {},
                      cells: [
                        DataCell(
                          DataRowText(
                            txt: data.name ?? "",
                          ),
                        ),
                        DataCell(
                          DataRowText(
                            txt: moneyFormatter(
                                  double.parse(
                                    data.barcode.toString(),
                                  ),
                                ) ??
                                "",
                          ),
                        ),
                        DataCell(
                          DataRowText(txt: data.checkNumber.toString() ?? ""),
                        ),
                        DataCell(
                          DataRowText(
                            txt: formatDate(
                              DateTime.parse(data.createdAt ?? ''),
                            ),
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
