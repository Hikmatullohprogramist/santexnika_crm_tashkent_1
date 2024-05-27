import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:santexnika_crm/screens/main/mobile/widget/nav_bar.dart';
import 'package:santexnika_crm/screens/sold/pages/sold_mobile/sold_mobile.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/trade_cubit/basket_state.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_cubit.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_mobile/mobile_widget/pages/store.dart';
import 'package:santexnika_crm/screens/trade/pages/trade_mobile/mobile_widget/sell_screen.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/snek_bar_widget.dart';
import '../../../../tools/appColors.dart';
import '../../../../tools/constantas.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../login/cubit/login_cubit.dart';
import '../../../settings/cubit/branches/branches_cubit.dart';
import '../../../settings/cubit/price/price_cubit.dart';
import '../../../store/cubit/store_cubit.dart';
import 'mobile_widget/listTitle.dart';
import 'mobile_widget/pages/waiting_screen.dart';

class TradeMobileUI extends StatefulWidget {
  const TradeMobileUI({super.key});

  @override
  State<TradeMobileUI> createState() => _TradeMobileUIState();
}

class _TradeMobileUIState extends State<TradeMobileUI> {
  Timer? _searchTimer;

  void handleSearch(String query) {
    if (mounted) {
      _searchTimer?.cancel();

      _searchTimer = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;

            context.read<StoreCubit>().searchProduct(query.trim());
          } else {
            context.read<StoreCubit>().getProduct(0, "");
            searchQuery = "";
          }
        },
      );
    }
  }

  List<int> selectedProduct = [];
  String searchQuery = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<PriceCubit>().getPrice();
      await context.read<BasketCubit>().getBasket();
      await context.read<BranchesCubit>().getBranches();
      await context.read<LoginCubit>().getAuthUser();
    });
    super.initState();
  }

  bool isSelected = false;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    print(selectedProduct);
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: BlocBuilder<BranchesCubit, BranchesState>(
          builder: (context, state) {
            if (state is BranchesSuccessState) {
              return BlocBuilder<LoginCubit, LoginState>(
                builder: (context, userState) {
                  if (userState is LoginSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          txt: isProduction != true
                              ? "${state.data.where((branch) => branch.id == userState.data.branchId).firstOrNull!.name ?? ""} DEV"
                              : "${state.data[0].name}",
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
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          BlocBuilder<BasketCubit, BasketState>(
            builder: (BuildContext context, BasketState state) {
              if (state is BasketSuccess) {
                return IconButton(
                  icon: Icon(
                    isSelected
                        ? Icons.remove_circle_outline_outlined
                        : Icons.done_all,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        isSelected = !isSelected;
                        if (isSelected) {
                          selectedProduct.clear();
                          for (var item in state.orderList.basket) {
                            selectedProduct.add(item.id);
                          }
                        } else {
                          selectedProduct.clear();
                        }
                      },
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: ExpandableBottomSheet(
        enableToggle: true,
        persistentHeader: Container(
          height: 180,
          color: AppColors.primaryColor,
          child: BlocBuilder<BasketCubit, BasketState>(
            builder: (BuildContext context, state) {
              if (state is BasketLoading) {
                return const SizedBox();
              } else if (state is BasketError) {
                return TextWidget(txt: state.error);
              } else if (state is BasketEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Hg(),
                      OneButton(
                        width: double.infinity,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        label: "Qo'shish",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          showMobileDialogWidget(
                            context,
                            const TradeAddWidget(),
                            1.1,
                            1.2,
                          );
                        },
                      ),
                      const Hg(),
                      OneButton(
                        width: double.infinity,
                        icon: Icon(
                          Icons.sell,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        label: "Sotilganlar",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          Get.to(const SoldMobile(
                            isBool: false,
                          ));
                        },
                      ),
                    ],
                  ),
                );
              } else if (state is BasketSuccess) {
                return Container(
                  width: double.infinity,
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<BasketCubit, BasketState>(
                          builder: (BuildContext context, BasketState state) {
                            if (state is BasketSuccess) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                      txt:
                                          "Jami summa (\$): ${moneyFormatterWidthDollor(double.parse(state.orderList.calc.usd.toString()))}"),
                                  TextWidget(
                                      txt:
                                          "Jami summa (so'm): ${moneyFormatterWidthDollor(double.parse(state.orderList.calc.usd.toString()))}"),
                                  TextWidget(
                                      txt:
                                          "Dollar kursi: ${moneyFormatterWidthDollor(double.parse(state.orderList.calc.dollar.toString()))}"),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        const Hg(),
                        BlocBuilder<BasketCubit, BasketState>(
                          builder: (BuildContext context, state) {
                            if (state is BasketLoading) {
                              return const CircularProgressIndicator.adaptive();
                            } else if (state is BasketEmpty) {
                              return const SizedBox();
                            } else if (state is BasketSuccess) {
                              return OneButton(
                                height: 45,
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 25.sp,
                                ),
                                color: AppColors.selectedColor,
                                width: double.infinity,
                                label: "Sotish",
                                labelFontWight: FontWeight.w500,
                                fontSize: 18.sp,
                                onTap: () {
                                  Get.to(
                                    SellMobileUI(
                                      products: state.orderList.basket,
                                      dollarPirce: state.orderList.calc.usd,
                                      somPrice: state.orderList.calc.uzs,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is BasketSuccessCheck) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Hg(),
                      OneButton(
                        width: double.infinity,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        label: "Qo'shish",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          showMobileDialogWidget(
                            context,
                            const TradeAddWidget(),
                            1.1,
                            1.2,
                          );
                        },
                      ),
                      const Hg(),
                      OneButton(
                        width: double.infinity,
                        icon: Icon(
                          Icons.sell,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        label: "Sotilganlar",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          Get.to(const SoldMobile(
                            isBool: false,
                          ));
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        expandableContent: Container(
          color: AppColors.primaryColor,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Hg(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MobileButton(
                        height: 45,
                        icon: Icon(
                          Icons.add_shopping_cart_sharp,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        width: double.infinity,
                        label: "Kutishga olish",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
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
                              : mobileErrorDialogWidgets(context);
                        },
                      ),
                    ),
                    const Wd(),
                    Expanded(
                      child: MobileButton(
                        height: 45,
                        icon: Icon(
                          Icons.shopping_cart_checkout_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        width: double.infinity,
                        label: "Chiqarish",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          isSelected = false;
                          showMobileDialogWidget(
                            context,
                            const WaitingMobileUI(),
                            1.1,
                            1.2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Hg(),
                Row(
                  children: [
                    Expanded(
                      child: MobileButton(
                        height: 45,
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        color: AppColors.errorColor,
                        width: double.infinity,
                        label: "O'chirish",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          mobileDeletedDialog(
                            context,
                            () {
                              selectedProduct.isNotEmpty
                                  ? context
                                      .read<BasketCubit>()
                                      .deleteBasket(selectedProduct)
                                      .then(
                                      (value) {
                                        Get.back();
                                        selectedProduct.clear();
                                      },
                                    )
                                  : mobileErrorDialogWidgets(context);
                            },
                          );
                        },
                      ),
                    ),
                    const Wd(),
                    Expanded(
                      child: MobileButton(
                        height: 45,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        color: AppColors.toqPrimaryColor,
                        width: double.infinity,
                        label: "Qo'shish",
                        labelFontWight: FontWeight.w500,
                        fontSize: 15.sp,
                        onTap: () {
                          showMobileDialogWidget(
                            context,
                            const TradeAddWidget(),
                            1.1,
                            1.2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Hg(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        background: RefreshIndicator(
          onRefresh: () async {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              await context.read<PriceCubit>().getPrice();
              await context.read<BasketCubit>().getBasket().catchError((error) {
                SnackBarWidget().showSnackbar("Muvaffaqiyatsiz", error, 3, 2);
              });
            });
          },
          child: Column(
            children: [
              BlocBuilder<BasketCubit, BasketState>(
                builder: (BuildContext context, BasketState state) {
                  if (state is BasketLoading) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppColors.whiteColor,
                      ),
                    );
                  } else if (state is BasketError) {
                    return Expanded(
                      child: Center(
                        child: MobileAPiError(
                          message: state.error,
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (timeStamp) async {
                                await context.read<PriceCubit>().getPrice();
                                await context
                                    .read<BasketCubit>()
                                    .getBasket()
                                    .catchError(
                                  (error) {
                                    SnackBarWidget().showSnackbar(
                                        "Muvaffaqiyatsiz", error, 3, 2);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  } else if (state is BasketEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<BasketCubit>().getBasket();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Lottie.network(
                            "https://lottie.host/f34bd503-4592-4683-a620-9c9afdb23a96/rPICsWfdcr.json",
                          ),
                          const TextWidget(
                            txt: "Korzinkada mahsulotlar topilmadi",
                          ),
                        ],
                      ),
                    );
                  } else if (state is BasketSuccess) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.orderList.basket.length,
                        itemBuilder: (con, index) {
                          var data = state.orderList.basket[index];
                          return ListTile(
                            title: TradeListTitle(
                              color: selectedProduct.contains(data.id)
                                  ? AppColors.selectedColor
                                  : AppColors.primaryColor,
                              txt: data.store.name,
                              quality: double.parse(data.quantity),
                              types: data.basketPrice[0].priceType!.name,
                              price:
                                  double.parse(data.basketPrice[0].agreedPrice),
                              allPrice: double.parse(data.basketPrice[0].total),
                              quantity: double.parse(
                                data.quantity,
                              ),
                              moneyFormId: data.basketPrice[0].priceType!.id,
                              dollar: state.orderList.calc.dollar,
                              data: data,
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedProduct.isEmpty) {
                                  isSelected = false;
                                } else {
                                  isSelected = true;
                                }
                                if (selectedProduct.contains(data.id)) {
                                  selectedProduct.remove(data.id);
                                  if (selectedProduct.isEmpty) {
                                    isSelected = false;
                                  }
                                } else {
                                  selectedProduct.add(data.id);
                                }
                              });
                            },
                            selected: selectedProduct.contains(data.id),
                          );
                        },
                      ),
                    );
                  } else if (state is BasketSuccessCheck) {
                    return Expanded(
                      child: Center(
                        child: MobileAPiError(
                          message:
                              "Muvaffaqiyatli sotildi. Chek ${state.checkId}",
                          onTap: () {
                            context.read<BasketCubit>().getBasket();
                          },
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: 100,
                      height: 100,
                      color: AppColors.toqPrimaryColor,
                    );
                  }
                },
              ),
              const Hg(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
