import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waitingWithId/waitin_with_id_cubit.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/waiting/waitingWithId.dart';
import 'package:santexnika_crm/widgets/data_table.dart';

import '../../../../../../tools/appColors.dart';
import '../../../../../../widgets/searchble_input.dart';
import '../../../../../../widgets/sized_box.dart';
import '../../../../../../widgets/text_widget/data_culumn_text.dart';
import '../../../../../../widgets/text_widget/data_row_text.dart';
import '../../../../../../widgets/text_widget/text_widget.dart';
import '../../../../cubit/waiting/waiting/waiting_state.dart';

class StandbyMode extends StatefulWidget {
  const StandbyMode({super.key});

  @override
  State<StandbyMode> createState() => _StandbyModeState();
}

class _StandbyModeState extends State<StandbyMode> {
  PageController pageController = PageController();

  void switchPage(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WaitingCubit>().getWaiting();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Center(
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 1.4,
              // padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bottombarColor,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    color: AppColors.primaryColor,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(txt: "Vaqtinchalikdan chiqarish oynasi")
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    color: AppColors.primaryColor,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SearchInput(),
                        ],
                      ),
                    ),
                  ),
                  const Hg(
                    height: 1,
                  ),
                  BlocBuilder<WaitingCubit, WaitingState>(
                    builder: (BuildContext context, WaitingState state) {
                      if (state is WaitingLoadingState) {
                        return const CircularProgressIndicator.adaptive();
                      } else if (state is WaitingErrorState) {
                        return TextWidget(txt: state.message);
                      } else if (state is WaitingOrdersSuccessState) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              color: AppColors.primaryColor,
                              child: DataTableWidget(
                                checkbox: true,
                                dataColumn: const [
                                  DataColumn(
                                    label: DataColumnText(txt: "Mijoz"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Sotuvchi"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: "Chek id"),
                                  ),
                                  DataColumn(
                                    label: DataColumnText(txt: ""),
                                  ),
                                ],
                                dataRow: List.generate(
                                  state.data.length,
                                  (index) {
                                    var data = state.data[index];
                                    return DataRow(
                                      onSelectChanged: (v) {

                                      },
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                7,
                                            child: DataRowText(
                                              txt: data.customer?.name ??
                                                  'Xaridorsiz savdo',
                                            ),
                                          ),
                                          onTap: (){
                                            context
                                                .read<WaitingWithIdCubit>()
                                                .getWaitingWithId(data.id ?? 0);
                                            switchPage(1);
                                          }
                                        ),
                                        DataCell(
                                          DataRowText(
                                            txt: data.user?.name ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          DataRowText(
                                              txt: data.id.toString() ?? 0),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: AppColors.bottombarColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border:
                                                    Border.all(color: AppColors.borderColor)),
                                                child: const Icon(
                                                  Icons.remove_shopping_cart_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Wd(),

                                              InkWell(
                                                onTap: (){
                                                  context.read<WaitingWithIdCubit>().unWaitingWithId(data.id!).then((value) {
                                                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                      context.read<WaitingCubit>().getWaiting();
                                                      context.read<BasketCubit>().getBasket();
                                                    });
                                                    Get.back();
                                                  });
                                                },
                                                child: Container(
                                                  width: 80,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.bottombarColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: AppColors.borderColor,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.add_shopping_cart_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const Hg(
                    height: 1,
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   height: 60,
                  //   color: AppColors.primaryColor,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 18.0,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       children: [
                  //         InkWell(
                  //           onTap: (){},
                  //           child: Container(
                  //             width: 80,
                  //             height: 50,
                  //             decoration: BoxDecoration(
                  //               color: AppColors.bottombarColor,
                  //               borderRadius: BorderRadius.circular(10),
                  //               border: Border.all(
                  //                 color: AppColors.borderColor,
                  //               ),
                  //             ),
                  //             child: const Icon(
                  //               Icons.add_shopping_cart_outlined,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //         const Wd(),
                  //         Container(
                  //           width: 80,
                  //           height: 50,
                  //           decoration: BoxDecoration(
                  //               color: AppColors.bottombarColor,
                  //               borderRadius: BorderRadius.circular(10),
                  //               border:
                  //                   Border.all(color: AppColors.borderColor)),
                  //           child: const Icon(
                  //             Icons.remove_shopping_cart_outlined,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        WaitingWIthIdUI(
          onTap: () {
            switchPage(0);
          },
        )
      ],
    );
  }
}
