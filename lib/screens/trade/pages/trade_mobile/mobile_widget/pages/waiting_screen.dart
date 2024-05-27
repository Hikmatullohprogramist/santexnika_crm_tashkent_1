import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_cubit.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_state.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile/one_button.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';

import '../../../../../../tools/appColors.dart';
import '../../../../../../widgets/sized_box.dart';
import '../../../../../../widgets/text_widget/text_widget.dart';
import '../../../../cubit/waiting/trade_cubit/basket_cubit.dart';
import '../../../../cubit/waiting/waitingWithId/waitin_with_id_cubit.dart';

class WaitingMobileUI extends StatefulWidget {
  const WaitingMobileUI({super.key});

  @override
  State<WaitingMobileUI> createState() => _WaitingMobileUIState();
}

class _WaitingMobileUIState extends State<WaitingMobileUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WaitingCubit>().getWaiting();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextWidget(txt: "Vaqtinchalik kutish"),
        const Hg(),
        BlocBuilder<WaitingCubit, WaitingState>(
          builder: (BuildContext context, state) {
            if (state is WaitingLoadingState) {
              return const Expanded(
                child: ApiLoadingWidget(),
              );
            } else if (state is WaitingErrorState) {
              return Expanded(
                child: Center(
                  child: MobileAPiError(
                    message: state.message,
                    onTap: () {
                      context.read<WaitingCubit>().getWaiting();
                    },
                  ),
                ),
              );
            } else if (state is WaitingOrdersSuccessState) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (con, index) {
                    var data = state.data[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MobileBackgroundWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const TextWidget(
                                  txt: "Mijoz: ",
                                  elips: true,
                                ),
                                Expanded(
                                  child: TextWidget(
                                    txt:
                                        "${data.customer?.name ?? 'Xaridorsiz savod'} ",
                                    size: 16,
                                    fontWeight: FontWeight.w400,
                                    elips: true,
                                  ),
                                ),
                              ],
                            ),
                            const Hg(),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    txt: "Sotuvchi: ",
                                    elips: true,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    txt: "Chek id: ",
                                    elips: true,
                                  ),
                                ),
                              ],
                            ),
                            const Hg(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    txt: data.user?.name ?? '',
                                    elips: true,
                                    size: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Wd(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextWidget(
                                    txt: '${data.id ?? '0'}',
                                    elips: true,
                                    size: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const Hg(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.bottombarColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColors.borderColor)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.remove_shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Wd(),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<WaitingWithIdCubit>()
                                          .unWaitingWithId(data.id!)
                                          .then((value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          context
                                              .read<WaitingCubit>()
                                              .getWaiting();
                                          context
                                              .read<BasketCubit>()
                                              .getBasket();
                                        });
                                        Get.back();
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.bottombarColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: AppColors.borderColor,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Icon(
                                          Icons.add_shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        const Hg(),
        OneButton(
          onTap: () {
            Get.back();
          },
          width: double.infinity,
          label: "Bekor qilish",
          icon: Icon(
            Icons.exit_to_app,
            color: AppColors.whiteColor,
            size: 20,
          ),
        )
      ],
    );
  }
}
