import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/customer/cubit/customer_cubit.dart';
import 'package:santexnika_crm/screens/customer/pages/customer_mobile/widget/add.dart';
import 'package:santexnika_crm/screens/main/mobile/widget/nav_bar.dart';
import 'package:santexnika_crm/tools/phone_formatter.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/input/mobile_search.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import 'widget/debt_of_customer.dart';

class CustomerMobileUI extends StatefulWidget {
  const CustomerMobileUI({super.key});

  @override
  State<CustomerMobileUI> createState() => _CustomerMobileUIState();
}

class _CustomerMobileUIState extends State<CustomerMobileUI> {
  bool isAdd = true;
  late final customerCubit = BlocProvider.of<CustomerCubit>(context);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CustomerCubit>().getCustomer(0, '', isMobile: true);
      customerCubit;
      customerCubit.clearData();
    });
    super.initState();
  }

  Timer? _searchTimer;

  void handleSearch(String query) {
    if (mounted) {
      _searchTimer?.cancel();

      _searchTimer = Timer(
        const Duration(milliseconds: 600),
        () {
          if (query.isNotEmpty) {
            searchQuery = query;
            context.read<CustomerCubit>().searchCustomer(query.trim());
          } else {
            context.read<CustomerCubit>().getCustomer(0, "");
          }
        },
      );
    }
  }

  String searchQuery = "";
  int currentPage = 1;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      drawer: const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const TextWidget(txt: "Haridorlar"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.read<CustomerCubit>().getCustomer(0, '');
          });
        },
        child: Column(
          children: [
            const Hg(),
            MobileSearchInput(
              onChanged: (v) {
                handleSearch(v);
              },
            ),
            const Hg(
              height: 2,
            ),
            BlocBuilder<CustomerCubit, CustomerState>(
              buildWhen: (previous, current) =>
                  current is! CustomerForPaginationLoadingState &&
                  current is! CustomerForPaginationErrorState &&
                  current is! CustomerInitial,
              builder: (BuildContext context, state) {
                if (state is CustomerLoadingState) {
                  return const Expanded(child: ApiLoadingWidget());
                } else if (state is CustomerErrorState) {
                  return Expanded(
                    child: Center(
                      child: MobileAPiError(
                        message: state.error,
                        onTap: () {
                          context.read<CustomerCubit>().getCustomer(0, '');
                        },
                      ),
                    ),
                  );
                } else if (state is CustomerSuccessState) {
                  return Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels ==
                                notification.metrics.maxScrollExtent &&
                            notification is ScrollUpdateNotification) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (timeStamp) async {
                              context.read<CustomerCubit>().getCustomer(
                                    currentPage++,
                                    "",
                                    fromLoading: true,
                                    isMobile: true,
                                  );
                            },
                          );
                        }
                        return true;
                      },
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
                                    currentPage = 1;
                                    BlocProvider.of<CustomerCubit>(context)
                                        .clearData();
                                    showMobileDialogWidget(
                                      context,
                                      MobileAddCustomer(
                                        forAdd: false,
                                        name: data.name,
                                        phone: data.phone,
                                        comment: data.comment,
                                        id: data.id,
                                      ),
                                      1.2,
                                      2,
                                    );
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: AppColors.selectedColor,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SlidableAction(
                                  onPressed: (v) async {
                                    BlocProvider.of<CustomerCubit>(context)
                                        .clearData();

                                    context
                                        .read<CustomerCubit>()
                                        .deleteCustomer(data.id!);

                                    await context
                                        .read<CustomerCubit>()
                                        .getCustomer(
                                          0,
                                          '',
                                          isMobile: true,
                                        );
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: AppColors.errorColor,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (timeStamp) async {
                                    context
                                        .read<CustomerWithIdCubit>()
                                        .getCustomerWithId(data.id!);
                                  },
                                );
                                Get.to(
                                  MobileDebtOfCustomer(
                                    name: data.name,
                                    id: data.id!,
                                  ),
                                );
                              },
                              title: MobileBackgroundWidget(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowsTextWidget(
                                      title: "Nomi: ",
                                      name: data.name ?? '',
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: "Telefon nomeri: ",
                                      name: formatPhoneNumber(
                                          data.phone.toString() ?? ''),
                                    ),
                                    const Hg(
                                      height: 5,
                                    ),
                                    RowsTextWidget(
                                      title: "Izoh: ",
                                      name: data.comment ?? '',
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
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<CustomerCubit, CustomerState>(
          buildWhen: (previous, current) =>
              current is CustomerForPaginationLoadingState ||
              current is CustomerSuccessState ||
              current is CustomerForPaginationErrorState ||
              current is CustomerInitial,
          builder: (BuildContext context, state) {
            if (state is CustomerForPaginationErrorState) {
              return const SizedBox();
            } else if (state is CustomerForPaginationLoadingState) {
              return const SizedBox(
                height: 40,
                child: ApiLoadingWidget(),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          currentPage = 1;
          BlocProvider.of<CustomerCubit>(context).clearData();
          showMobileDialogWidget(
            context,
            const MobileAddCustomer(
              forAdd: true,
            ),
            1.2,
            2,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
