import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:santexnika_crm/screens/customer/cubit/customer_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/searchble_input.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../widgets/buttons.dart';
import '../../../../widgets/input/comment.dart';
import '../../../../widgets/input/post_input.dart';
import '../../widgets/cutomer_with_id.dart';

class CustomerDesktopUI extends StatefulWidget {
  const CustomerDesktopUI({super.key});

  @override
  State<CustomerDesktopUI> createState() => _CustomerDesktopUIState();
}

class _CustomerDesktopUIState extends State<CustomerDesktopUI> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtCommint = TextEditingController();

  @override
  void dispose() {
    txtName.dispose();
    txtPhone.dispose();
    txtCommint.dispose();
    super.dispose();
  }

  @override
  void initState() {
    txtPhone.text = "+998";
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        context.read<CustomerCubit>().getCustomer(0, '');
      },
    );
    super.initState();
  }

  Timer? searchTime;

  void handleSearch(String query) {
    if (mounted) {
      searchTime?.cancel();

      searchTime = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;

            currentPage = 0;
            context.read<CustomerCubit>().searchCustomer(query.trim());
          } else {
            context.read<CustomerCubit>().getCustomer(1, "");
            searchQuery = "";
          }
        },
      );
    }
  }

  int currentPage = 0;
  String searchQuery = "";

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
                children: [TextWidget(txt: "Haridorlar bo'limi")],
              ),
            ),
          ),
          const Hg(
            height: 1,
          ),
          Container(
            height: 100,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchInput(
                    onChanged: (query) {
                      handleSearch(query);
                    },
                  ),
                  Row(
                    children: [
                      ButtonWidget(
                        width: MediaQuery.sizeOf(context).width / 7,
                        icon: Icons.add,
                        label: "Haridor qo'shish",
                        fontSize: 14.sp,
                        onTap: () {
                          txtName.clear();
                          txtPhone.text = "+998";
                          txtCommint.clear();
                          showCustomDialogWidget(
                            context,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const TextWidget(txt: "Haridor qo'shish"),
                                    const Hg(),
                                    PostInput(
                                      controller: txtName,
                                      label: 'Nomi',
                                      inputWidth: double.infinity,
                                      txtColor: Colors.white,
                                    ),
                                    Hg(
                                      height: 20.h,
                                    ),
                                    PostInput(
                                      controller: txtPhone,
                                      label: "Telefon nomer",
                                      inputWidth: double.infinity,
                                      keyboardType: TextInputType.number,
                                    ),
                                    Hg(
                                      height: 20.h,
                                    ),
                                    CommentInput(
                                      controller: txtCommint,
                                      label: 'Izoh',
                                      inputHeight: 120.h,
                                      inputWidth: double.infinity,
                                      txtColor: Colors.white,
                                    ),
                                  ],
                                ),
                                CustomButtons(
                                  onTap: () {
                                    context
                                        .read<CustomerCubit>()
                                        .postCustomer(
                                          txtName.text.trim(),
                                          txtPhone.text,
                                          txtCommint.text.trim(),
                                          1,
                                        )
                                        .then((_) {
                                      context
                                          .read<CustomerCubit>()
                                          .getCustomer(0, "");
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    }).catchError((error) {
                                      print(error);
                                    });
                                  },
                                )
                              ],
                            ),
                            4,
                            2,
                          );
                        },
                      ),
                      const Wd(),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Hg(
            height: 3,
          ),
          BlocBuilder<CustomerCubit, CustomerState>(
            builder: (BuildContext context, CustomerState state) {
              if (state is CustomerLoadingState) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.whiteColor,
                  ),
                );
              } else if (state is CustomerErrorState) {
                return TextWidget(txt: state.error);
              } else if (state is CustomerSuccessState) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          color: AppColors.primaryColor,
                          child: DataTableWidget(
                            dataColumn: const [
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Nomi',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: "Telefon nomeri",
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: 'Izoh',
                                ),
                              ),
                              DataColumn(
                                label: DataColumnText(
                                  txt: '',
                                ),
                              ),
                            ],
                            dataRow: List.generate(
                              state.data.data.length ?? 1,
                              (index) {
                                var data = state.data.data[index];
                                return DataRow(
                                  onSelectChanged: (value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (timeStamp) async {
                                        context
                                            .read<CustomerWithIdCubit>()
                                            .getCustomerWithId(data.id!);
                                      },
                                    );
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel:
                                          MaterialLocalizations.of(context)
                                              .modalBarrierDismissLabel,
                                      barrierColor: Colors.black45,
                                      transitionDuration:
                                          const Duration(milliseconds: 200),
                                      transitionBuilder:
                                          (context, a1, a2, widget) {
                                        final curvedValue = Curves.easeInOutBack
                                                .transform(a1.value) -
                                            1.0;
                                        return Transform(
                                          transform: Matrix4.translationValues(
                                            0.0,
                                            curvedValue * 200,
                                            0.0,
                                          ),
                                          child: Center(
                                            child: Material(
                                              color: AppColors.bottombarColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.3,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.bottombarColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: DebtsOfTheCustomers(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  name: data.name,
                                                  id: data.id,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      pageBuilder: (BuildContext buildContext,
                                          Animation animation,
                                          Animation secondaryAnimation) {
                                        return Container();
                                      },
                                    );
                                  },
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                6,
                                        child: DataRowText(
                                            txt: data.name ?? 'N/A'),
                                      ),
                                    ),
                                    DataCell(
                                      DataRowText(txt: data.phone ?? 'N/A'),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                4,
                                        child: DataRowText(
                                            txt: data.comment.toString() ??
                                                'N/A'),
                                      ),
                                      placeholder: false,
                                      showEditIcon: false,
                                    ),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            deletedDialog(
                                              context,
                                              () {
                                                context
                                                    .read<CustomerCubit>()
                                                    .deleteCustomer(data.id!)
                                                    .then(
                                                      (value) => Get.back(),
                                                    );
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            txtName.text = data.name ?? "";
                                            txtPhone.text = data.phone ?? "";
                                            txtCommint.text =
                                                data.comment ?? "";

                                            showCustomDialogWidget(
                                              context,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const TextWidget(
                                                          txt:
                                                              "Haridor o'zgartirish"),
                                                      const Hg(),
                                                      PostInput(
                                                        controller: txtName,
                                                        label: 'Nomi',
                                                        inputWidth:
                                                            double.infinity,
                                                        txtColor: Colors.white,
                                                      ),
                                                      Hg(
                                                        height: 20.h,
                                                      ),
                                                      PostInput(
                                                        controller: txtPhone,
                                                        label: "Telefon nomer",
                                                        inputWidth:
                                                            double.infinity,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                      Hg(
                                                        height: 20.h,
                                                      ),
                                                      CommentInput(
                                                        controller: txtCommint,
                                                        label: 'Izoh',
                                                        inputHeight: 120.h,
                                                        inputWidth:
                                                            double.infinity,
                                                        txtColor: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                  CustomButtons(
                                                    onTap: () {
                                                      context
                                                          .read<CustomerCubit>()
                                                          .updateCustomer(
                                                            txtName.text.trim(),
                                                            txtPhone.text
                                                                .trim(),
                                                            txtCommint.text
                                                                .trim(),
                                                            data.branchId!,
                                                            data.id!,
                                                          )
                                                          .then((_) {
                                                        context
                                                            .read<
                                                                CustomerCubit>()
                                                            .getCustomer(0, "");
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      }).catchError((error) {
                                                        print(error);
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              4,
                                              2,
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          color: AppColors.bottombarColor,
                          child: NumberPaginator(
                            initialPage: currentPage,
                            onPageChange: (page) {
                              currentPage = page;
                              context
                                  .read<CustomerCubit>()
                                  .getCustomer(currentPage + 1, '');
                            },
                            numberPages:
                                (state.data.total / state.data.perPage).ceil(),
                            // context.read<StoreCubit>().totalPage,
                            config: NumberPaginatorUIConfig(
                              buttonUnselectedBackgroundColor:
                                  AppColors.bottombarColor,
                              buttonShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              buttonSelectedBackgroundColor:
                                  AppColors.selectedColor,
                              buttonTextStyle:
                                  TextStyle(color: AppColors.whiteColor),
                              buttonUnselectedForegroundColor:
                                  AppColors.whiteColor,
                              mode: ContentDisplayMode.numbers,
                              buttonSelectedForegroundColor:
                                  AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}

// class CustomerDataSource extends DataTableSource {
//   final List<CustomerModel> dataList;
//
//   CustomerDataSource(this.dataList);
//
//   @override
//   DataRow? getRow(int index) {
//     final data = dataList[index];
//
//     return DataRow(
//       cells: [
//         DataCell(
//           CustomerDataRowText(txt: data.name ?? 'N/A'),
//         ),
//         DataCell(
//           CustomerDataRowText(txt: data.phone ?? 'N/A'),
//         ),
//         DataCell(
//           CustomerDataRowText(txt: data.comment ?? 'N/A'),
//           placeholder: false,
//           showEditIcon: false,
//         ),
//       ],
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => dataList.length;
//
//   @override
//   int get selectedRowCount => 0;
// }
