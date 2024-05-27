import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/settings/cubit/price/price_cubit.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/data_table.dart';
import '../../../../widgets/input/post_input.dart';
import '../../../../widgets/my_dialog_widget.dart';
import '../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../widgets/text_widget/data_row_text.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import 'package:get/get.dart';

class DesktopPriceUI extends StatefulWidget {
  const DesktopPriceUI({super.key});

  @override
  State<DesktopPriceUI> createState() => _DesktopPriceUIState();
}

class _DesktopPriceUIState extends State<DesktopPriceUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<PriceCubit>().getPrice();
      },
    );
    super.initState();
  }

  final txtName = TextEditingController();
  final txtValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PriceCubit, PriceState>(
      builder: (context, state) {
        if (state is PriceLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          );
        } else if (state is PriceErrorState) {
          return Text(state.error);
        } else if (state is PriceSuccessState) {
          return SingleChildScrollView(
            child: Container(
              color: AppColors.primaryColor,
              width: double.infinity,
              child: DataTableWidget(
                dataColumn: const [
                  DataColumn(
                    label: DataColumnText(txt: 'Nomi'),
                  ),
                  // DataColumn(
                  //   label: DataColumnText(txt: 'Yaratilgan sana'),
                  // ),
                  DataColumn(
                    label: DataColumnText(txt: 'Value'),
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
                          DataRowText(
                            txt: data.name ?? "",
                          ),
                        ),
                        // DataCell(
                        //   DataRowText(
                        //     txt: formatDate(
                        //       DateTime.parse(data.createdAt ?? ''),
                        //     ),
                        //   ),
                        // ),
                        DataCell(
                          DataRowText(txt: data.value ?? ''),
                        ),
                        DataCell(
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ), onTap: () {
                          txtName.text = data.name ?? '';
                          txtValue.text = data.value ?? '';
                          showCustomDialogWidget(
                            context,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TextWidget(txt: "Turini o'zgartirish"),
                                PostInput(
                                  label: "Nomi",
                                  controller: txtName,
                                  inputWidth: double.infinity,
                                ),
                                PostInput(
                                  label: "Value",
                                  controller: txtValue,
                                  inputWidth: double.infinity,
                                ),
                                CustomButtons(
                                  onTap: () {
                                    print(data.id);
                                    context
                                        .read<PriceCubit>()
                                        .updatePrice(
                                          data.id!,
                                          txtName.text,
                                          double.parse(txtValue.text),
                                        )
                                        .then(
                                      (value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (timeStamp) {
                                            context
                                                .read<PriceCubit>()
                                                .getPrice();
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
                            3,
                          );
                        }),
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
