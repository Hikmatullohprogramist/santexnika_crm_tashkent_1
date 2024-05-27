import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../../models/basket/productsAddModel.dart';
import '../../../../../../tools/appColors.dart';
import '../../../../../../widgets/mobile/button.dart';
import '../../../../../../widgets/mobile/mobile_input.dart';
import '../../../../../store/pages/mobile/widget/pages/add_product.dart';
import '../../../../cubit/waiting/trade_cubit/basket_cubit.dart';

class TradeAddWidget extends StatefulWidget {
  const TradeAddWidget({Key? key}) : super(key: key);

  @override
  _TradeAddWidgetState createState() => _TradeAddWidgetState();
}

class _TradeAddWidgetState extends State<TradeAddWidget> {
  List<bool> _selected = [];
  List<ProductsAddModel> selectedProduct = [];
  Timer? _searchTimer;
  String searchQuery = "";
  int currentPage = 1;
  late StoreCubit storeCubit;

  void initStateData() {
    storeCubit = context.read<StoreCubit>();
    storeCubit.refreshStore(searchQuery);
    print('ishga tushb ketdi');
    storeCubit.isMobile = true;
    storeCubit.pageRequest(searchQuery);
  }

  @override
  void initState() {
    initStateData();
    super.initState();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

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
            context.read<StoreCubit>().getProduct(1, "");
            searchQuery = "";
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                txt: "Ombordagi mahsulotlar",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Hg(),
        Padding(
          padding: EdgeInsets.only(left: 15.0.w, right: 23.w, top: 10),
          child: MobileInput(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            inputWidth: double.infinity,
            visible: false,
            radius: 5,
            hintText: "Qidirish",
            onChanged: (v) {
              handleSearch(v);
            },
          ),
        ),
        const Hg(),
        BlocBuilder<StoreCubit, StoreState>(
          // buildWhen: (previous, current) =>
          //     current is! StoreForPaginationLoadingState &&
          //     current is! StoreForPaginationErrorState &&
          //     current is! StoreInitial,
          builder: (BuildContext context, state) {
            if (state is StoreLoadingState) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            } else if (state is StoreErrorState) {
              return Expanded(
                child: Center(
                  child: MobileAPiError(
                    message: state.error,
                    onTap: () {
                      context.read<StoreCubit>().getProduct(
                            0,
                            "",
                          );
                    },
                  ),
                ),
              );
            } else if (state is StoreSuccessState) {
              _initializeSelectedList(state.data.data.length);
              return Expanded(
                child: PagedListView(
                  pagingController: storeCubit.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) {
                      var data = state.data.data[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (v) {
                                setState(() {
                                  showCustomDialogWidget(
                                    context,
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const TextWidget(
                                          txt: "Rostan ham o'chirmoqchimisiz",
                                          txtColor: Colors.redAccent,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MobileButton(
                                                label: "Bekor qilish",
                                                isVisible: false,
                                                onTap: () {
                                                  Get.back();
                                                },
                                              ),
                                            ),
                                            const Wd(),
                                            Expanded(
                                              child: MobileButton(
                                                label: "O'chirish",
                                                isVisible: false,
                                                color: Colors.redAccent,
                                                onTap: () {},
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    1.3,
                                    6,
                                  );
                                });
                              },
                              backgroundColor: AppColors.errorColor,
                              icon: Icons.delete,
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            SlidableAction(
                              onPressed: (v) {
                                Get.to(
                                  MobileAddProductUi(
                                    name: data.name,
                                    comePrice: data.priceCome,
                                    oem: data.madeIn,
                                    priceCell: data.priceSell,
                                    barCode: data.barcode,
                                    quantity: data.quantity,
                                    dangerCount: data.dangerCount,
                                    totalPrice: data.priceWholesale,
                                    categoryVaule: data.categoryId,
                                    selectedValuee: data.priceId,
                                    id: int.parse(data.id.toString()),
                                    forAdd: false,
                                  ),
                                );
                              },
                              backgroundColor: AppColors.selectedColor,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            var productId = data.id!;
                            if (selectedProduct.any(
                                (product) => product.productId == productId)) {
                              selectedProduct.removeWhere(
                                  (product) => product.productId == productId);
                            } else {
                              selectedProduct.add(
                                ProductsAddModel(
                                  quantity: 1,
                                  productId: productId,
                                ),
                              );
                            }

                            setState(() {});
                          },
                          selected: selectedProduct
                              .any((product) => product.productId == data.id),
                          title: MobileBackgroundWidget(
                            color: selectedProduct.any(
                                    (product) => product.productId == data.id)
                                ? AppColors.selectedColor
                                : AppColors.primaryColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        txt: "Nomi: ${data.name ?? ''} ",
                                        elips: true,
                                      ),
                                      TextWidget(
                                        txt:
                                            "Kategorya: ${data.category?.name ?? ''}",
                                        elips: true,
                                      ),
                                      TextWidget(
                                        txt: "Miqdori: ${data.quantity ?? '0'}",
                                        elips: true,
                                      ),
                                      TextWidget(
                                        txt:
                                            "Sotish narx: ${data.priceSell ?? '0'}",
                                        elips: true,
                                      ),
                                      TextWidget(
                                        txt:
                                            "Shtirx kod: ${data.barcode ?? '0'}",
                                        elips: true,
                                      ),
                                      TextWidget(
                                        txt:
                                            "Pul turi: ${data.price?.name ?? '0'}",
                                        elips: true,
                                      ),
                                    ],
                                  ),
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
            } else if (state is StoreSearchSuccessState) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.data.data.length,
                  itemBuilder: (context, index) {
                   var data = state.data.data[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (v) {
                              setState(() {
                                showCustomDialogWidget(
                                  context,
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TextWidget(
                                        txt: "Rostan ham o'chirmoqchimisiz",
                                        txtColor: Colors.redAccent,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MobileButton(
                                              label: "Bekor qilish",
                                              isVisible: false,
                                              onTap: () {
                                                Get.back();
                                              },
                                            ),
                                          ),
                                          const Wd(),
                                          Expanded(
                                            child: MobileButton(
                                              label: "O'chirish",
                                              isVisible: false,
                                              color: Colors.redAccent,
                                              onTap: () {},
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  1.3,
                                  6,
                                );
                              });
                            },
                            backgroundColor: AppColors.errorColor,
                            icon: Icons.delete,
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          SlidableAction(
                            onPressed: (v) {
                              Get.to(
                                MobileAddProductUi(
                                  name: data.name,
                                  comePrice: data.priceCome,
                                  oem: data.madeIn,
                                  priceCell: data.priceSell,
                                  barCode: data.barcode,
                                  quantity: data.quantity,
                                  dangerCount: data.dangerCount,
                                  totalPrice: data.priceWholesale,
                                  categoryVaule: data.categoryId,
                                  selectedValuee: data.priceId,
                                  id: int.parse(data.id.toString()),
                                  forAdd: false,
                                ),
                              );
                            },
                            backgroundColor: AppColors.selectedColor,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          var productId = data.id!;
                          if (selectedProduct.any(
                                  (product) => product.productId == productId)) {
                            selectedProduct.removeWhere(
                                    (product) => product.productId == productId);
                          } else {
                            selectedProduct.add(
                              ProductsAddModel(
                                quantity: 1,
                                productId: productId,
                              ),
                            );
                          }
                
                          setState(() {});
                        },
                        selected: selectedProduct
                            .any((product) => product.productId == data.id),
                        title: MobileBackgroundWidget(
                          color: selectedProduct.any(
                                  (product) => product.productId == data.id)
                              ? AppColors.selectedColor
                              : AppColors.primaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      txt: "Nomi: ${data.name ?? ''} ",
                                      elips: true,
                                    ),
                                    TextWidget(
                                      txt:
                                      "Kategorya: ${data.category?.name ?? ''}",
                                      elips: true,
                                    ),
                                    TextWidget(
                                      txt: "Miqdori: ${data.quantity ?? '0'}",
                                      elips: true,
                                    ),
                                    TextWidget(
                                      txt:
                                      "Sotish narx: ${data.priceSell ?? '0'}",
                                      elips: true,
                                    ),
                                    TextWidget(
                                      txt:
                                      "Shtirx kod: ${data.barcode ?? '0'}",
                                      elips: true,
                                    ),
                                    TextWidget(
                                      txt:
                                      "Pul turi: ${data.price?.name ?? '0'}",
                                      elips: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextWidget(
            txt: "Tanlangan mahsulotlar soni: ${selectedProduct.length}",
            size: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        BlocBuilder<StoreCubit, StoreState>(
          builder: (BuildContext context, StoreState state) {
            if (state is StoreLoadingState ) {
              return CircularProgressIndicator.adaptive();
            } else if (state is StoreSuccessState || state is StoreSearchSuccessState ) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MobileButton(
                        onTap: () {
                          Get.back();
                        },
                        height: 45,
                        label: "Bekor qilish",
                        icon: Icon(
                          Icons.exit_to_app,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    const Wd(),
                    Expanded(
                      child: MobileButton(
                        progress: state is StoreLoadingState,
                        color: AppColors.selectedColor,
                        height: 45,
                        label: "Qo'shish",
                        onTap: () {
                          context.read<BasketCubit>().postBasket(
                                selectedProduct,
                                1,
                              );
                          Get.back();
                        },
                        icon: Icon(
                          Icons.add,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }

  void _initializeSelectedList(int length) {
    _selected = List.generate(length, (_) => false);
  }

// void _handleDeleteAction(int index, int? id) {
//   setState(() {
//     _selected[index] = false; // Deselect the item
//     if (id != null) {
//       selectedProduct.add(id);
//       context.read<StoreCubit>().deleteProduct(selectedProduct).then(
//         (_) {
//           selectedProduct.clear();
//           Navigator.pop(context);
//         },
//       ).catchError(
//         (error) {
//           print(error);
//         },
//       );
//     }
//   });
// }
}
