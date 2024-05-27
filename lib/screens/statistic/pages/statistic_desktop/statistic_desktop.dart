import 'package:dio_request_inspector/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/models/statistic/store.dart';
import 'package:santexnika_crm/models/statistic/trade.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/screens/statistic/cubits/statistic_cubit.dart';
import 'package:santexnika_crm/screens/statistic/pages/page/customer_statistic.dart';
import 'package:santexnika_crm/screens/statistic/pages/page/store_statistic.dart';
import 'package:santexnika_crm/screens/statistic/pages/page/user_returned_statistic.dart';
import 'package:santexnika_crm/screens/statistic/pages/page/user_statistic.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/line_chart.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../errors/service_error.dart';
import '../../../../models/statistic/branchs.dart';
import '../../../../tools/format_date_time.dart';
import '../../../../widgets/text_widget/text_widget.dart';

class StatisticDesktopUI extends StatefulWidget {
  const StatisticDesktopUI({super.key});

  @override
  State<StatisticDesktopUI> createState() => _StatisticDesktopUIState();
}

class _StatisticDesktopUIState extends State<StatisticDesktopUI> {
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  dynamic selectIndex;
  int? selectedValuee;
  TextEditingController txtDate = TextEditingController();
  bool visible = true;
  int toggleIndex = 0;
  PageController pageController = PageController();

