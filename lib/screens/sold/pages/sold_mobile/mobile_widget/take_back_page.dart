import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/models/orders/orderWithIdModel.dart';
import 'package:santexnika_crm/screens/returned_ones/cubit/returned_store_cubit.dart';
import 'package:santexnika_crm/screens/sold/cubit/sold_cubit.dart';
import 'package:santexnika_crm/screens/sold/pages/sold_mobile/mobile_widget/take_back_dialog.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/header_text_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../errors/service_error.dart';
import '../../../../../tools/money_formatter.dart';

class MobileTakeBackPage extends StatefulWidget {
  final int? id;

  const MobileTakeBackPage({
    super.key,
    this.id,
  });

  @override
  State<MobileTakeBackPage> createState() => _MobileTakeBackPageState();
}

class _MobileTakeBackPageState extends State<MobileTakeBackPage> {
  List<Basket> selectedProduct = [];
  int? selectedPrice;
  int? selectedType;
  bool isSelected = false;
  late SoldCubit soldCubit; // Access your Cubit

  Future<void> _refreshSold() async {
    context.read<SoldCubit>().getSoldWithId(0, widget.id!);
  }

  @override
  void initState() {
    soldCubit = context.read<SoldCubit>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SoldCubit>().getSoldWithId(0, widget.id!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: TextWidget(txt: "Chek raqami: ${widget.id ?? 0}"),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () {
            soldCubit.refreshSold('');
            Get.back();
          },
        ),
        actions: [
          BlocBuilder<SoldCubit, SoldState>(
            builder: (context, state) {
              if (state is SoldWithIDSuccess) {
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
                          for (var item in state.data.data!.baskets!) {
                            selectedProduct.add(item);
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
        expandableContent: BlocBuilder<SoldCubit, SoldState>(
          builder: (BuildContext context, SoldState state) {
            if (state is SoldWithIDSuccess) {
              return Container(
                color: AppColors.primaryColor,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      const HeaderTextWidget(
                        first: 'Jami summa so\'m:',
                        second: 'Jami summa \$:',
                      ),
                      HeaderTextWidget(
                        first: state.data.total!.sum == null
                            ? "0"
                            : state.data.total!.sum.toString(),
                        second: (state.data.total!.dollar ?? 0).toString(),
                      ),
                      const Hg(),
                      const HeaderTextWidget(
                        first: 'Qaytarilgan (so\'m):',
                        second: 'Qaytarilgan (\$):',
                      ),
                      HeaderTextWidget(
                        first: (state.data.total!.reduce_price ?? 0).toString(),
                        second:
                            (state.data.total!.reduce_price ?? 0).toString(),
                      ),
                      const Hg(),
                      const Hg()
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        persistentHeader: Container(
          height: 100,
          color: AppColors.primaryColor,
          child: BlocBuilder<SoldCubit, SoldState>(
            builder: (BuildContext context, SoldState state) {
              if (state is SoldWithIDSuccess) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Center(
                    child: OneButton(
                      width: double.infinity,
                      color: AppColors.bottombarColor,
                      label: "Qaytib olish",
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Get.to(
                          MobileTakeBackDialog(
                            selectedProducts: selectedProduct,
                            data: state.data.data!.baskets!,
                            onTap: () {
                              selectedProduct.clear();
                              _refreshSold();
                              Get.back();
                            },
                            id: widget.id!,
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        background: Column(
          children: [
            BlocBuilder<SoldCubit, SoldState>(
              builder: (BuildContext context, SoldState state) {
                if (state is SoldLoadingState) {
                  return const Expanded(
                    child: ApiLoadingWidget(),
                  );
                } else if (state is SoldErrorState) {
                  return Expanded(
                    child: Center(
                      child: MobileAPiError(
                        message: state.error,
                        onTap: () {
                          context.read<SoldCubit>().getSold(0, '');
                        },
                      ),
                    ),
                  );
                } else if (state is SoldEmptyState) {
                  return Expanded(
                    child: Center(
                      child: MobileAPiError(
                        message: empty,
                        onTap: () {
                          context
                              .read<SoldCubit>()
                              .getSoldWithId(0, widget.id!);
                        },
                      ),
                    ),
                  );
                } else if (state is SoldWithIDSuccess) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshSold,
                      child: ListView.builder(
                        itemCount: state.data.data!.baskets!.length,
                        itemBuilder: (context, index) {
                          var data = state.data.data!.baskets![index];
                          return ListTile(
                            selected: selectedProduct
                                .any((element) => element == data),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MobileBackgroundWidget(
                                onTap: () {
                                  setState(
                                    () {
                                      if (selectedProduct.isEmpty) {
                                        isSelected = false;
                                      } else {
                                        isSelected = true;
                                      }
                                      if (selectedProduct
                                          .any((element) => element == data)) {
                                        selectedProduct.remove(data);
                                        if (selectedProduct.isEmpty) {
                                          isSelected = false;
                                        }
                                      } else {
                                        selectedProduct.add(data);
                                      }
                                    },
                                  );
                                },
                                color: selectedProduct
                                        .any((element) => element == data)
                                    ? AppColors.selectedColor
                                    : AppColors.primaryColor,
                                child: Column(
                                  children: [
                                    const HeaderTextWidget(
                                        first: "Nomi:", second: 'Miqdori:'),
                                    HeaderTextWidget(
                                      first: data.store.name ?? '',
                                      second: moneyFormatterWidthDollor(
                                        double.parse(
                                          data.quantity,
                                        ),
                                      ),
                                      size: 15,
                                    ),
                                    const Hg(),
                                    const HeaderTextWidget(
                                        first: "Kelishligan narx:",
                                        second: 'Jami narx:'),
                                    HeaderTextWidget(
                                      first: moneyFormatterWidthDollor(
                                        double.parse(
                                            data.basketPrice[0].agreedPrice),
                                      ),
                                      second: data.basketPrice[0].priceId == 1
                                          ? moneyFormatter(
                                              double.parse(
                                                data.basketPrice[0].priceSell,
                                              ),
                                            )
                                          : moneyFormatterWidthDollor(
                                              double.parse(
                                                data.basketPrice[0].priceSell,
                                              ),
                                            ),
                                      size: 15,
                                    ),
                                    const Hg(),
                                    const HeaderTextWidget(
                                        first: "Pul turi:",
                                        second: 'Shtrih kod:'),
                                    HeaderTextWidget(
                                      first:
                                          "${checkPrice(data.basketPrice[0].priceId)}",
                                      second: moneyFormatter(
                                        double.parse(
                                            data.store.barcode.toString()),
                                      ),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.red,
                    width: 100,
                    height: 100,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
