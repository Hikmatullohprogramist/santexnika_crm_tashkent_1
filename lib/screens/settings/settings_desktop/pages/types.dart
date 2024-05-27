import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/widgets/buttons.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';
import 'package:get/get.dart';

import '../../../../tools/appColors.dart';
import '../../../../tools/format_date_time.dart';
import '../../../../widgets/data_table.dart';
import '../../../../widgets/text_widget/data_row_text.dart';

class DesktopTypesUI extends StatefulWidget {
  const DesktopTypesUI({super.key});

  @override
  State<DesktopTypesUI> createState() => _DesktopTypesUIState();
}

class _DesktopTypesUIState extends State<DesktopTypesUI> {
  TextEditingController txtName = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TypesCubit>().getTypes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TypesCubit, TypesState>(
      builder: (context, state) {
        if (state is TypesLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          );
        } else if (state is TypesErrorState) {
          return Text(state.error);
        } else if (state is TypesSuccessState) {
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
                  DataColumn(
                    label: DataColumnText(txt: ''),
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
                              DateTime.parse(
                                  data.createdAt ?? DateTime.now().toString()),
                            ),
                          ),
                        ),
                        DataCell(
                          const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onTap: () {
                            txtName.text = data.name ?? '';
                            showCustomDialogWidget(
                              context,
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextWidget(txt: "Turini o'zgartirish"),
                                  PostInput(
                                    controller: txtName,
                                    inputWidth: double.infinity,
                                  ),
                                  CustomButtons(
                                    onTap: () {
                                      print(data.id);
                                      context
                                          .read<TypesCubit>()
                                          .updateType(
                                            data.id!,
                                            txtName.text,
                                          )
                                          .then(
                                        (value) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                            (timeStamp) {
                                              context
                                                  .read<TypesCubit>()
                                                  .getTypes();
                                            },
                                          );
                                          Get.back();
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                              4,
                              4,
                            );
                          },
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