  void switchPage(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TextWidget(txt: "Statistika bo'limi"),
                  const Wd(
                    width: 30,
                  ),
                  Row(
                    children: [
                      BlocBuilder<BranchesCubit, BranchesState>(
                        builder: (context, state) {
                          if (state is BranchesLoadingState) {
                            return const CircularProgressIndicator.adaptive();
                          } else if (state is BranchesErrorState) {
                            return const TextWidget(txt: postError);
                          } else if (state is BranchesSuccessState) {
                            return Visibility(
                              visible: visible,
                              child: Container(
                                height: 40.spMax,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: AppColors.primaryColor,
                                    focusColor: Colors.black,
                                    value: selectedValuee,
                                    items: state.data.map((value) {
                                      return DropdownMenuItem(
                                        value: value.id,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: TextWidget(
                                            txt: value.name ?? "",
                                            txtColor: Colors.white,
                                            size: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValuee = value;
                                      });
                                    },
                                    isExpanded: true,
                                    hint: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: const Text(
                                        "Filialni tanlang",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
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
                      const Wd(
                        width: 30,
                      ),
                    ],
                  ),
                  const Wd(
                    width: 30,
                  ),
                  ButtonWidget(
                    width: 500.w,
                    icon: Icons.calendar_month,
                    label: "Vaqtni tanlash ${startDate}dan ${endDate}gacha ",
                    fontSize: 14.sp,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Vaqtni tanlash'),
                          content: Container(
                            width: 400,
                            height: 200,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => selectDateRange(),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: txtDate,
                                      decoration: const InputDecoration(
                                        labelText: 'Date Range',
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform action with selected date range
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Hg(
              height: 1,
            ),
            const Hg(),
            Scrollbar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleSwitch(
                    minWidth: 200.0.w,
                    activeBgColor: [
                      AppColors.selectedColor,
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: AppColors.toqPrimaryColor,
                    inactiveFgColor: AppColors.whiteColor,
                    initialLabelIndex: toggleIndex,
                    totalSwitches: 6,
                    labels: const [
                      "Kassa ",
                      "Savdo ",
                      'Tovarlar ',
                      'Xodimlar',
                      'Xaridorlar',
                      'Qaytarilganlar',
                    ],
                    onToggle: (v) {
                      toggleIndex = v!;
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) async {
                        if (toggleIndex == 0) {
                          context
                              .read<StatisticCubit>()
                              .getBranchesStatistic(startDate, endDate);
                        } else if (toggleIndex == 1) {
                          context
                              .read<StatisticCubit>()
                              .getTradeStatistic(startDate, endDate);
                        } else if (toggleIndex == 2) {
                          context.read<StatisticCubit>().fetchAndHandleStatistics();

                          context.read<StatisticCubit>().getStoreStatistic();
                        } else if (toggleIndex == 3) {
                          context.read<StatisticCubit>().getUserStatistic();
                        } else if (toggleIndex == 4) {
                          context.read<StatisticCubit>().getCustomerStatistic();
                        } else if (toggleIndex == 5) {
                          context
                              .read<StatisticCubit>()
                              .getUserReturnedStatistic();
                        }
                      });
                      setState(() {});
                      print(toggleIndex);
                    },
                  ),
                ],
              ),
            ),
            const Hg(),
            BlocBuilder<StatisticCubit, StatisticState>(
              builder: (context, state) {
                if (state is StatisticLoading) {
                  return const ApiLoadingWidget();
                } else if (state is StatisticError) {
                  return Center(
                    child: TextWidget(txt: state.error),
                  );
                } else {
                  Widget page;
                  switch (toggleIndex) {
                    case 0:
                      page = _buildBranchesPage(state);
                      break;
                    case 1:
                      page = _buildTradePage(state);
                      break;
                    case 2:
                      page = _buildStorePage(state);
                      break;
                    case 3:
                      page = _buildUsersPage(state);
                      break;
                    case 4:
                      page = _buildCustomerPage(state);
                      break;
                    case 5:
                      page = _buildUsersReturnedPage(state);
                      break;
                    default:
                      page = const SizedBox();
                      break;
                  }
                  return Expanded(
                    child: SingleChildScrollView(
                      child: page,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBranchesPage(StatisticState state) {
    if (state is StatisticBranchesState) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.data.data.length,
        itemBuilder: (context, index) {
          var data = state.data.data[index];
          return _buildBranchCard(data);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 280,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildTradePage(StatisticState state) {
    if (state is StatisticTradeState) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.data.data.length,
        itemBuilder: (context, index) {
          var data = state.data.data[index];
          return _buildTradeCard(data);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 820,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildBranchCard(SaleItem data) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: AppColors.primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filial nomi: ${data.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.whiteColor,
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              _buildStatItem(
                'Ombordagi tovari (UZS)',
                data.comePriceUZS ?? 0.0,
              ),
              _buildStatItem(
                'Ombordagi tovari (USD)',
                data.comePriceUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Jami savdosi (UZS)',
                data.sellPriceUZS ?? 0.0,
              ),
              _buildStatItem(
                'Jami savdosi (USD)',
                data.sellPriceUSD ?? 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeCard(TradeItem data) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: AppColors.primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    txt: 'Filial nomi: ${data.name}',
                  ),
                  TextWidget(
                    txt:
                        'Dollar kursi: ${moneyFormatter(data.avarageDollar ?? 0)}',
                    elips: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStatItem(
                'Umumiy savdo (Som)',
                data.sellPriceUZS ?? 0.0,
              ),
              _buildStatItem(
                'Umumiy savdo (Dollar)',
                data.sellPriceUSD ?? 0.0,
              ),
              _buildStatItem(
                'Umumiy savdo (Naqd)',
                data.sellPriceNAQD ?? 0.0,
              ),
              _buildStatItem(
                'Umumiy savdo (Plastik)',
                data.sellPricePlastik ?? 0.0,
              ),
              _buildStatItem(
                'Umumiy savdo (Click)',
                data.sellPriceClick ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Tovarlar tannarxi narxi (Som)',
                data.productPriceComeUZS ?? 0.0,
              ),
              _buildStatItem(
                'Tovarlar tannarxi narxi (Dollar)',
                data.productPriceComeUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Vozvrat (Som)',
                data.vozvratUZS ?? 0.0,
              ),
              _buildStatItem(
                'Vozvrat (Dollar)',
                data.vozvratUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Qaytim (Som)',
                data.sellPriceBackUZS ?? 0.0,
              ),
              _buildStatItem(
                'Qaytim (USD)',
                data.sellPriceBackUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Nasiya berildi (Som)',
                data.sellPriceNasiyaUZS ?? 0.0,
              ),
              _buildStatItem(
                'Nasiya berildi (Dollar)',
                data.sellPriceNasiyaUSD ?? 0.0,
              ),
              const SizedBox(height: 10),
              const Divider(),
              _buildStatItem(
                'Nasiya keldi (Som)',
                data.customerPaymentUZS ?? 0.0,
              ),
              _buildStatItem(
                'Nasiya keldi (Dollar)',
                data.customerPaymentUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Firmalarga tolovlar (Som)',
                data.toCompanyPaymentUZS ?? 0.0,
              ),
              _buildStatItem(
                'Firmalarga tolovlar (Dollar)',
                data.toCompanyPaymentUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Xarajatlar (UZS)',
                data.expenceUZS ?? 0.0,
              ),
              _buildStatItem(
                'Xarajatlar (USD)',
                data.expenceUSD ?? 0.0,
              ),
              const Divider(),
              _buildStatItem(
                'Kassa (UZS)',
                num.parse(data.kassaUZS.toString()),
              ),
              _buildStatItem(
                'Kassa (USD)',
                num.parse(data.kassaUSD.toString()),
              ),
              const Divider(),
              _buildStatItem(
                'Foyda (Som)',
                data.benefituzs ?? 0.0,
              ),
              _buildStatItem(
                'Foyda (Dollar)',
                data.benefitUSD ?? 0.0,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorePage(StatisticState state) {
     if (state is StatisticTradeAndStoreState) {
      return StatisticDiagramStorePage(
          dataMap: state.storeDate,);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildCustomerPage(StatisticState state) {
    if (state is StatisticSuccessCustomer) {
      return StatisticDiagramCustomerPage(dataMap: state.data);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildUsersPage(StatisticState state) {
    if (state is StatisticSuccessUsers) {
      return StatisticDiagramUserPage(dataMap: state.data);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildUsersReturnedPage(StatisticState state) {
    if (state is StatisticSuccessUsersReturned) {
      return StatisticDiagramUserReturnedPage(dataMap: state.data);
    } else {
      return const SizedBox();
    }
  }

// Define similar methods for other pages (_buildStorePage, _buildUsersPage, _buildCustomerPage, _buildUsersReturnedPage)

  Future<void> selectDateRange() async {
    final initialDate = DateTime.now().subtract(const Duration(days: 30));
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
          start: initialDate, end: initialDate.add(const Duration(days: 30))),
    );

    if (picked != null) {
      setState(() {
        String startDatee = picked.start.toString().split(" ")[0];
        String endDatee = picked.end.toString().split(" ")[0];
        txtDate.text = '$startDate - $endDate';

        startDate = startDatee;
        endDate = endDatee;

        context.read<StatisticCubit>().getBranchesStatistic(startDate, endDate);
        context.read<StatisticCubit>().getTradeStatistic(startDate, endDate);
      });
    }
  }

  String startDate = DateTime.now()
      .subtract(const Duration(days: 30))
      .toString()
      .split(" ")[0];
  String endDate = DateTime.now().toString().split(" ")[0];

  Widget _buildStatItem(String title, num value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          moneyFormatter(double.parse(value.toString())),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
