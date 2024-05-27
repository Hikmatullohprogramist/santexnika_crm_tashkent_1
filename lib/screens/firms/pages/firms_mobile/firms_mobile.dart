import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/firms/pages/firms_mobile/mobile_widget/add_firms.dart';
import 'package:santexnika_crm/screens/main/mobile/widget/nav_bar.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';

import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

import '../../../../widgets/dismissible.dart';
import 'mobile_widget/debt_of_firms.dart';

class FirmsMobileUI extends StatefulWidget {
  const FirmsMobileUI({super.key});

  @override
  State<FirmsMobileUI> createState() => _FirmsMobileUIState();
}

class _FirmsMobileUIState extends State<FirmsMobileUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        context.read<CompanyCubit>().getCompany(0);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        title: const TextWidget(txt: "Firmalar"),
      ),
      body: Column(
        children: [
          // const Hg(),
          // MobileSearchInput(
          //   onChanged: (v) {},
          // ),
          const Hg(
            height: 5,
          ),
          BlocBuilder<CompanyCubit, CompanyState>(
            builder: (BuildContext context, state) {
              if (state is CompanyLoadingState) {
                return Expanded(child: Center(child: const ApiLoadingWidget()));
              } else if (state is CompanyErrorState) {
                return Expanded(
                  child: Center(
                    child: MobileAPiError(
                      message: state.error,
                      onTap: () {
                        context.read<CompanyCubit>().getCompany(0);
                      },
                    ),
                  ),
                );
              } else if (state is CompanySuccessState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.data.length,
                    itemBuilder: (context, index) {
                      var data = state.data.data[index];
                      return ListTile(
                        title: DismissibleWidget(
                          // endActionPane: ActionPane(
                          //   motion: const StretchMotion(),
                          //   children: [
                          //     SlidableAction(
                          //       onPressed: (v) {
                          //         context
                          //             .read<CompanyCubit>()
                          //             .deleteCompany(data.id!);
                          //       },
                          //       icon: Icons.delete,
                          //       backgroundColor: AppColors.errorColor,
                          //       foregroundColor: Colors.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ],
                          // ),

                          value: data,
                          onDismissed: (v) {
                            context
                                .read<CompanyCubit>()
                                .deleteCompany(data.id!);
                          },
                          child: MobileBackgroundWidget(
                            onTap: () {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (timeStamp) async {
                                  context.read<ShowCompanyCubit>().showCompany(
                                        data.id!,
                                      );
                                },
                              );
                              Get.to(
                                MobileDebtOfFirms(
                                  id: data.id!,
                                  name: data.name,
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                RowsTextWidget(
                                  title: 'Nomi: ',
                                  name: data.name,
                                ),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                  title: 'Telefon nomer: ',
                                  name: data.phone,
                                ),
                                const Hg(
                                  height: 5,
                                ),
                                RowsTextWidget(
                                  title: 'Sana: ',
                                  name: formatDate(
                                    DateTime.parse(data.createdAt ?? ''),
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
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMobileDialogWidget(
            context,
            MobileAddFirms(),
            1.2,
            2,
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
