import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:santexnika_crm/models/retruned_store/returnedStoreModel.dart';
import 'package:santexnika_crm/screens/returned_ones/cubit/returned_store_cubit.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import 'package:santexnika_crm/widgets/mobile_api_error.dart';

import 'package:santexnika_crm/widgets/sized_box.dart';

import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../tools/format_date_time.dart';
import '../../../../widgets/input/mobile_search.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../main/mobile/widget/nav_bar.dart';

class ReturnedOnesMobileUI extends StatefulWidget {
  const ReturnedOnesMobileUI({super.key});

  @override
  State<ReturnedOnesMobileUI> createState() => _ReturnedOnesMobileUIState();
}

class _ReturnedOnesMobileUIState extends State<ReturnedOnesMobileUI> {
  late ReturnedStoreCubit returnedStoreCubit;

  @override
  void initState() {
    returnedStoreCubit = context.read<ReturnedStoreCubit>();
    returnedStoreCubit.refreshReturned();
    returnedStoreCubit.isMobile = true;
    returnedStoreCubit.pageRequest();
    super.initState();
  }

  Timer? searchTime;

  void handleSearch(String query) {
    if (mounted) {
      searchTime?.cancel();

      searchTime = Timer(const Duration(microseconds: 600), () {
        if (query.isNotEmpty) {
          searchQuery = query;
          context.read<ReturnedStoreCubit>().searchReturnedOnes(query.trim());
        } else {
          context.read<ReturnedStoreCubit>().getReturnedStore(0, '');
        }
      });
    }
  }

  int currentPage = 0;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      backgroundColor: AppColors.bottombarColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(txt: "Qaytarilganlar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Hg(),
          MobileSearchInput(
            onChanged: (v) {
              handleSearch(v);
            },
          ),
          const Hg(),
          BlocBuilder<ReturnedStoreCubit, ReturnedStoreState>(
            builder: (BuildContext context, state) {
              if (state is ReturnedStoreLoadingState) {
                return const ApiLoadingWidget();
              } else if (state is ReturnedStoreErrorState) {
                return Expanded(
                  child: Center(
                    child: MobileAPiError(
                      message: state.error,
                      onTap: () {
                        context
                            .read<ReturnedStoreCubit>()
                            .getReturnedStore(0, '');
                      },
                    ),
                  ),
                );
              } else if (state is ReturnedStoreSuccessState) {
                return Expanded(
                  child: PagedListView<int, ReturnedStoreModel>(
                    pagingController: returnedStoreCubit.pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                        var data = state.data.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MobileBackgroundWidget(
                            child: Column(
                              children: [
                                RowsTextWidget(
                                  title: "Nomi: ",
                                  name: data.store?.name,
                                ),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                  title: "Miqdori: ",
                                  name: moneyFormatterWidthDollor(
                                    double.parse(
                                      data.quantity ?? '0',
                                    ),
                                  ),
                                ),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                  title: "Narxi: ",
                                  name: moneyFormatterWidthDollor(
                                    double.tryParse(data.cost ?? "0.0") ?? 0.0,
                                  ),
                                ),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                    title: "Izoh: ", name: data.comment),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                    title: "Sotuvchi: ", name: data.user!.name),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                  title: "Sana: ",
                                  name: formatDateWithHours(
                                    DateTime.parse(data.createdAt!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (state is ReturnedStoreSearchSuccessState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.data.length,
                    itemBuilder: (context, index) {
                      var data = state.data.data[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MobileBackgroundWidget(
                          child: Column(
                            children: [
                              RowsTextWidget(
                                title: "Nomi: ",
                                name: data.store?.name,
                              ),
                              const Hg(
                                height: 5,
                              ),
                              RowsTextWidget(
                                title: "Miqdori: ",
                                name: moneyFormatterWidthDollor(
                                  double.parse(
                                    data.quantity ?? '0',
                                  ),
                                ),
                              ),
                              const Hg(
                                height: 5,
                              ),
                              RowsTextWidget(
                                title: "Narxi: ",
                                name: moneyFormatterWidthDollor(
                                  double.tryParse(data.cost ?? "0.0") ?? 0.0,
                                ),
                              ),
                              const Hg(
                                height: 5,
                              ),
                              RowsTextWidget(
                                  title: "Izoh: ", name: data.comment),
                              const Hg(
                                height: 5,
                              ),
                              RowsTextWidget(
                                  title: "Sotuvchi: ", name: data.user!.name),
                              const Hg(
                                height: 5,
                              ),
                              RowsTextWidget(
                                title: "Sana: ",
                                name: formatDateWithHours(
                                  DateTime.parse(data.createdAt!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
