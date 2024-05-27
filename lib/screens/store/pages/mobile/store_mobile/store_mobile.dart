import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:santexnika_crm/models/orders/orderWithIdModel.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/screens/main/mobile/widget/nav_bar.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/screens/store/pages/mobile/widget/mobile_transfer_ui.dart';
import 'package:santexnika_crm/screens/store/pages/mobile/widget/pages/add_product.dart';
import 'package:santexnika_crm/widgets/input/mobile_search.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../../tools/appColors.dart';

import '../widget/listTitle.dart';

class StoreMobileUI extends StatefulWidget {
  const StoreMobileUI({super.key});

  @override
  State<StoreMobileUI> createState() => _StoreMobileUIState();
}

class _StoreMobileUIState extends State<StoreMobileUI> {
  String searchQuery = '';

  late StoreCubit storeCubit;

  @override
  void initState() {
    super.initState();
    storeCubit = context.read<StoreCubit>();
    storeCubit.refreshStore(searchQuery);
    print('ishga tushb ketdi');
    storeCubit.isMobile = true;
    storeCubit.pageRequest(searchQuery);
    // soldCubit.pagingController.addStatusListener(
    //   (status) {
    //     if (status == PagingStatus.completed) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: const Text("Hamma ma'lumotlar yuklandi)"),
    //           action: SnackBarAction(
    //             label: 'Boshiga qaytish 👆',
    //             onPressed: () => soldCubit.refreshSold(searchQuery),
    //           ),
    //           duration: const Duration(milliseconds: 200), // Set duration to infinity
    //         ),
    //       );
    //     }
    //   },
    // );

    // soldCubit.pageRequest(searchQuery);
  }



  bool isSelected = false;

  List<int> selectedProduct = [];
  List<ProductModel> selectedProductsForTransfer = [];
  bool checkBox = false;
  int selectedIndex = 0;
  int currentPage = 1;
  bool isLoading = false;
  final scrollController = ScrollController();

  Timer? _searchTimer;

