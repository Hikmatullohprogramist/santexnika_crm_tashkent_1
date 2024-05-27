import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/settings/cubit/access/access_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';


class DesktopAccessUI extends StatefulWidget {
  const DesktopAccessUI({super.key});

  @override
  State<DesktopAccessUI> createState() => _DesktopAccessUIState();
}

class _DesktopAccessUIState extends State<DesktopAccessUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AccessCubit>().getAccess();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccessCubit, AccessState>(
      builder: (context, state) {
        if (state is AccessLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          );
        } else if (state is AccessErrorState) {
          return TextWidget(
            txt: state.error,
          );
        } else if (state is AccessSuccessState) {
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
                          DataRowText(txt: data.name ?? ""),
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
          return Container(

          );
        }
      },
      listener: (context, state) {},
    );
  }
}
