import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/basket/basket_model.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/screens/sold/pages/sold_desktop/sold_desktop.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_state.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/dialog_widget.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/vozvrat_dialog.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/waiting/standby_mode.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_desktop/widgets/trade_dialog.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/calculate_summa.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/data_table.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/profile_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/data_culumn_text.dart';
import 'package:santexnika_crm/widgets/text_widget/data_row_text.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../widgets/bar_text_widget.dart';
import '../../../expenses/widgets/add_expenses_dialog.dart';
import '../../../settings/cubit/price/price_cubit.dart';
import 'package:get/get.dart';

class TradeDesktopUI extends StatefulWidget {
  const TradeDesktopUI({super.key});

  @override
  State<TradeDesktopUI> createState() => _TradeDesktopUIState();
}

class _TradeDesktopUIState extends State<TradeDesktopUI> {
  String selectedValue = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<PriceCubit>().getPrice();
      await context.read<BasketCubit>().getBasket();
    });
    super.initState();
  }

  List<int> selectedProduct = [];

  onSelectedRow(
    bool selected,
    BasketModel model,
  ) {
    setState(() {
      if (selected) {
        selectedProduct.add(model.id);
      } else {
        selectedProduct.remove(model.id);
      }
    });
  }

  TextEditingController summaController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  // PageController pageController = PageController();
  //
  // void _switchPage(int index) {
  //   pageController.jumpToPage(index);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(txt: "Savdo oynasi"),
                  const ProfileWidgetDesktop(isRow: true),
                  IconButton(
                      onPressed: () {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) async {
                          await context.read<BasketCubit>().getBasket();
                        });
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: AppColors.whiteColor,
                      ))
                ],
              ),
            ),
          ),
          const Hg(
            height: 1,
          ),
          BlocBuilder<BasketCubit, BasketState>(
            builder: (context, state) {
              if (state is BasketLoading) {
                return const Expanded(child: Center(child: ApiLoadingWidget()));
              } else if (state is BasketError) {
                return Expanded(
                    child: Center(
                        child: ApiErrorMessage(errorMessage: state.error)));
              } else if (state is BasketEmpty) {
                return const Expanded(
                  child: Center(
                    child: TextWidget(txt: "Mahsulotlar yo'q"),
                  ),
                );
              } else if (state is BasketSuccess) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColors.primaryColor,
                      width: double.infinity,
                      child: DataTableWidget(
                        checkbox: true,
                        dataColumn: const [
                          DataColumn(
                            label: DataColumnText(txt: 'Nomi'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Miqdor'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Summa'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Valyuta'),
                          ),
                          DataColumn(
                            label: DataColumnText(txt: 'Jami summa'),
                          ),
                        ],
                        dataRow: _buildDataRow(state),
                      ),
                    ),
                  ),
                );
              } else if (state is BasketSuccessCheck) {
                return Expanded(
                  child: Center(
                    child: TextWidget(
                      txt: "Muvaffaqiyatli sotildi. Chek ${state.checkId}",
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          const Hg(
            height: 2,
          ),
          BlocBuilder<BasketCubit, BasketState>(
            builder: (context, state) {
              if (state is BasketSuccess) {
                return Container(
                  height: 100,
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(12.0.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Wd(
                              width: 20,
                            ),
                            BarTextWidgets(
                              name: "Jami summa so'm",
                              price: double.parse(
                                  state.orderList.calc.uzs.toString()),
                            ),
                            const Wd(
                              width: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  txt: "Jami summa \$:",
                                  size: 14.sp,
                                ),
                                TextWidget(
                                  txt: moneyFormatterWidthDollor(
                                      state.orderList.calc.usd.toDouble()),
                                  size: 14.sp,
                                ),
                              ],
                            ),
                            const Wd(
                              width: 40,
                            ),
                            Visibility(
                              visible: true,
                              child: Row(
                                children: [
                                  BarTextWidgets(
                                    name: "Dollar Kursi",
                                    price: double.parse(
                                      state.orderList.calc.dollar.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ButtonWidget(
                              isVisible: true,
                              icon: Icons.shopping_cart,
                              width: 200.w,
                              height: 60.h,
                              label: "Sotish",
                              color: AppColors.bottombarColor,
                              onTap: () {
                                showCustomDialogWidget(
                                  context,
                                  TradeDialog(
                                    products: state.orderList.basket,
                                    dollarPirce: state.orderList.calc.usd,
                                    somPrice: state.orderList.calc.uzs,
                                  ),
                                  1.3,
                                  1.3,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
          const Hg(
            height: 3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Hg(),
              Row(
                children: [
                  const Wd(),
                  Expanded(
                    child: ButtonWidget(
                      radius: 10,
                      color: AppColors.primaryColor,
                      label: "O'chirish",
                      icon: Icons.remove_shopping_cart,
                      height: 60.h,
                      fontSize: 16.sp,
                      iconSize: 22,
                      onTap: () {
                        selectedProduct.isNotEmpty
                            ? deletedDialog(
                                context,
                                () {
                                  context
                                      .read<BasketCubit>()
                                      .deleteBasket(selectedProduct)
                                      .then((value) {
                                    Get.back();
                                  });
                                },
                              )
                            : errorDialogWidgets(context);
                      },
                    ),
                  ),
                  const Wd(),
                  Expanded(
                    child: ButtonWidget(
                      radius: 10,
                      color: AppColors.primaryColor,
                      height: 60.h,
                      label: "Vaqtinchalikka olish",
                      fontSize: 16.sp,
                      icon: Icons.add_shopping_cart_sharp,
                      iconSize: 22,
                      onTap: () {
                        selectedProduct.isNotEmpty
                            ? context
                                .read<WaitingCubit>()
                                .toWaiting(selectedProduct)
                                .then((_) async {
                                await context.read<BasketCubit>().getBasket();

                                selectedProduct.clear();
                              }).catchError((error) {
                                print(error);
                              })
                            : errorDialogWidgets(context);
                      },
                    ),
                  ),
                  const Wd(),
                  Expanded(
                    child: ButtonWidget(
                      radius: 10,
                      color: AppColors.primaryColor,
                      label: "Vaqtinchalikdan chiqarish",
                      fontSize: 14.sp,
                      icon: Icons.shopping_cart_checkout,
                      height: 60.h,
                      onTap: () {
                        showCustomDialogWidget(
                          context,
                          const StandbyMode(),
                          1.2,
                          1.4,
                        );
                      },
                    ),
                  ),
                  const Wd(),
                  Expanded(
                    child: ButtonWidget(
                      onTap: () {
                        context.read<SoldCubit>().getSelledProducts("", 0);
                        showCustomDialogWidget(
                          context,
                          const VozvratDialogWidget(),
                          1.1,
                          1.1,
                        );
                      },
                      radius: 10,
                      color: AppColors.primaryColor,
                      height: 60.h,
                      label: "Sotilganlar",
                      fontSize: 16.sp,
                      icon: Icons.sell,
                      iconSize: 22,
                    ),
                  ),
                  const Wd(),
                  Expanded(
                    child: ButtonWidget(
                      onTap: () {
                        showCustomDialogWidget(
                          context,
                          const AddExpensesDialog(
                            isBool: true,
                          ),
                          4,
                          1.6,
                        );
                      },
                      radius: 10,
                      color: AppColors.primaryColor,
                      label: "Chiqim qilish",
                      height: 60.h,
                      fontSize: 16.sp,
                      iconSize: 32,
                      icon: Icons.attach_money_rounded,
                    ),
                  ),
                  const Wd(),
                  ButtonWidget(
                    isVisible: true,
                    icon: Icons.add_shopping_cart_sharp,
                    width: 200.w,
                    height: 60.h,
                    label: "Qo`shish",
                    color: AppColors.primaryColor,
                    onTap: () {
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) async {
                        await context
                            .read<StoreCubit>()
                            .getProductDesktop(0, "");
                      });
                      // _switchPage(1);
                      showCustomDialogWidget(
                        context,
                        const TradeDialogWidget(),
                        1.1,
                        1.1,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const Hg(),
        ],
      ),
    );
  }
  _buildDataRow(BasketSuccess state){
    return  List.generate(
      state.orderList.basket.length,
          (index) {
        var data = state.orderList.basket[index];

        TextEditingController quantityController =
        TextEditingController(text: data.quantity);
        TextEditingController agreedPriceController =
        TextEditingController(
            text: data.basketPrice.isNotEmpty
                ? data.basketPrice[0].agreedPrice
                : "0");
        int selectedValueMoneyForm =
        data.basketPrice.isNotEmpty
            ? data.basketPrice[0].priceId
            : 0;

        return DataRow(
          selected: selectedProduct.contains(data.id),
          onSelectChanged: (value) {
            onSelectedRow(value!, data);
          },
          cells: [
            DataCell(
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 7,
                child: DataRowText(
                  txt: data.store.name,
                  elips: true,
                ),
              ),
            ),
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8),
                ),
                style:
                TextStyle(color: AppColors.whiteColor),
                controller: quantityController,
                onChanged: (newValue) {
                  // Update the quantity value
                },
                onEditingComplete: () {
                  context.read<BasketCubit>().updateBasket(
                      data.storeId,
                      selectedValueMoneyForm,
                      double.parse(agreedPriceController
                          .text
                          .trim()),
                      double.parse(
                        quantityController.text.trim(),
                      ));
                },
              ),
            ),
            DataCell(
              TextFormField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8),
                ),
                controller: agreedPriceController,
                onChanged: (newValue) {
                  // Update the agreed price value
                },
                onEditingComplete: () {
                  context.read<BasketCubit>().updateBasket(
                    data.storeId,
                    selectedValueMoneyForm,
                    double.parse(agreedPriceController
                        .text
                        .trim()),
                    double.parse(
                      quantityController.text.trim(),
                    ),
                  );
                },
                style:
                TextStyle(color: AppColors.whiteColor),
              ),
            ),
            DataCell(
              BlocBuilder<PriceCubit, PriceState>(
                builder: (context, priceState) {
                  if (priceState is PriceLoadingState) {
                    return const CircularProgressIndicator
                        .adaptive();
                  } else if (priceState
                  is PriceErrorState) {
                    return const TextWidget(txt: postError);
                  } else if (priceState
                  is PriceSuccessState) {
                    return Container(
                      height: 40.spMax,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          value: selectedValueMoneyForm,
                          items:
                          priceState.data.map((value) {
                            return DropdownMenuItem(
                              value: value.id,
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(
                                    horizontal: 16.w),
                                child: TextWidget(
                                  txt: value.name,
                                  txtColor: Colors.white,
                                  size: 14.sp,
                                  fontWeight:
                                  FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedValueMoneyForm = value!;

                            if (agreedPriceController
                                .text !=
                                data.basketPrice[0]
                                    .agreedPrice &&
                                quantityController.text !=
                                    data.quantity) {
                              context
                                  .read<BasketCubit>()
                                  .updateBasket(
                                  data.storeId,
                                  selectedValueMoneyForm,
                                  double.parse(
                                      agreedPriceController
                                          .text
                                          .trim()),
                                  double.parse(
                                    quantityController
                                        .text
                                        .trim(),
                                  ));
                            } else {
                              context
                                  .read<BasketCubit>()
                                  .updateBasket(
                                  data.storeId,
                                  selectedValueMoneyForm,
                                  calculateSumma(
                                      double.tryParse(data
                                          .basketPrice[
                                      0]
                                          .agreedPrice) ??
                                          0,
                                      double.parse(state
                                          .orderList
                                          .calc
                                          .dollar
                                          .toString()),
                                      data
                                          .basketPrice[
                                      0]
                                          .priceId,
                                      selectedValueMoneyForm),
                                  double.parse(
                                    quantityController
                                        .text
                                        .trim(),
                                  ));
                            }
                          },
                          dropdownColor:
                          AppColors.primaryColor,
                          isExpanded: true,
                          hint: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            child: const Text(
                              "Pul turini tanlang",
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
            ),
            DataCell(
              DataRowText(
                txt: moneyFormatterWidthDollor(
                  double.parse(
                    data.basketPrice[0].total,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
//   DataRow(
//   selected: selectedProduct.contains(data.id),
//   onSelectChanged: (value) {
//     onSelectedRow(value!, data);
//   },
//   cells: [
//     DataCell(
//       SizedBox(
//         width:
//             MediaQuery.sizeOf(context).width / 7,
//         child: DataRowText(
//           txt: data.store.name,
//           elips: true,
//         ),
//       ),
//     ),
//     DataCell(
//       onTap: () {
//         showCustomDialogWidget(
//           context,
//           TradeChangeDialog(
//             data: data,
//             price: double.parse(
//               data.basketPrice[0].agreedPrice,
//             ),
//             quantity: double.parse(
//               data.quantity,
//             ),
//             moneyFormId:
//                 data.basketPrice[0].priceType.id,
//             dollar: state.orderList.calc.dollar,
//           ),
//           4,
//           2,
//         );
//       },
//       DataRowText(
//         txt: data.quantity,
//       ),
//     ),
//     DataCell(
//       onTap: () {
//         showCustomDialogWidget(
//           context,
//           TradeChangeDialog(
//               data: data,
//               price: double.parse(
//                 data.basketPrice[0].agreedPrice,
//               ),
//               quantity: double.parse(
//                 data.quantity,
//               ),
//               moneyFormId: data
//                   .basketPrice[0].priceType.id,
//               dollar:
//                   state.orderList.calc.dollar),
//           4,
//           2,
//         );
//       },
//       // DataRowText(
//       //   txt: moneyFormatterWidthDollor(
//       //     double.parse(
//       //       data.basketPrice[0].agreedPrice,
//       //     ),
//       //   ),
//       // ),
//       TextField(),
//     ),
//     DataCell(
//       DataRowText(
//         txt: data.basketPrice[0].priceType.name,
//       ),
//     ),
//     DataCell(
//       DataRowText(
//         txt: moneyFormatterWidthDollor(
//           double.parse(
//             data.basketPrice[0].total,
//           ),
//         ),
//       ),
//     ),
//   ],
// );