  void handleSearch(String query) {
    if (mounted) {
      _searchTimer?.cancel();

      _searchTimer = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;
            context
                .read<StoreCubit>()
                .searchProductMobile(query.trim(), currentPage);
          } else {
            storeCubit.refreshStore('');
            searchQuery = "";
          }
        },
      );
    }
  }
  bool isDataLoading = false;


  @override
  Widget build(BuildContext context) {
    print(selectedProduct);
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      drawer: const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(txt: "Ombor"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              showCustomDialogWidget(
                context,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onTap: () {
                              selectedProduct.isNotEmpty
                                  ? context
                                      .read<StoreCubit>()
                                      .deleteProduct(selectedProduct)
                                      .then(
                                      (_) {
                                        selectedProduct.clear();
                                        Navigator.pop(context);
                                      },
                                    ).catchError(
                                      (error) {
                                        print(error);
                                      },
                                    )
                                  : errorDialogWidgets(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                1.3,
                6,
              );
            },
            child: const Icon(Icons.delete),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              child: const Icon(Icons.next_plan_outlined),
              onTap: () {
                currentPage = 1;
                BlocProvider.of<StoreCubit>(context).clearData();
                showCustomDialogWidget(
                  context,
                  MobileTransferUi(
                    selectedProducts: selectedProductsForTransfer,
                  ),
                  1.2,
                  1.5,
                );
                selectedProduct.clear();
              },
            ),
          ),
          BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              if (state is StoreSuccessState) {
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
                          for (var item in state.data.data) {
                            selectedProduct.add(item.id!);
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
      body: RefreshIndicator(
        onRefresh: () async {
          storeCubit.clearData();
          storeCubit.refreshStore('');
          print('1 marta');
          // await Future.delayed(
          //   const Duration(seconds: 1),
          // );
          // context.read<StoreCubit>().getProduct(
          //       0,
          //       "",
          //     );
          // storeCubit = BlocProvider.of<StoreCubit>(context);
          // storeCubit.clearData();
          // currentPage = 1;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Hg(),
            MobileSearchInput(
              onChanged: (c) {
                handleSearch(c);
              },
            ),
            const Hg(),
            BlocBuilder<StoreCubit, StoreState>(
              // buildWhen: (previous, current) =>
              // current is! StoreForPaginationLoadingState &&
              //     current is! StoreForPaginationErrorState &&
              //     current is! StoreInitial &&
              //     current is! StoreSearchSuccessState,
              builder: (BuildContext context, state) {
                print(state);
                if (state is StoreLoadingState || state is StoreInitial) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                } else if (state is StoreErrorState) {
                  return Center(
                    child: MobileAPiError(
                      message: state.error,
                      onTap: () {
                        storeCubit.refreshStore('');
                        storeCubit = BlocProvider.of<StoreCubit>(context);
                        storeCubit.clearData();
                        currentPage = 1;
                      },
                    ),
                  );
                } else if (state is StoreSuccessState) {
                  print('state is Success');
                  return Expanded(
                    child: PagedListView<int, ProductModel>(
                      pagingController: storeCubit.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                        newPageProgressIndicatorBuilder: (ctx) =>
                            const ApiLoadingWidget(),
                        itemBuilder: (
                          BuildContext context,
                          ProductModel item,
                          int index,
                        ) {
                          if (index < state.data.data.length) {
                            var data = state.data.data[index];
                            isSelected = storeCubit.selected[
                                index]; // Get the selected status for this product

                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (v) {
                                      BlocProvider.of<StoreCubit>(context)
                                          .clearData();
                                      setState(
                                        () {
                                          showCustomDialogWidget(
                                            context,
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const TextWidget(
                                                  txt:
                                                      "Rostan ham o'chirmoqchimisiz",
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
                                                        onTap: () {
                                                          isSelected =
                                                              false; // Deselect the item
                                                          selectedProduct.add(
                                                              data.id ?? 0);
                                                          context
                                                              .read<
                                                                  StoreCubit>()
                                                              .deleteProduct(
                                                                  selectedProduct);
                                                          Get.back();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            1.3,
                                            6,
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: AppColors.errorColor,
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  SlidableAction(
                                    onPressed: (v) {
                                      currentPage = 1;
                                      BlocProvider.of<StoreCubit>(context)
                                          .clearData();
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
                                          // image: data.image,
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
                                selected: selectedProduct.contains(data.id),
                                title: MobileStoreListTitle(
                                  // image: data.media!,
                                  name: "${data.name} ${index}" ?? '',
                                  color: selectedProduct.contains(data.id)
                                      ? AppColors.selectedColor
                                      : AppColors.primaryColor,
                                  quality: double.parse(data.quantity ?? '0'),
                                  category: "${data.category?.name} $index",
                                  oem: data.madeIn ?? '',
                                  barCode: double.parse(data.barcode ?? '0'),
                                  comePrice:
                                      double.parse(data.priceCome ?? '0'),
                                  sellPrice:
                                      double.parse(data.priceSell ?? '0'),
                                  date: DateTime.parse(
                                      data.createdAt ?? '0000-00-00'),
                                  checkBox: isSelected,
                                  onChanged: (bool? selected) {
                                    if (selected != null) {
                                      setState(() {
                                        isSelected = selected;
                                      });
                                    }
                                  },
                                  onTap: () {
                                    setState(() {
                                      if (selectedProduct.contains(data.id)) {
                                        selectedProduct.remove(data.id);
                                        selectedProductsForTransfer
                                            .remove(data);
                                      } else {
                                        selectedProduct.add(data.id!);
                                        selectedProductsForTransfer.add(data);
                                      }
                                    });
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
                  );
                } else if (state is StoreSearchSuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.data.length,
                      itemBuilder: (context, index) {
                        var data = state.data.data[index];
                        if (storeCubit.selected.length <= index) {
                          storeCubit.selected.add(false);
                        }
                        if (index < state.data.data.length) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (v) {
                                    currentPage = 1;
                                    BlocProvider.of<StoreCubit>(context)
                                        .clearData();
                                    setState(
                                      () {
                                        showCustomDialogWidget(
                                          context,
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const TextWidget(
                                                txt:
                                                    "Rostan ham o'chirmoqchimisiz",
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
                                                      onTap: () {
                                                        isSelected =
                                                            false; // Deselect the item
                                                        selectedProduct
                                                            .add(data.id ?? 0);
                                                        context
                                                            .read<StoreCubit>()
                                                            .deleteProduct(
                                                                selectedProduct);
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          1.3,
                                          6,
                                        );
                                      },
                                    );
                                  },
                                  backgroundColor: AppColors.errorColor,
                                  icon: Icons.delete,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SlidableAction(
                                  onPressed: (v) {
                                    currentPage = 1;
                                    BlocProvider.of<StoreCubit>(context)
                                        .clearData();
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
                                        // image: data.image,
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
                              selected: selectedProduct.contains(data.id),
                              title: MobileStoreListTitle(
                                // image: data.media!,
                                name: data.name ?? '',
                                color: selectedProduct.contains(data.id)
                                    ? AppColors.selectedColor
                                    : AppColors.primaryColor,
                                quality: double.parse(data.quantity ?? '0'),
                                category: "${data.category?.name} $index",
                                oem: data.madeIn ?? '',
                                barCode: double.parse(data.barcode ?? '0'),
                                comePrice: double.parse(data.priceCome ?? '0'),
                                sellPrice: double.parse(data.priceSell ?? '0'),
                                date: DateTime.parse(
                                    data.createdAt ?? '0000-00-00'),
                                checkBox: isSelected,
                                onChanged: (bool? selected) {
                                  if (selected != null) {
                                    setState(() {
                                      isSelected = selected;
                                    });
                                  }
                                },
                                onTap: () {
                                  setState(() {
                                    if (selectedProduct.contains(data.id)) {
                                      selectedProduct.remove(data.id);
                                      selectedProductsForTransfer.remove(data);
                                    } else {
                                      selectedProduct.add(data.id!);
                                      selectedProductsForTransfer.add(data);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        } else if (isLoading) {
                          return _loadingIndicator();
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  );
                } else {
                  return Container(
                    height: 20,
                    width: 20,
                    color: AppColors.errorColor,
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentPage = 1;
          BlocProvider.of<StoreCubit>(context).clearData();
          Get.to(
            const MobileAddProductUi(
              forAdd: true,
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            50.r,
          ),
          // Adjust the border radius as needed
          side: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ), // Border color and width
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    );
  }
}
