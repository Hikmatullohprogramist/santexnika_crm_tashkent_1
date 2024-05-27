import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:santexnika_crm/models/orders/ordersModel.dart';
import 'package:santexnika_crm/screens/sold/pages/sold_mobile/mobile_widget/take_back_page.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/input/mobile_search.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../main/mobile/widget/nav_bar.dart';
import '../../../store/cubit/store_cubit.dart';
import '../../cubit/sold_cubit.dart';

class SoldMobile extends StatefulWidget {
  final bool? isBool;

  const SoldMobile({Key? key, this.isBool}) : super(key: key);

  @override
  State<SoldMobile> createState() => _SoldMobileState();
}

class _SoldMobileState extends State<SoldMobile> {
  String searchQuery = "";

  late SoldCubit soldCubit; // Access your Cubit
  @override
  void initState() {
    super.initState();
    soldCubit = context.read<SoldCubit>();
    soldCubit.refreshSold(searchQuery); // Fetch initial data
    soldCubit.isMobile = true;
    soldCubit.pageRequest(searchQuery);
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

  @override
  void dispose() {
    if (mounted) {
      // soldCubit.closed(); // Close the SoldCubit when no longer needed
    }

    super.dispose();
  }

  Timer? searchTime;

  void handleSearch(String query) {
    if (mounted) {
      searchTime?.cancel();

      searchTime = Timer(const Duration(microseconds: 600), () {
        if (query.isNotEmpty) {
          searchQuery = query;
          context.read<SoldCubit>().searchSold(
                searchQuery,
              );
        } else {
          soldCubit.refreshSold('');
          print('object');
        }
      });
    }
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      drawer: widget.isBool ?? true ? const NavBar() : null,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(txt: "Sotilganlar"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // soldCubit.refreshSold(searchQuery);
        },
        child: Column(
          children: [
            const Hg(),
            MobileSearchInput(
              onChanged: (v) {
                // // searchQuery = v;
                // // //
                // // soldCubit.refreshSold(v);
                handleSearch(v);

              },
            ),
            const Hg(
              height: 5,
            ),
            BlocBuilder<SoldCubit, SoldState>(
              builder: (BuildContext context, state) {
                if (state is SoldLoadingState || state is SoldInitial) {
                  return const Expanded(child: ApiLoadingWidget());
                } else if (state is SoldErrorState) {
                  return Expanded(
                    child: Center(
                      child: MobileAPiError(
                        message: state.error,
                        onTap: () {
                          context.read<SoldCubit>().getSold(0, searchQuery);
                        },
                      ),
                    ),
                  );
                } else if (state is SoldErrorForPanginationState) {
                  return TextWidget(txt: state.error);
                }
                if (state is SoldSuccessState) {
                  return Expanded(
                    child: PagedListView<int, OrdersModel>(
                      pagingController: soldCubit.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<OrdersModel>(
                        newPageProgressIndicatorBuilder: (ctx) =>
                            const ApiLoadingWidget(),
                        itemBuilder: (BuildContext context, OrdersModel item,
                            int index) {
                          if (index < state.data.data.length) {
                            var data = state.data.data[index];
                            return ListTile(
                              title: InkWell(
                                onTap: () async {
                                  Get.to(
                                    MobileTakeBackPage(
                                      id: data.id,
                                    ),
                                  );
                                },
                                child: MobileBackgroundWidget(
                                  child: Column(
                                    children: [
                                      RowsTextWidget(
                                        title: "Chek raqami: ",
                                        name: "${data.id ?? 0} and $index",
                                      ),
                                      const Hg(
                                        height: 5,
                                      ),
                                      RowsTextWidget(
                                        title: "Haridor: ",
                                        name: data.customer?.name ??
                                            'Xaridorsiz savdo',
                                      ),
                                      const Hg(
                                        height: 5,
                                      ),
                                      RowsTextWidget(
                                        title: "Sotuvchi: ",
                                        name: data.user?.name ?? 'Sotuvchi',
                                      ),
                                      const Hg(
                                        height: 5,
                                      ),
                                      RowsTextWidget(
                                        title: "Sana: ",
                                        name: formatDate(
                                          DateTime.parse(
                                            data.createdAt.toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }

                        },
                      ),
                    ),
                  );
                  //   Expanded(
                  //   child: RefreshIndicator(
                  //     onRefresh: _refreshSold,
                  //     child: NotificationListener<ScrollNotification>(
                  //       onNotification: (ScrollNotification scrollInfo) {
                  //         if (!soldCubit.hasReachedMax &&
                  //             scrollInfo.metrics.pixels ==
                  //                 scrollInfo.metrics.maxScrollExtent) {
                  //           soldCubit.getSold(
                  //             soldCubit.currentPage ++,
                  //             '', // Increment currentPage by 1
                  //           );
                  //         }
                  //         return false;
                  //       },
                  //       child: ListView.builder(
                  //         controller: scrollController,
                  //         itemCount: state.data.data.length +
                  //             (soldCubit.hasReachedMax ? 0 : 1),
                  //         // Add one for loading indicator if not reached max
                  //         itemBuilder: (context, index) {
                  //           if (index < state.data.data.length) {
                  //             var data = state.data.data[index];
                  //             return ListTile(
                  //               title: InkWell(
                  //                 onTap: () async {
                  //                   Get.to(
                  //                     MobileTakeBackPage(
                  //                       id: data.id,
                  //                     ),
                  //                   );
                  //                 },
                  //                 child: MobileBackgroundWidget(
                  //                   child: Column(
                  //                     children: [
                  //                       RowsTextWidget(
                  //                         title: "Chek raqami: ",
                  //                         name: "${data.id ?? 0}",
                  //                       ),
                  //                       const Hg(
                  //                         height: 5,
                  //                       ),
                  //                       RowsTextWidget(
                  //                         title: "Haridor: ",
                  //                         name: data.customer?.name ??
                  //                             'Xaridorsiz savdo',
                  //                       ),
                  //                       const Hg(
                  //                         height: 5,
                  //                       ),
                  //                       RowsTextWidget(
                  //                         title: "Sotuvchi: ",
                  //                         name: data.user?.name ?? 'Sotuvchi',
                  //                       ),
                  //                       const Hg(
                  //                         height: 5,
                  //                       ),
                  //                       RowsTextWidget(
                  //                         title: "Sana: ",
                  //                         name: formatDate(
                  //                           DateTime.parse(
                  //                             data.createdAt.toString(),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           } else {
                  //             if (!soldCubit.hasReachedMax) {
                  //               return const Padding(
                  //                 padding: EdgeInsets.all(8.0),
                  //                 child: Center(
                  //                   child: CircularProgressIndicator(),
                  //                 ),
                  //               );
                  //             } else {
                  //               return const TextWidget(txt: 'txt');
                  //             }
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // );
                } else if (state is SoldSearchSuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.data.length,
                      itemBuilder: (context, index) {
                        if (index < state.data.data.length) {
                          var data = state.data.data[index];
                          return ListTile(
                            title: InkWell(
                              onTap: () async {
                                Get.to(
                                  MobileTakeBackPage(
                                    id: data.id,
                                  ),
                                );
                              },
                              child: MobileBackgroundWidget(
                                child: Column(
                                  children: [
                                    RowsTextWidget(
                                      title: "Chek raqami: ",
                                      name: "${data.id ?? 0} and $index",
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: "Haridor: ",
                                      name: data.customer?.name ??
                                          'Xaridorsiz savdo',
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: "Sotuvchi: ",
                                      name: data.user?.name ?? 'Sotuvchi',
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: "Sana: ",
                                      name: formatDate(
                                        DateTime.parse(
                                          data.createdAt.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
